import random
import itertools

import numpy as np
import tensorflow as tf

    

from .input import Dataset
from .ptrnet import ptr_decoder
from .feature_emb import *
from pprint import pprint

from match_lstm.my.tensorflow.nn import softsel, get_logits, highway_network, multi_conv1d, softmax
from match_lstm.my.tensorflow.rnn_cell import AttentionCell
from match_lstm.my.tensorflow.lstm_ops import LSTMBlockFusedCell

from tensorflow.contrib.rnn import BasicLSTMCell, LSTMStateTuple, MultiRNNCell, DropoutWrapper, TimeReversedFusedRNN

def get_multi_gpu_models(config):
    models = []
    with tf.variable_scope(""):
        for gpu_idx in range(config.num_gpus):
            with tf.name_scope("model_{}".format(gpu_idx)) as scope, tf.device("/{}:{}".format(config.device_type, gpu_idx)):
                if gpu_idx > 0:
                    tf.get_variable_scope().reuse_variables()
                model = Model(config, scope, rep=gpu_idx == 0)
                models.append(model)

    with tf.variable_scope('loss_summary', reuse=False):
        for gpu_idx in range(config.num_gpus):
            with tf.name_scope("model_{}".format(gpu_idx)) as scope, tf.device("/{}:{}".format(config.device_type, gpu_idx)):
                model = models[gpu_idx]
                rep = gpu_idx == 0
                if rep:
                    model._build_var_ema()
                if config.mode == 'train':
                    model._build_ema()
                model.summary = tf.summary.merge_all()
                # model.summary = tf.summary.merge(tf.get_collection("summaries", scope=model.scope))
    return models


class Model(object):
    def __init__(self, config, scope, rep=True):
        self.scope = scope
        self.config = config

        if config.mode in ['test', 'forward'] and config.input_keep_prob != 1.0:
            tf.logging.warning('input_keep_prob(%f) != 1 while in inference mode!', self.config.input_keep_prob)

        self.global_step = tf.get_variable('global_step', shape=[], dtype='int32',
                                           initializer=tf.constant_initializer(0), trainable=False)

        # Define forward inputs here
        N, VW, VC = \
            config.batch_size, config.word_vocab_size, config.char_vocab_size
        self.x_char = tf.placeholder(tf.int32, [N, None], name='x_char')
        self.x_word = tf.placeholder(tf.int32, [N, None], name='x_word')
        self.x_mask = tf.placeholder(tf.bool, [N, None], name='x_mask')
        self.q_char = tf.placeholder(tf.int32, [N, None], name='q_char')
        self.q_word = tf.placeholder(tf.int32, [N, None], name='q_word')
        self.q_mask = tf.placeholder(tf.bool, [N, None], name='q_mask')
        self.answer = tf.placeholder(tf.int32, [N, None], name='answer')
        self.answer_mask = tf.placeholder(tf.bool, [N, None], name='answer_mask')
        self.answer_classify = tf.placeholder(tf.int32, [N], name='answer_classify')
        self.new_char_emb_mat = tf.placeholder(tf.float32, [None, config.char_emb_size], name='new_char_emb_mat')
        self.new_word_emb_mat = tf.placeholder(tf.float32, [None, config.word_emb_size], name='new_word_emb_mat')

        # Embedding Index for Feature Engeering
        ## Concept Embeddings
        if self.config.use_concept_emb != 'no':
            self.concept_emb_index = tf.placeholder(tf.int32, [N], 'concept_emb_index')
        if self.config.use_concept_freq_emb != 'no':
            self.concept_freq_emb_index = tf.placeholder(tf.int32, [N],
                    'concept_freq_emb_index')

        ## Frequency Embeddings
        if self.config.use_mention_freq_emb != 'no':
            self.mention_freq_emb_index = tf.placeholder(tf.int32, [N, None],
                    'mention_freq_emb_index')
        if self.config.use_pre_mention_freq_emb != 'no':
            self.pre_mention_freq_emb_index = tf.placeholder(tf.int32, [N, None],
                    'pre_mention_freq_emb_index')
        if self.config.use_post_mention_freq_emb != 'no':
            self.post_mention_freq_emb_index = tf.placeholder(tf.int32, [N, None],
                    'post_mention_freq_emb_index')

        ## Positional Embeddings
        if self.config.use_mention_positional_emb != 'no':
            self.mention_positional_emb_index = tf.placeholder(tf.int32, [N, None],
                    'mention_positional_emb_index')
        if self.config.use_second_mention_positional_emb != 'no':
            self.second_mention_positional_emb_index = tf.placeholder(tf.int32, [N, None],
                    'second_mention_positional_emb_index')

        ## Concept mention list
        if self.config.use_mention_list:
            if self.config.use_mention_list_positional_emb != 'no':
                self.mention_list_positional_emb_index_l2r = tf.placeholder(tf.int32, [N, None],
                        'mention_list_positional_emb_index_l2r')
                self.mention_list_positional_emb_index_r2l = tf.placeholder(tf.int32, [N, None],
                        'mention_list_positional_emb_index_r2l')
            if self.config.use_mention_list_freq_emb != 'no':
                self.mention_list_freq_emb_index = tf.placeholder(tf.int32, [N, None],
                        'mention_list_freq_emb_index')

        # Define misc
        self.tensor_dict = {}

        # Forward outputs / loss inputs
        self.logits = None

        # Loss outputs
        self.loss = None

        self._build_forward()
        self._build_loss()
        self.var_ema = None

    def _build_forward(self):
        config = self.config
        N, VW, VC, d = \
            config.batch_size, \
            config.word_vocab_size, config.char_vocab_size, config.hidden_size
        JX = tf.shape(self.x_char)[1]
        JQ = tf.shape(self.q_char)[1]
        JA = tf.shape(self.answer)[1]  # EOS symbol is included
        tf.logging.debug("VW: %s, N: %s, JX: %s, JQ: %s, JA: %s", str(VW), str(N), str(JX), str(JQ), str(JA))
        dc, dw = config.char_emb_size, config.word_emb_size

        with tf.variable_scope("emb"):
            # char embedding
            if config.use_char_emb:
                with tf.variable_scope("emb_var"), tf.device("/cpu:0"):
                    if config.input_layer_init_method == 'word2vec':
                        char_emb_mat = tf.get_variable("char_emb_mat", shape=[VC, dc], dtype='float',
                                                       initializer=tf.constant_initializer(config.char_emb_mat),
                                                       trainable=config.finetune)
                    elif config.input_layer_init_method == 'zero':
                        char_emb_mat = tf.get_variable("char_emb_mat", shape=[VC, dc], dtype='float',
                                                       initializer=tf.constant_initializer(0),
                                                       trainable=config.finetune)
                    elif config.input_layer_init_method == 'random':
                        char_emb_mat = tf.get_variable("char_emb_mat", shape=[VC, dc], dtype='float',
                                                       initializer=tf.constant_initializer(np.random.rand(VC, dc)),
                                                       trainable=config.finetune)
                    else:
                        tf.logging.error('Invid value of input_layer_init_method.')

                with tf.variable_scope("char"):
                    Ax_char = tf.nn.embedding_lookup(char_emb_mat, self.x_char)  # [N, JX, dc]
                    Aq_char = tf.nn.embedding_lookup(char_emb_mat, self.q_char)  # [N, JQ, dc]
            else:
                Ax_char = None
                Aq_char = None

            # char CNN
            # filter_sizes = list(map(int, config.out_channel_dims.split(',')))
            # heights = list(map(int, config.filter_heights.split(',')))
            # assert sum(filter_sizes) == dco, (filter_sizes, dco)
            # with tf.variable_scope("conv"):
            #     xx = multi_conv1d(Acx, filter_sizes, heights, "VALID", config.keep_prob, scope="xx")
            #     if config.share_cnn_weights:
            #         tf.get_variable_scope().reuse_variables()
            #         qq = multi_conv1d(Acq, filter_sizes, heights, "VALID", config.keep_prob, scope="xx")
            #     else:
            #         qq = multi_conv1d(Acq, filter_sizes, heights, "VALID", config.keep_prob, scope="qq")
            #     xx = tf.reshape(xx, [-1, M, JX, dco])
            #     qq = tf.reshape(qq, [-1, JQ, dco])

            # word embedding
            if config.use_word_emb:
                with tf.variable_scope("emb_var") as scope, tf.device("/cpu:0"):

                    if config.input_layer_init_method == 'word2vec':
                        word_emb_mat = tf.get_variable("word_emb_mat", dtype='float', shape=[VW, dw],
                                                       initializer=tf.constant_initializer(config.word_emb_mat),
                                                       trainable=config.finetune)
                    elif config.input_layer_init_method == 'zero':
                        word_emb_mat = tf.get_variable("word_emb_mat", dtype='float', shape=[VW, dw],
                                                       initializer=tf.constant_initializer(0),
                                                       trainable=config.finetune)
                    elif config.input_layer_init_method == 'random':
                        word_emb_mat = tf.get_variable("word_emb_mat", dtype='float', shape=[VW, dw],
                                                       initializer=tf.constant_initializer(np.random.rand(VW, dw)),
                                                       trainable=config.finetune)
                    else:
                        tf.logging.error('Invid value of input_layer_init_method.')

                    tf.get_variable_scope().reuse_variables()
                    if config.use_glove_for_unk:
                        word_emb_mat = tf.concat([word_emb_mat, self.new_word_emb_mat], 0)

                with tf.name_scope("word"):
                    Ax_word = tf.nn.embedding_lookup(word_emb_mat, self.x_word)  # [N, JX, dw]
                    Aq_word = tf.nn.embedding_lookup(word_emb_mat, self.q_word)  # [N, JQ, dw]
                    self.tensor_dict['x_word'] = Ax_word
                    self.tensor_dict['q_word'] = Aq_word
            else:
                Ax_word = None
                Aq_word = None

            # build embedding vector for passages and questions
            if config.use_char_emb and config.use_word_emb:
                xx = tf.concat([Ax_char, Ax_word], 2)  # [N, JX, dc+dw]
                qq = tf.concat([Aq_char, Aq_word], 2)  # [N, JQ, dc+dw]
            elif config.use_char_emb:
                xx = Ax_char  # [N, JX, dc]
                qq = Aq_char  # [N, JQ, dc]
            elif config.use_word_emb:
                xx = Ax_word  # [N, JX, dw]
                qq = Aq_word  # [N, JQ, dw]
            else:
                xx = None
                qq = None

        # highway network
        if config.highway:
            with tf.variable_scope("highway"):
                xx = highway_network(xx, config.highway_num_layers, True, wd=config.wd)
                tf.get_variable_scope().reuse_variables()
                qq = highway_network(qq, config.highway_num_layers, True, wd=config.wd)

        self.tensor_dict['xx'] = xx
        self.tensor_dict['qq'] = qq

        x_len = tf.reduce_sum(tf.cast(self.x_mask, 'int32'), 1)  # [N]
        q_len = tf.reduce_sum(tf.cast(self.q_mask, 'int32'), 1)  # [N]

        # Embeddings for feature engeering
        pos_to_embeddings_list = {'before_context':[], 'att_sim':[],
                                  'att_out':[], 'att_sim_dot':[], 'att_out_dot':[],
                                  'before_context_q':[], 'att_sim_q':[]}
        def add_pos_to_embeddings_list(name, pos_list, Aemb):
            if pos_list != 'no':
                for _pos in pos_list.split(','):
                    pos_to_embeddings_list[_pos].append((name, Aemb))
        with tf.variable_scope("feature_emb"):
            # Concept Embeddings
            if self.config.use_concept_emb != 'no':
                with tf.variable_scope("concept_emb"):
                    concept_emb = tf.get_variable('concept_emb', dtype='float',
                                                  shape=[self.config.concept_vocab_size, d], trainable=True)
                    concept_emb_index_ext = tf.tile(tf.expand_dims(self.concept_emb_index, axis=1), [1, JX])
                    Aconcept_emb = tf.nn.embedding_lookup(concept_emb, concept_emb_index_ext)
                    add_pos_to_embeddings_list('concept_emb', self.config.use_concept_emb,
                                               Aconcept_emb)
            if self.config.use_concept_freq_emb != 'no':
                with tf.variable_scope("concept_freq_emb"):
                    concept_freq_emb = tf.get_variable('concept_freq_emb', dtype='float',
                                                       shape=[self.config.concept_discrete_freq_bin, d // 8])
                    concept_freq_emb_index_ext = tf.tile(tf.expand_dims(self.concept_freq_emb_index, axis=1), [1, JX])
                    Aconcept_freq_emb = tf.nn.embedding_lookup(concept_freq_emb,
                                                               concept_freq_emb_index_ext)
                    add_pos_to_embeddings_list('concept_freq_emb', self.config.use_concept_freq_emb,
                                               Aconcept_freq_emb)

            # Frequency Embeddings
            if self.config.use_mention_freq_emb != 'no':
                with tf.variable_scope("mention_freq_emb"):
                    mention_freq_emb = tf.get_variable('mention_freq_emb', dtype='float',
                                                       shape=[self.config.char_discrete_freq_bin, d // 8])
                    Amention_freq_emb = tf.nn.embedding_lookup(mention_freq_emb,
                                                               self.mention_freq_emb_index)
                    add_pos_to_embeddings_list('mention_freq_emb', self.config.use_mention_freq_emb,
                                               Amention_freq_emb)
            if self.config.use_pre_mention_freq_emb != 'no':
                with tf.variable_scope("pre_mention_freq_emb"):
                    pre_mention_freq_emb = tf.get_variable('pre_mention_freq_emb', dtype='float',
                                                           shape=[self.config.char_discrete_freq_bin, d // 8])
                    Apre_mention_freq_emb = tf.nn.embedding_lookup(pre_mention_freq_emb,
                                                                   self.pre_mention_freq_emb_index)
                    add_pos_to_embeddings_list('pre_mention_freq_emb', self.config.use_pre_mention_freq_emb,
                                               Apre_mention_freq_emb)
            if self.config.use_post_mention_freq_emb != 'no':
                with tf.variable_scope("post_mention_freq_emb"):
                    post_mention_freq_emb = tf.get_variable('post_mention_freq_emb', dtype='float',
                                                            shape=[self.config.char_discrete_freq_bin, d // 8])
                    Apost_mention_freq_emb = tf.nn.embedding_lookup(post_mention_freq_emb,
                                                                    self.post_mention_freq_emb_index)
                    add_pos_to_embeddings_list('post_mention_freq_emb', self.config.use_post_mention_freq_emb,
                                               Apost_mention_freq_emb)

            # Positional Embeddings
            if self.config.use_mention_positional_emb != 'no':
                #with tf.variable_scope("mention_positional_emb"):
                mention_positional_emb = tf.get_variable("mention_positional_emb", dtype='float',
                                                         shape=[self.config.mention_positional_vocab_size, d // 8],
                                                         trainable=True)
                Amention_positional_emb = tf.nn.embedding_lookup(mention_positional_emb,
                                                                 self.mention_positional_emb_index)  # [N, JX, d//8]
                add_pos_to_embeddings_list('mention_positional_emb',
                                           self.config.use_mention_positional_emb,
                                           Amention_positional_emb)

            if self.config.use_second_mention_positional_emb != 'no':
                second_mention_positional_emb = tf.get_variable("second_mention_positional_emb", dtype='float',
                                                                shape=[self.config.mention_positional_vocab_size, d // 8],
                                                                trainable=True)
                Asecond_mention_positional_emb = tf.nn.embedding_lookup(second_mention_positional_emb,
                                                                        self.second_mention_positional_emb_index)  # [N, JX, d//8]
                add_pos_to_embeddings_list('second_mention_positional_emb',
                                           self.config.use_second_mention_positional_emb,
                                           Asecond_mention_positional_emb)

            # Concept mention list
            if self.config.use_mention_list:
                if self.config.use_mention_list_positional_emb != 'no':
                    with tf.variable_scope("mention_list_positional_emb_l2r"):
                        mention_list_positional_emb_l2r = tf.get_variable("mention_list_positional_emb_l2r",
                                                                          dtype='float',
                                                                          shape=[self.config.mention_list_positional_vocab_size, d // 8],
                                                                          trainable=True)
                        Amention_list_positional_emb_l2r = tf.nn.embedding_lookup(mention_list_positional_emb_l2r,
                                                                                  self.mention_list_positional_emb_index_l2r)
                        add_pos_to_embeddings_list('mention_list_positional_emb_l2r',
                                                   self.config.use_mention_list_positional_emb,
                                                   Amention_list_positional_emb_l2r)
                    with tf.variable_scope("mention_list_positional_emb_r2l"):
                        mention_list_positional_emb_r2l = tf.get_variable("mention_list_positional_emb_r2l",
                                                                          dtype='float',
                                                                          shape=[self.config.mention_list_positional_vocab_size, d // 8],
                                                                          trainable=True)
                        Amention_list_positional_emb_r2l = tf.nn.embedding_lookup(mention_list_positional_emb_r2l,
                                                                                  self.mention_list_positional_emb_index_r2l)
                        add_pos_to_embeddings_list('mention_list_positional_emb_r2l',
                                                   self.config.use_mention_list_positional_emb,
                                                   Amention_list_positional_emb_r2l)
                if self.config.use_mention_list_freq_emb != 'no':
                    with tf.variable_scope("mention_list_freq_emb"):
                        mention_list_freq_emb = tf.get_variable("mention_list_freq_emb",
                                                                dtype='float',
                                                                shape=[self.config.mention_discrete_freq_bin, d // 8],
                                                                trainable=True)
                        Amention_list_freq_emb = tf.nn.embedding_lookup(mention_list_freq_emb,
                                                                        self.mention_list_freq_emb_index)
                        add_pos_to_embeddings_list('mention_list_freq_emb', self.config.use_mention_list_freq_emb,
                                                   Amention_list_freq_emb)

        # concat xx
        if len(pos_to_embeddings_list['before_context']) > 0:
            assert config.share_lstm_weights == False
            xx = tf.concat([xx] + [Aemb for name, Aemb in pos_to_embeddings_list['before_context']], axis=2)

        # concat qq
        if len(pos_to_embeddings_list['before_context_q']) > 0:
            assert config.share_lstm_weights == False
            qq = tf.concat([qq] + [Aemb for name, Aemb in pos_to_embeddings_list['before_context_q']], axis=2)

        with tf.variable_scope("prep"):
            if config.use_fused_lstm:
                with tf.variable_scope("u1"):
                    fw_inputs = tf.transpose(qq, [1, 0, 2]) #[time_len, batch_size, input_size]
                    bw_inputs = fw_inputs
                    fw_inputs = variational_dropout(fw_inputs, config.input_keep_prob,
                                                    seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                    bw_inputs = variational_dropout(bw_inputs, config.input_keep_prob,
                                                    seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                    prep_fw_cell = LSTMBlockFusedCell(d, cell_clip=config.cell_clip, weight_keep_prob=config.weight_keep_prob,
                                                      init_w='block_orth_normal_initializer' if config.use_orth_normal_init else None)
                    prep_bw_cell = TimeReversedFusedRNN(prep_fw_cell)
                    fw_outputs, fw_final = prep_fw_cell(fw_inputs, dtype=tf.float32, sequence_length=q_len, scope="fw")
                    bw_outputs, bw_final = prep_bw_cell(bw_inputs, dtype=tf.float32, sequence_length=q_len, scope="bw")
                    current_inputs = tf.concat((fw_outputs, bw_outputs), 2)
                    output = tf.transpose(current_inputs, [1, 0, 2])
                    u = output
                if config.share_lstm_weights:
                    tf.get_variable_scope().reuse_variables()
                    with tf.variable_scope("u1"):
                        fw_inputs = tf.transpose(xx, [1, 0, 2]) #[time_len, batch_size, input_size]
                        bw_inputs = fw_inputs
                        fw_inputs = variational_dropout(fw_inputs, config.input_keep_prob,
                                                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                        bw_inputs = variational_dropout(bw_inputs, config.input_keep_prob,
                                                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                        fw_outputs, fw_final = prep_fw_cell(fw_inputs, dtype=tf.float32, sequence_length=x_len, scope="fw")
                        bw_outputs, bw_final = prep_bw_cell(bw_inputs, dtype=tf.float32, sequence_length=x_len, scope="bw")
                        current_inputs = tf.concat((fw_outputs, bw_outputs), 2)
                        output = tf.transpose(current_inputs, [1, 0, 2])
                        h = output
                else:
                    with tf.variable_scope("h1"):
                        fw_inputs = tf.transpose(xx, [1, 0, 2]) #[time_len, batch_size, input_size]
                        bw_inputs = fw_inputs
                        fw_inputs = variational_dropout(fw_inputs, config.input_keep_prob,
                                                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                        bw_inputs = variational_dropout(bw_inputs, config.input_keep_prob,
                                                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                        prep_fw_cell = LSTMBlockFusedCell(d, cell_clip=config.cell_clip, weight_keep_prob=config.weight_keep_prob,
                                                          init_w='block_orth_normal_initializer' if config.use_orth_normal_init else None)
                        prep_bw_cell = TimeReversedFusedRNN(prep_fw_cell)
                        fw_outputs, fw_final = prep_fw_cell(fw_inputs, dtype=tf.float32, sequence_length=x_len, scope="fw")
                        bw_outputs, bw_final = prep_bw_cell(bw_inputs, dtype=tf.float32, sequence_length=x_len, scope="bw")
                        current_inputs = tf.concat((fw_outputs, bw_outputs), 2)
                        output = tf.transpose(current_inputs, [1, 0, 2])
                        h = output
            else:
                prep_fw_cell = DropoutWrapper(BasicLSTMCell(d),
                                              input_keep_prob=config.input_keep_prob,
                                              variational_recurrent=config.use_variational_dropout)
                prep_bw_cell = DropoutWrapper(BasicLSTMCell(d),
                                              input_keep_prob=config.input_keep_prob,
                                              variational_recurrent=config.use_variational_dropout)
                (fw_u, bw_u), _ = tf.nn.bidirectional_dynamic_rnn(prep_fw_cell,
                                                                  prep_bw_cell,
                                                                  qq, q_len, dtype='float',
                                                                  parallel_iterations=config.rnn_parallel_iterations,
                                                                  swap_memory=config.rnn_swap_memory,
                                                                  scope='u1')  # [N, JQ, d]
                u = tf.concat([fw_u, bw_u], 2)  # [N, JQ, 2d]
                if config.share_lstm_weights:
                    tf.get_variable_scope().reuse_variables()
                    (fw_h, bw_h), _ = tf.nn.bidirectional_dynamic_rnn(prep_fw_cell, prep_bw_cell, xx, x_len, dtype='float',
                                                                      parallel_iterations=config.rnn_parallel_iterations,
                                                                      swap_memory=config.rnn_swap_memory,
                                                                      scope='u1')  # [N, JX, d]
                    h = tf.concat([fw_h, bw_h], 2)  # [N, JX, 2d]
                else:
                    prep_question_fw_cell = DropoutWrapper(BasicLSTMCell(d),
                                                           input_keep_prob=config.input_keep_prob,
                                                           variational_recurrent=config.use_variational_dropout)
                    prep_question_bw_cell = DropoutWrapper(BasicLSTMCell(d),
                                                           input_keep_prob=config.input_keep_prob,
                                                           variational_recurrent=config.use_variational_dropout)
                    (fw_h, bw_h), _ = tf.nn.bidirectional_dynamic_rnn(prep_question_fw_cell,
                                                                      prep_question_bw_cell,
                                                                      xx, x_len, dtype='float',
                                                                      parallel_iterations=config.rnn_parallel_iterations,
                                                                      swap_memory=config.rnn_swap_memory,
                                                                      scope='h1')  # [N, JX, d]
                    h = tf.concat([fw_h, bw_h], 2)  # [N, JX, 2d]
            self.tensor_dict['u'] = u
            self.tensor_dict['h'] = h

        with tf.variable_scope("main"):
            p0 = attention_layer(config, h, u, h_mask=self.x_mask, u_mask=self.q_mask, scope="p0",
                                 tensor_dict=self.tensor_dict, pos_to_embeddings_list=pos_to_embeddings_list)

        with tf.variable_scope('modeling_layer'):
            if config.use_fused_lstm:
                encoder_output, encoder_state_final = build_fused_bidirectional_rnn(inputs=p0,
                                                                                    num_units=config.hidden_size,
                                                                                    num_layers=config.num_modeling_layers,
                                                                                    inputs_length=x_len,
                                                                                    input_keep_prob=config.input_keep_prob,
                                                                                    scope='modeling_layer_g',
                                                                                    config=config)
            else:
                encoder_output, encoder_state_final = multi_layer_rnn(config=config,
                                                                      input=p0,
                                                                      input_len=x_len,
                                                                      num_layers=config.num_modeling_layers,
                                                                      scope_prefix='modeling_layer_g',
                                                                      dtype=tf.float32)

        # Self match layer
        if config.use_self_match:
            encoder_output, encoder_state_final = self_attention_layer_rnn(config=config,
                                                                           inputs=tf.reshape(encoder_output, [N, JX, 2 * d]),  # [N, JX, 2d]
                                                                           input_len=x_len,
                                                                           x_mask=tf.reshape(self.x_mask, [N, JX]),  # [N, JX]
                                                                           num_units=d,
                                                                           dtype=tf.float32)

        tf.logging.debug("encoder_state_final: %s", str(encoder_state_final))

        with tf.variable_scope("text_output"):
            answer = self.answer  # [N, JA]
            tf.logging.debug("answer: %s", str(answer))
            answer_mask = self.answer_mask  # [N, JA]
            tf.logging.debug("answer_mask: %s", str(answer_mask))
            answer_length_with_eos = tf.count_nonzero(self.answer_mask, 1, dtype=tf.int32)  # [N]
            self.answer_length_with_eos = answer_length_with_eos
            tf.logging.debug("answer_length_with_eos: %s", str(answer_length_with_eos))

            num_ptrnet_layers = self.config.num_ptrnet_layers
            decoder_cell = MultiRNNCell([DropoutWrapper(BasicLSTMCell(2 * d), input_keep_prob=config.input_keep_prob)
                                         for _ in range(num_ptrnet_layers)])

            with tf.variable_scope("Decoder") as scope:
                decoder_train_logits = ptr_decoder(decoder_cell,
                                                   tf.reshape(h, [N, JX, 2 * d]),  # [N, JX, 2d]
                                                   tf.reshape(encoder_output, [N, JX, 2 * d]),  # [N, JX, 2d]
                                                   x_len,
                                                   encoder_final_state=encoder_state_final,
                                                   max_enc_width=config.sent_size_th,
                                                   enc_pad_len=1 + config.max_symbol_offset,  # 2: NEXT and EOS
                                                   decoder_output_length=answer_length_with_eos,  # [N]
                                                   batch_size=N,  # N
                                                   attention_proj_dim=self.config.decoder_proj_dim,
                                                   parallel_iterations=config.rnn_parallel_iterations,
                                                   swap_memory=config.rnn_swap_memory,
                                                   scope='ptr_decoder')  # [batch_size, dec_len*, JX + 2]

                self.decoder_train_logits = decoder_train_logits
                tf.logging.debug("decoder_train_logits: %s", str(decoder_train_logits))
                self.decoder_softmax = tf.nn.softmax(self.decoder_train_logits)
                self.decoder_inference = tf.argmax(decoder_train_logits, axis=2,
                                                   name='decoder_inference')  # [N, JA]
                self.JX = JX

        with tf.variable_scope("classify_encoder"):
            if config.num_classify_layers == 0:
                classify_encoder_output = encoder_output
                classify_encoder_final_state = encoder_state_final
            else:
                if config.use_fused_lstm:
                    classify_encoder_output, classify_encoder_final_state = build_fused_bidirectional_rnn(inputs=encoder_output,
                                                                                                          num_units=config.hidden_size,
                                                                                                          num_layers=config.num_classify_layers,
                                                                                                          inputs_length=x_len,
                                                                                                          input_keep_prob=config.input_keep_prob,
                                                                                                          scope='classify_encoder_layer_t',
                                                                                                          config=config)
                else:
                    classify_encoder_output, classify_encoder_final_state = \
                        multi_layer_rnn(config=config,
                                        input=encoder_output,
                                        input_len=x_len,
                                        num_layers=config.num_classify_layers,
                                        scope_prefix='classify_encoder_layer_t',
                                        dtype=tf.float32)
            tf.logging.debug("classify_encoder_final_state: %s", str(classify_encoder_final_state))

        with tf.variable_scope("Classifier"):
            encoder_state_final_concat = tf.concat(classify_encoder_final_state, axis=1)  # [N, 4d]
            classify_logit = tf.contrib.layers.fully_connected(encoder_state_final_concat,
                                                               config.max_num_classes,
                                                               scope='classify_fc')
            tf.logging.debug('classify_logit: %s', str(classify_logit))
            self.classify_logit = classify_logit
            self.classify_softmax = tf.nn.softmax(classify_logit)
            self.classify_inference = tf.argmax(classify_logit, axis=1, name='classify_inference')

    def _build_loss(self):
        with tf.variable_scope("loss"):
            N = self.config.batch_size
            JX = tf.shape(self.x_char)[1]
            JQ = tf.shape(self.q_char)[1]
            JA = tf.reduce_max(self.answer_length_with_eos)

            with tf.variable_scope("decoder_loss"):

                logits = self.decoder_train_logits[
                         :,
                         :JA,
                         :]  # [N, -1, JX + 2] -> [N, JA, JX + 2]
                targets = self.answer[:, :JA]  # [N, -1] -> [N, JA]
                tf.logging.debug("logits: %s, targets: %s", str(logits), str(targets))
                if self.config.print_decoder_output:
                    logits = tf.Print(logits, [tf.shape(logits), tf.argmax(logits, 2)], 'logits: ', summarize=100)
                    targets = tf.Print(targets, [targets], 'targets: ', summarize=100)

                self.logits = logits
                self.targets = targets

                weights_mask = self.answer_mask[:, :JA] # [N, JA]
                decoder_loss = tf.contrib.seq2seq.sequence_loss(logits=logits, targets=targets,
                                                                weights=tf.cast(weights_mask, tf.float32))
                tf.summary.scalar(decoder_loss.op.name, decoder_loss)
                decoder_loss *= self.config.w_decoder
                tf.add_to_collection(tf.GraphKeys.LOSSES, decoder_loss)
                self.decoder_loss = decoder_loss

            with tf.variable_scope("classify_loss"):
                classify_mask = tf.greater_equal(self.answer_classify, 0)
                classify_mask_float = tf.cast(classify_mask, tf.float32)  # [N]
                # filter out non-classify-type questions
                answer_classify = tf.where(classify_mask, self.answer_classify, tf.zeros_like(self.answer_classify))  # [N]
                answer_onehot_target = tf.one_hot(indices = answer_classify,
                                                  depth = self.config.max_num_classes, dtype = tf.float32, axis = -1)
                if self.config.classify_loss == 'cross_entropy':
                    classify_loss = tf.losses.sparse_softmax_cross_entropy(logits=self.classify_logit,
                                                                       labels=answer_classify,
                                                                       weights=classify_mask_float,
                                                                       loss_collection=None)
                elif self.config.classify_loss == 'focal_loss':
                    # here I assume classify_mask_float is all ones
                    classify_loss = focal_loss(y_pred=self.classify_softmax, y_true=answer_onehot_target,
                                               weights=self.config.focal_loss_class_weights, gamma=self.config.focal_loss_gamma)
                else:
                    assert False, "Unknow loss %s" % self.config.classify_loss
                tf.summary.scalar(classify_loss.op.name, classify_loss)
                classify_loss *= self.config.w_classify
                tf.add_to_collection(tf.GraphKeys.LOSSES, classify_loss)
                self.classify_loss = classify_loss

                accuracy = accuracy_op(self.classify_logit, answer_onehot_target, classify_mask_float)
                tf.summary.scalar(accuracy.op.name, accuracy)
                self.classify_accuracy = accuracy

            self.loss = tf.add_n(tf.get_collection(tf.GraphKeys.LOSSES, scope=self.scope), name='loss')
            tf.summary.scalar(self.loss.op.name, self.loss)
            tf.add_to_collection('ema/scalar', self.loss)

    def _build_ema(self):
        self.ema = tf.train.ExponentialMovingAverage(self.config.decay)
        ema = self.ema
        tensors = tf.get_collection("ema/scalar", scope=self.scope) + tf.get_collection("ema/vector", scope=self.scope)
        ema_op = ema.apply(tensors)
        for var in tf.get_collection("ema/scalar", scope=self.scope):
            ema_var = ema.average(var)
            tf.summary.scalar(ema_var.op.name, ema_var)
        for var in tf.get_collection("ema/vector", scope=self.scope):
            ema_var = ema.average(var)
            tf.summary.histogram(ema_var.op.name, ema_var)

        with tf.control_dependencies([ema_op]):
            self.loss = tf.identity(self.loss)

    def _build_var_ema(self):
        self.var_ema = tf.train.ExponentialMovingAverage(self.config.var_decay)
        ema = self.var_ema
        ema_op = ema.apply(tf.trainable_variables())
        with tf.control_dependencies([ema_op]):
            self.loss = tf.identity(self.loss)

    def get_loss(self):
        return self.loss

    def get_global_step(self):
        return self.global_step

    def get_feed_dict(self, batch, is_train=True):
        load_gt = is_train
        assert isinstance(batch, Dataset)
        config = self.config
        N, JX, JQ, VW, VC, d = \
            config.batch_size, config.max_sent_size, \
            config.max_ques_size, config.word_vocab_size, config.char_vocab_size, config.hidden_size

        feed_dict = {}

        if config.len_opt:
            new_JX = max(len(sent) for sent in batch.data['cx'])
            assert new_JX <= JX
            JX = max(1, new_JX)

            new_JQ = max(len(sent) for sent in batch.data['cq'])
            assert new_JQ <= JQ
            JQ = max(1, new_JQ)

        x_char = np.zeros([N, JX], dtype='int32')
        q_char = np.zeros([N, JQ], dtype='int32')
        if config.use_word_emb:
            x_word = np.zeros([N, JX], dtype='int32')
            q_word = np.zeros([N, JQ], dtype='int32')

        x_mask = np.zeros([N, JX], dtype='bool')
        q_mask = np.zeros([N, JQ], dtype='bool')

        feed_dict[self.x_char] = x_char
        feed_dict[self.q_char] = q_char
        if config.use_word_emb:
            feed_dict[self.x_word] = x_word
            feed_dict[self.q_word] = q_word
        feed_dict[self.x_mask] = x_mask
        feed_dict[self.q_mask] = q_mask
        if config.use_glove_for_unk:
            feed_dict[self.new_word_emb_mat] = batch.new_word_emb_mat
            feed_dict[self.new_char_emb_mat] = batch.new_char_emb_mat

        X = batch.data['x']
        CX = batch.data['cx']

        def _get_word(word):
            d = batch.word2idx
            if word in d:
                return d[word]
            if config.use_glove_for_unk:
                d2 = batch.new_word2idx
                if word in d2:
                    return d2[word] + len(d)
            return d['-UNK-']

        def _get_char(ch):
            d = batch.char2idx
            if ch in d:
                return d[ch]
            if config.use_glove_for_unk:
                d2 = batch.new_char2idx
                if ch in d2:
                    return d2[ch] + len(d)
            return d['-UNK-']

        # fill in answer variables
        max_ans_len = config.max_answer_length
        answer = np.zeros([N, max_ans_len + 1], dtype='int32')
        answer_mask = np.ones([N, max_ans_len + 1], dtype='bool')
        answer_classify = np.zeros([N], dtype='int32')
        answer_length_with_eos = np.ones([N], dtype='int32') * (max_ans_len + 1)  # append eos symbol
        if load_gt:
            for i, (xi, cxi, ans_index_list, ans_classify) in \
                    enumerate(zip(X, CX, batch.data['a'], batch.data['a_classify'])):

                if len(ans_index_list) >= max_ans_len:
                    tf.logging.warning('over length answer: %s', str(ans_index_list))
                    ans_index_list = ans_index_list[:max_ans_len]
                ans_length_without_eos = len(ans_index_list)

                for t, ans_index in enumerate(ans_index_list):
                    if ans_index == config.next_symbol_in_eval:
                        ans_index = JX + config.next_symbol_offset
                    elif ans_index > min(len(cxi), config.max_sent_size) + config.max_symbol_offset:
                        tf.logging.warning('answer has index that exceeds max passage length: %s, %s, %s',
                                           str(ans_index), str(ans_index_list), str(cxi))
                        ans_length_without_eos = t
                        break
                    answer[i, t] = ans_index

                if ans_length_without_eos == 0:
                    answer_length_with_eos[i] = 0
                    answer_mask[i, :] = False
                else:
                    answer[i, ans_length_without_eos] = JX + config.eos_symbol_offset  # append eos
                    answer_length_with_eos[i] = ans_length_without_eos + 1
                    answer_mask[i, ans_length_without_eos + 1:] = False
                answer_classify[i] = ans_classify

            JA = np.max(answer_length_with_eos)
            answer = answer[:, :JA]
            answer_mask = answer_mask[:, :JA]

        feed_dict[self.answer] = answer
        feed_dict[self.answer_mask] = answer_mask
        feed_dict[self.answer_classify] = answer_classify

        # Concept Embeddings
        if config.use_concept_emb != 'no':
            concept_emb_index = np.zeros([N], dtype='int32')
            for i, concept_id in enumerate(batch.data['concept_id']):
                _index = batch.concept2idx.get(concept_id, batch.concept2idx['-UNK-'])
                concept_emb_index[i] = _index
            feed_dict[self.concept_emb_index] = concept_emb_index

        if config.use_concept_freq_emb != 'no':
            concept_freq_emb_index = np.zeros([N], dtype='int32')
            for i, _index in enumerate(batch.data['concept_freq_emb_index']):
                concept_freq_emb_index[i] = _index
            feed_dict[self.concept_freq_emb_index] = concept_freq_emb_index

        # Frequency Embeddings
        if config.use_mention_freq_emb != 'no':
            mention_freq_emb_index = np.zeros([N, JX], dtype='int32')
            for i, _index in enumerate(batch.data['mention_freq_emb_index']):
                len_index = min(JX, len(_index))
                mention_freq_emb_index[i, :len_index] = _index[:len_index]
            feed_dict[self.mention_freq_emb_index] = mention_freq_emb_index

        if config.use_pre_mention_freq_emb != 'no':
            pre_mention_freq_emb_index = np.zeros([N, JX], dtype='int32')
            for i, _index in enumerate(batch.data['pre_mention_freq_emb_index']):
                len_index = min(JX, len(_index))
                pre_mention_freq_emb_index[i, :len_index] = _index[:len_index]
            feed_dict[self.pre_mention_freq_emb_index] = pre_mention_freq_emb_index

        if config.use_post_mention_freq_emb != 'no':
            post_mention_freq_emb_index = np.zeros([N, JX], dtype='int32')
            for i, _index in enumerate(batch.data['post_mention_freq_emb_index']):
                len_index = min(JX, len(_index))
                post_mention_freq_emb_index[i, :len_index] = _index[:len_index]
            feed_dict[self.post_mention_freq_emb_index] = post_mention_freq_emb_index

        # Positional Embeddings
        if config.use_mention_positional_emb != 'no':
            mention_positional_emb_index = np.zeros([N, JX], dtype='int32')
            for i, _index in enumerate(batch.data['ctx_mention_index']):
                _index = [_i for _i in _index if _i < JX]
                if _index == []:
                    pprint({k:v[i] for k, v in batch.data.items()})
                    assert _index != [], '_index for mention position should not be empty!'
                emb_index = get_mention_positional_emb_index(_index, JX,
                        self.config.mention_positional_vocab_size - 1)
                mention_positional_emb_index[i, :] = emb_index
            feed_dict[self.mention_positional_emb_index] = mention_positional_emb_index

        if config.use_second_mention_positional_emb != 'no':
            second_mention_positional_emb_index = np.zeros([N, JX], dtype='int32')
            for i, _index in enumerate(batch.data['ctx_second_mention_index']):
                _index = [_i for _i in _index if _i < JX]
                if _index == []:
                    pprint({k:v[i] for k, v in batch.data.items()})
                    assert _index != [], '_index for mention position should not be empty!'
                emb_index = get_mention_positional_emb_index(_index, JX,
                        self.config.mention_positional_vocab_size - 1)
                second_mention_positional_emb_index[i, :] = emb_index
            feed_dict[self.second_mention_positional_emb_index] = second_mention_positional_emb_index

        # Concept mention list
        if config.use_mention_list:
            if config.use_mention_list_positional_emb != 'no':
                mention_list_positional_emb_index_l2r = np.zeros([N, JQ], dtype='int32')
                for i, _index in enumerate(batch.data['mention_list_positional_emb_index_l2r']):
                    len_index = min(JQ, len(_index))
                    mention_list_positional_emb_index_l2r[i, :len_index] = _index[:len_index]
                feed_dict[self.mention_list_positional_emb_index_l2r] = mention_list_positional_emb_index_l2r

                mention_list_positional_emb_index_r2l = np.zeros([N, JQ], dtype='int32')
                for i, _index in enumerate(batch.data['mention_list_positional_emb_index_r2l']):
                    len_index = min(JQ, len(_index))
                    mention_list_positional_emb_index_r2l[i, :len_index] = _index[:len_index]
                feed_dict[self.mention_list_positional_emb_index_r2l] = mention_list_positional_emb_index_r2l
            if config.use_mention_list_freq_emb != 'no':
                mention_list_freq_emb_index = np.zeros([N, JQ], dtype='int32')
                for i, _index in enumerate(batch.data['mention_list_freq_emb_index']):
                    len_index = min(JQ, len(_index))
                    mention_list_freq_emb_index[i, :len_index] = _index[:len_index]
                feed_dict[self.mention_list_freq_emb_index] = mention_list_freq_emb_index

        if config.use_word_emb:
            for i, xi in enumerate(X):
                for j, xij in enumerate(xi):
                    if j == config.max_sent_size:   #大于句子长度限制，强行切断
                        break

                    word_idx = _get_word(xij)
                    assert isinstance(word_idx, int), word_idx
                    x_word[i, j] = word_idx

        for i, cxi in enumerate(CX):
            for j, cxij in enumerate(cxi):
                if j == config.max_sent_size:
                    break
                x_char[i, j] = _get_char(cxij)
                x_mask[i, j] = True

        if config.use_word_emb:
            for i, qi in enumerate(batch.data['q']):
                for j, qij in enumerate(qi):
                    q_word[i, j] = _get_word(qij)

        for i, cqi in enumerate(batch.data['cq']):
            for j, cqij in enumerate(cqi):
                q_char[i, j] = _get_char(cqij)
                q_mask[i, j] = True

        return feed_dict

def variational_dropout(x, keep_prob, seq_dim, use_variational_dropout=True, name=None):
    x_shape = tf.shape(x)
    assert int(x_shape.shape[0]) == 3

    if use_variational_dropout:
        noise_shape = [x_shape[0], x_shape[1], x_shape[2]]
        noise_shape[seq_dim] = 1
        return tf.nn.dropout(x, keep_prob, noise_shape=noise_shape, name=name)
    else:
        return tf.nn.dropout(x, keep_prob, name=name)

def accuracy_op(predictions, targets, mask=None):
    """ accuracy_op.

    An op that calculates mean accuracy, assuming predictiosn are targets
    are both one-hot encoded.

    Examples:
        ```python
        input_data = placeholder(shape=[None, 784])
        y_pred = my_network(input_data) # Apply some ops
        y_true = placeholder(shape=[None, 10]) # Labels
        acc_op = accuracy_op(y_pred, y_true)

        # Calculate accuracy by feeding data X and labels Y
        accuracy = sess.run(acc_op, feed_dict={input_data: X, y_true: Y})
        ```

    Arguments:
        predictions: `Tensor`.
        targets: `Tensor`.

    Returns:
        `Float`. The mean accuracy.

    """
    if not isinstance(targets, tf.Tensor):
        raise ValueError("mean_accuracy 'input' argument only accepts type "
                         "Tensor, '" + str(type(input)) + "' given.")

    with tf.name_scope('Accuracy'):
        correct_pred = tf.equal(tf.argmax(predictions, 1), tf.argmax(targets, 1))
        if mask is not None:
            correct_pred = tf.cast(correct_pred, tf.float32) * mask
            acc = tf.reduce_sum(correct_pred) / (tf.reduce_sum(mask + 1e-10))
        else:
            acc = tf.reduce_mean(tf.cast(correct_pred, tf.float32))
    return acc

def focal_loss(y_pred, y_true, weights=None, gamma=2):
    """ Focal Loss.

    Computes cross entropy between y_pred (logits) and y_true (labels).

    Measures the probability error in discrete classification tasks in which
    the classes are mutually exclusive (each entry is in exactly one class).
    For example, each CIFAR-10 image is labeled with one and only one label:
    an image can be a dog or a truck, but not both.

    `y_pred` and `y_true` must have the same shape `[batch_size, num_classes]`
    and the same dtype (either `float32` or `float64`). It is also required
    that `y_true` (labels) are binary arrays (For example, class 2 out of a
    total of 5 different classes, will be define as [0., 1., 0., 0., 0.])

    Arguments:
        y_pred: `Tensor`. Predicted values.
        y_true: `Tensor` . Targets (labels), a probability distribution.

    """
    _FLOATX = tf.float32
    _EPSILON = 1e-10
    with tf.name_scope("FocalLoss"):
        y_pred = tf.clip_by_value(y_pred, tf.cast(_EPSILON, dtype=_FLOATX),
                                  tf.cast(1.-_EPSILON, dtype=_FLOATX))
        focal_loss = - y_true * tf.log(y_pred)
        if weights is not None:
            const = tf.constant(weights, dtype=tf.float32, name='fl_weights')
            const = tf.expand_dims(const, 0)
            const = tf.tile(const, tf.stack([tf.shape(y_true)[0], 1]))
            focal_loss = const * focal_loss
        if gamma != 0:
            focal_loss = ((1 - y_pred) ** gamma) * focal_loss
        focal_loss = tf.reduce_sum(focal_loss,
                               reduction_indices=len(y_pred.get_shape())-1)
        return tf.reduce_mean(focal_loss)

def bi_attention(config, h, u, h_mask=None, u_mask=None, scope=None, tensor_dict=None, pos_to_embeddings_list=None):
    with tf.variable_scope(scope or "bi_attention"):
        JX = tf.shape(h)[1]
        JQ = tf.shape(u)[1]
        h_aug = tf.tile(tf.expand_dims(h, 2), [1, 1, JQ, 1])
        u_aug = tf.tile(tf.expand_dims(u, 1), [1, JX, 1, 1])
        if h_mask is None:
            hu_mask = None
        else:
            h_mask_aug = tf.tile(tf.expand_dims(h_mask, 2), [1, 1, JQ])
            u_mask_aug = tf.tile(tf.expand_dims(u_mask, 1), [1, JX, 1])
            hu_mask = h_mask_aug & u_mask_aug

        u_logits = get_logits([h_aug, u_aug], None, True, wd=config.wd, mask=hu_mask,
                              func=config.logit_func, scope='u_logits',
                              pos_to_embeddings_list=pos_to_embeddings_list)  # [N, JX, JQ]
        u_a = softsel(u_aug, u_logits)  # [N, JX, d]
        h_a = softsel(h, tf.reduce_max(u_logits, 2))  # [N, d]
        h_a = tf.tile(tf.expand_dims(h_a, 1), [1, JX, 1])  # [N, JX, d]

        if tensor_dict is not None:
            a_u = tf.nn.softmax(u_logits)  # [N, JX, JQ]
            a_h = tf.nn.softmax(tf.reduce_max(u_logits, 2))
            tensor_dict['a_u'] = a_u
            tensor_dict['a_h'] = a_h
            variables = tf.get_collection(tf.GraphKeys.GLOBAL_VARIABLES, scope=tf.get_variable_scope().name)
            for var in variables:
                tensor_dict[var.name] = var

        return u_a, h_a


def attention_layer(config, h, u, h_mask=None, u_mask=None, scope=None, tensor_dict=None, pos_to_embeddings_list=None):
    with tf.variable_scope(scope or "attention_layer"):
        JX = tf.shape(h)[1]
        JQ = tf.shape(u)[1]
        if config.q2c_att or config.c2q_att:
            u_a, h_a = bi_attention(config, h, u, h_mask=h_mask, u_mask=u_mask,
                    tensor_dict=tensor_dict, pos_to_embeddings_list=pos_to_embeddings_list)
        if not config.c2q_att:
            u_a = tf.tile(tf.expand_dims(tf.reduce_mean(u, 1), 1), [1, JX, 1])
        if config.q2c_att:
            p0 = [h, u_a, h * u_a, h * h_a]
            if len(pos_to_embeddings_list['att_out']) > 0:
                for name, Aemb in pos_to_embeddings_list['att_out']:
                    p0.append(Aemb)
            if len(pos_to_embeddings_list['att_out_dot']) > 0:
                for name, Aemb in pos_to_embeddings_list['att_out_dot']:
                    if name == 'concept_emb':
                        p0.append(h * tf.tile(Aemb, [1, 1, 2]))
                    else:
                        p0.append(h * Aemb)
            p0 = tf.concat(p0, 2)
        else:
            p0 = tf.concat([h, u_a, h * u_a], 2)
        return p0


def multi_layer_rnn(config, input, input_len, num_layers, scope_prefix, dtype=tf.float32):
    assert num_layers > 0, num_layers

    previous_output = input  # [N, JX, 2d]
    forward_final = None
    backward_final = None
    for layer_id in range(num_layers):
        fw_cell = DropoutWrapper(BasicLSTMCell(config.hidden_size),
                                 input_keep_prob=config.input_keep_prob)
        bw_cell = DropoutWrapper(BasicLSTMCell(config.hidden_size),
                                 input_keep_prob=config.input_keep_prob)
        (forward, backward), (forward_final, backward_final) = \
            tf.nn.bidirectional_dynamic_rnn(fw_cell,
                                            bw_cell,
                                            previous_output,
                                            input_len,
                                            dtype=dtype,
                                            parallel_iterations=config.rnn_parallel_iterations,
                                            swap_memory=config.rnn_swap_memory,
                                            scope=scope_prefix + str(layer_id))  # [N, JX, 2d]
        previous_output = tf.concat([forward, backward], 2)  # [N, JX, 2d]

    output = previous_output  # [N, 2d]

    final_state_c = tf.concat((forward_final.c, backward_final.c), 1, name=scope_prefix + 'final_c')
    final_state_h = tf.concat((forward_final.h, backward_final.h), 1, name=scope_prefix + 'final_h')
    final_state = LSTMStateTuple(c=final_state_c, h=final_state_h)  # ([N, 2 * d], [N, 2 * d])
    tf.logging.debug('final_state (scope=%s): %s', str(scope_prefix), str(final_state))
    return output, final_state


def build_fused_bidirectional_rnn(inputs, num_units, num_layers, inputs_length, input_keep_prob=1.0, scope=None, dtype=tf.float32, config=None):
    ''' The input of sequences should be time major
        And the Dropout is independent per time. '''
    assert num_layers > 0
    with tf.variable_scope(scope or "bidirectional_rnn"):
        current_inputs = tf.transpose(inputs, [1, 0, 2]) #[time_len, batch_size, input_size]
        for layer_id in range(num_layers):
            fw_inputs = variational_dropout(current_inputs, input_keep_prob,
                    seq_dim=0, use_variational_dropout=config.use_variational_dropout)
            bw_inputs = variational_dropout(current_inputs, input_keep_prob,
                    seq_dim=0, use_variational_dropout=config.use_variational_dropout)
            fw_cell = LSTMBlockFusedCell(num_units, cell_clip=config.cell_clip, weight_keep_prob=config.weight_keep_prob,
                    init_w='block_orth_normal_initializer' if config.use_orth_normal_init else None)
            bw_cell = TimeReversedFusedRNN(fw_cell)
            fw_outputs, fw_final = fw_cell(fw_inputs, dtype=dtype, sequence_length=inputs_length, scope="fw_"+str(layer_id))
            bw_outputs, bw_final = bw_cell(bw_inputs, dtype=dtype, sequence_length=inputs_length, scope="bw_"+str(layer_id))
            current_inputs = tf.concat((fw_outputs, bw_outputs), 2)
        output = tf.transpose(current_inputs, [1, 0, 2])

        final_state_c = tf.concat((fw_final[0], bw_final[0]), 1, name=scope + '_final_c')
        final_state_h = tf.concat((fw_final[1], bw_final[1]), 1, name=scope + '_final_h')
        final_state = LSTMStateTuple(c=final_state_c, h=final_state_h)  # ([N, 2 * d], [N, 2 * d])
        return output, final_state


def self_attention_layer_rnn(config, inputs, input_len, x_mask, num_units, dtype=tf.float32):
    s0 = inputs  # [N, JX, 2d]
    if config.use_static_self_match:
        with tf.variable_scope("StaticSelfMatch"):  # implemented follow r-net section 3.3
            W_x_Vj = tf.contrib.layers.fully_connected(  # [N, JX, d]
                s0, int(num_units / 2), scope='row_first',
                activation_fn=None, biases_initializer=None
            )
            W_x_Vt = tf.contrib.layers.fully_connected(  # [N, JX, d]
                s0, int(num_units / 2), scope='col_first',
                activation_fn=None, biases_initializer=None
            )
            sum_rc = tf.add(  # [N, JX, JX, d]
                tf.expand_dims(W_x_Vj, 1),
                tf.expand_dims(W_x_Vt, 2)
            )
            v = tf.get_variable('second', shape=[1, 1, 1, int(num_units / 2)], dtype=tf.float32)
            Sj = tf.reduce_sum(tf.multiply(v, tf.tanh(sum_rc)), -1)  # [N, JX, JX]
            Ai = softmax(Sj, mask=tf.expand_dims(x_mask, 1))  # [N, JX, JX]
            Ai = tf.expand_dims(Ai, -1)  # [N, JX, JX, 1]
            Vi = tf.expand_dims(s0, 1)  # [N, 1, JX, 2d]
            Ct = tf.reduce_sum(  # [N, JX, 2d]
                tf.multiply(Ai, Vi),
                axis=2
            )
            inputs_Vt_Ct = tf.concat([s0, Ct], 2)  # [N, JX, 4d]
            if config.use_fused_lstm:
                fw_inputs = tf.transpose(inputs_Vt_Ct, [1, 0, 2])  # [time_len, batch_size, input_size]
                bw_inputs = tf.reverse_sequence(fw_inputs, input_len, batch_dim=1, seq_dim=0)
                fw_inputs = variational_dropout(fw_inputs, config.input_keep_prob,
                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                bw_inputs = variational_dropout(bw_inputs, config.input_keep_prob,
                        seq_dim=0, use_variational_dropout=config.use_variational_dropout)
                prep_fw_cell = LSTMBlockFusedCell(num_units, cell_clip=config.cell_clip, weight_keep_prob=config.weight_keep_prob,
                        init_w='block_orth_normal_initializer' if config.use_orth_normal_init else None)
                prep_bw_cell = LSTMBlockFusedCell(num_units, cell_clip=config.cell_clip, weight_keep_prob=config.weight_keep_prob,
                        init_w='block_orth_normal_initializer' if config.use_orth_normal_init else None)
                fw_outputs, fw_s_f = prep_fw_cell(fw_inputs, dtype=dtype,
                                                  sequence_length=input_len,
                                                  scope="fw")
                bw_outputs, bw_s_f = prep_bw_cell(bw_inputs, dtype=dtype,
                                                  sequence_length=input_len,
                                                  scope="bw")
                fw_s_f = LSTMStateTuple(c=fw_s_f[0], h=fw_s_f[1])
                bw_s_f = LSTMStateTuple(c=bw_s_f[0], h=bw_s_f[1])
                bw_outputs = tf.reverse_sequence(bw_outputs, input_len, batch_dim=1, seq_dim=0)
                current_inputs = tf.concat((fw_outputs, bw_outputs), 2)
                output = tf.transpose(current_inputs, [1, 0, 2])
            else:
                first_fw_cell = DropoutWrapper(BasicLSTMCell(num_units), input_keep_prob=config.input_keep_prob)
                first_bw_cell = DropoutWrapper(BasicLSTMCell(num_units), input_keep_prob=config.input_keep_prob)

                (fw_s, bw_s), (fw_s_f, bw_s_f) = tf.nn.bidirectional_dynamic_rnn(first_fw_cell, first_bw_cell,
                                                                                 inputs_Vt_Ct, input_len,
                                                                                 dtype=dtype,
                                                                                 parallel_iterations=config.rnn_parallel_iterations,
                                                                                 swap_memory=config.rnn_swap_memory,
                                                                                 scope='s')  # [N, JX, 2d]
                output = tf.concat([fw_s, bw_s], 2)  # [N, JX, 2d]
    else:
        with tf.variable_scope("DynamicSelfMatch"):
            first_fw_cell = AttentionCell(BasicLSTMCell(num_units),
                                          s0,
                                          size=num_units,
                                          mask=x_mask,
                                          scope='fw_memory_prepare')

            first_bw_cell = AttentionCell(BasicLSTMCell(num_units),
                                          tf.reverse_sequence(s0, input_len, batch_dim=0, seq_dim=1),
                                          size=num_units,
                                          mask=x_mask,
                                          scope='bw_memory_prepare')

            (fw_s, bw_s), (fw_s_f, bw_s_f) = tf.nn.bidirectional_dynamic_rnn(first_fw_cell,
                                                                             first_bw_cell,
                                                                             s0,
                                                                             input_len,
                                                                             dtype=dtype,
                                                                             parallel_iterations=config.rnn_parallel_iterations,
                                                                             swap_memory=config.rnn_swap_memory,
                                                                             scope='s')  # [N, JX, 2d]
            output = tf.concat([fw_s, bw_s], 2)  # [N, JX, 2d]

    assert isinstance(fw_s_f, LSTMStateTuple)
    final_state_c = tf.concat((fw_s_f.c, bw_s_f.c), 1, name='self_attention_final_c')
    final_state_h = tf.concat((fw_s_f.h, bw_s_f.h), 1, name='self_attention_final_h')
    final_state = LSTMStateTuple(c=final_state_c, h=final_state_h)

    return output, final_state

" NOTE:
" This script is for Pgmnt, template engine for creating Vim color scheme.
" See the official site for more information:
" https://github.com/cocopon/pgmnt.vim

" reload the color change
source ../autoload/retro/palette/dark.vim


function! s:create_context() abort
  let p = retro#palette#dark#create()
  let c = p.cterm
  let g = p.gui

  let links = []
  let rules = []

  " Rules {{{
  call extend(rules, pgmnt#hi#group(
        \ ['ColorColumn', 'CursorColumn', 'CursorLine'], {
        \   'cterm': 'NONE',
        \   'ctermbg': c.cursorline_bg,
        \   'guibg': g.cursorline_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Comment', {
        \   'ctermfg': c.comment_fg,
        \   'guifg': g.comment_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Constant', {
        \   'ctermfg': c.purple,
        \   'guifg': g.purple,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Cursor', {
        \   'ctermbg': c.normal_fg,
        \   'ctermfg': c.normal_bg,
        \   'guibg': g.normal_fg,
        \   'guifg': g.normal_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'CursorLineNr', {
        \   'ctermbg': c.cursorlinenr_bg,
        \   'ctermfg': c.cursorlinenr_fg,
        \   'guibg': g.cursorlinenr_bg,
        \   'guifg': g.cursorlinenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Delimiter', {
        \   'ctermfg': c.normal_fg,
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'DiffAdd', {
        \   'ctermbg': c.diffadd_bg,
        \   'ctermfg': c.diffadd_fg,
        \   'guibg': g.diffadd_bg,
        \   'guifg': g.diffadd_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'DiffChange', {
        \   'ctermbg': c.diffchange_bg,
        \   'ctermfg': c.diffchange_fg,
        \   'guibg': g.diffchange_bg,
        \   'guifg': g.diffchange_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'DiffDelete', {
        \   'ctermbg': c.diffdelete_bg,
        \   'ctermfg': c.diffdelete_fg,
        \   'guibg': g.diffdelete_bg,
        \   'guifg': g.diffdelete_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'DiffText', {
        \   'cterm': 'NONE',
        \   'ctermbg': 30,
        \   'ctermfg': 195,
        \   'gui': 'NONE',
        \   'guibg': pgmnt#color#mix(g.lblue, g.normal_bg, 0.6),
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Directory', {
        \   'ctermfg': c.lblue,
        \   'guifg': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['Error', 'ErrorMsg', 'WarningMsg'], {
        \   'ctermbg': 'NONE',
        \   'ctermfg': c.red,
        \   'guibg': 'NONE',
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['EndOfBuffer', 'NonText', 'SpecialKey'], {
        \   'ctermbg': 'NONE',
        \   'ctermfg': c.specialkey_fg,
        \   'guibg': 'NONE',
        \   'guifg': g.specialkey_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Folded', {
        \   'ctermbg': c.folded_bg,
        \   'ctermfg': c.folded_fg,
        \   'guibg': g.folded_bg,
        \   'guifg': g.folded_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'FoldColumn', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Function', {
        \   'ctermfg': c.red,
        \   'guifg': g.red,
        \   'gui': 'bold'
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Identifier', {
        \   'cterm': 'NONE',
        \   'ctermfg': c.lblue,
        \   'guifg': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Include', {
        \   'ctermfg': c.blue,
        \   'guifg': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'LineNr', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'MatchParen', {
        \   'ctermbg': c.matchparen_bg,
        \   'ctermfg': c.matchparen_fg,
        \   'guibg': g.matchparen_bg,
        \   'guifg': g.matchparen_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'MoreMsg', {
        \   'ctermfg': c.green,
        \   'guifg': g.green,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Normal', {
        \   'ctermbg': c.normal_bg,
        \   'ctermfg': c.normal_fg,
        \   'guibg': 'NONE',
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'NormalAutoBG', {
        \   'ctermbg': 'NONE',
        \   'ctermfg': c.normal_fg,
        \   'guibg': 'NONE',
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Operator', {
        \   'ctermfg': c.normal_fg,
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Pmenu', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.normal_fg,
        \   'guibg': g.pmenu_bg,
        \   'guifg': g.pmenu_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'PmenuSel', {
        \   'ctermbg': c.cursorlinenr_bg,
        \   'ctermfg': c.normal_fg,
        \   'guibg': g.cursorlinenr_bg,
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'PmenuSbar', {
        \   'ctermbg': c.pmenu_bg,
        \   'guibg': g.pmenu_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'PmenuThumb', {
        \   'ctermbg': c.pmenu_fg,
        \   'guibg': g.pmenuthumb_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'PreProc', {
        \   'ctermfg': c.blue,
        \   'guifg': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Question', {
        \   'ctermfg': c.blue,
        \   'guifg': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Search', {
        \   'ctermbg': c.search_bg,
        \   'ctermfg': c.search_fg,
        \   'guibg': g.search_bg,
        \   'guifg': g.search_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SignColumn', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Special', {
        \   'cterm': 'bold',
        \   'ctermfg': c.blue,
        \   'gui': 'bold',
        \   'guifg': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SpellBad', {
        \   'guisp': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SpellCap', {
        \   'guisp': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SpellLocal', {
        \   'guisp': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SpellRare', {
        \   'guisp': g.purple,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Statement', {
        \   'ctermfg': c.normal_fg,
        \   'gui': 'NONE',
        \   'guifg': g.normal_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['StatusLine', 'StatusLineTerm'], {
        \   'cterm': 'reverse',
        \   'ctermbg': c.statusline_fg,
        \   'ctermfg': c.statusline_bg,
        \   'gui': 'reverse',
        \   'guibg': g.statusline_fg,
        \   'guifg': g.statusline_bg,
        \   'term': 'reverse',
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['StatusLineNC', 'StatusLineTermNC'], {
        \   'cterm': 'reverse',
        \   'ctermbg': c.statuslinenc_fg,
        \   'ctermfg': c.statuslinenc_bg,
        \   'gui': 'reverse',
        \   'guibg': g.statuslinenc_fg,
        \   'guifg': g.statuslinenc_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'StorageClass', {
        \     'ctermfg': c.blue,
        \     'guifg': g.blue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'String', {
        \   'ctermfg': c.lblue,
        \   'guifg': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Structure', {
        \   'ctermfg': c.lblue,
        \   'guifg': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'TabLine', {
        \   'cterm': 'NONE',
        \   'ctermbg': c.statusline_bg,
        \   'ctermfg': c.statusline_fg,
        \   'gui': 'NONE',
        \   'guibg': g.statusline_bg,
        \   'guifg': g.statusline_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'TabLineFill', {
        \   'cterm': 'reverse',
        \   'ctermbg': c.statusline_fg,
        \   'ctermfg': c.statusline_bg,
        \   'gui': 'reverse',
        \   'guibg': g.statusline_fg,
        \   'guifg': g.statusline_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'TabLineSel', {
        \   'cterm': 'NONE',
        \   'ctermbg': c.normal_bg,
        \   'ctermfg': c.normal_fg,
        \   'gui': 'NONE',
        \   'guibg': g.normal_bg,
        \   'guifg': pgmnt#color#mix(g.normal_fg, g.normal_bg, 0.75),
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Title', {
        \   'ctermfg': c.red,
        \   'gui': 'NONE',
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Todo', {
        \   'ctermbg': c.normal_bg,
        \   'ctermfg': c.todo_fg,
        \   'guibg': 'NONE',
        \   'guifg': g.todo_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Type', {
        \   'ctermfg': c.lblue,
        \   'gui': 'NONE',
        \   'guifg': g.lblue,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Underlined', {
        \   'cterm': 'underline',
        \   'ctermfg': c.normal_fg,
        \   'gui': 'underline',
        \   'guifg': g.normal_fg,
        \   'term': 'underline',
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'VertSplit', {
        \   'cterm': 'NONE',
        \   'ctermbg': c.statuslinenc_bg,
        \   'ctermfg': c.statuslinenc_bg,
        \   'gui': 'NONE',
        \   'guibg': g.statuslinenc_bg,
        \   'guifg': g.statuslinenc_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'Visual', {
        \   'ctermbg': c.visual_bg,
        \   'guibg': g.visual_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'WildMenu', {
        \   'ctermbg': c.wildmenu_bg,
        \   'ctermfg': c.wildmenu_fg,
        \   'guibg': g.wildmenu_bg,
        \   'guifg': g.wildmenu_fg,
        \ }))
  " }}}

  " Rules for filetypes {{{
  " css
  call add(links, pgmnt#hi#link('cssBraces', 'Delimiter'))
  call add(links, pgmnt#hi#link('cssClassName', 'Special'))
  call add(links, pgmnt#hi#link('cssClassNameDot', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('cssPseudoClassId', 'Function'))
  call add(links, pgmnt#hi#link('cssTagName', 'Statement'))

  " diff
  call extend(rules, pgmnt#hi#group(
        \ 'diffAdded', {
        \   'ctermfg': c.green,
        \   'guifg': g.green,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'diffRemoved', {
        \   'ctermfg': c.red,
        \   'guifg': g.red,
        \ }))

  " help
  call add(links, pgmnt#hi#link('helpHyperTextJump', 'Constant'))

  " html
  call add(links, pgmnt#hi#link('htmlArg', 'Constant'))
  call add(links, pgmnt#hi#link('htmlEndTag', 'Statement'))
  call add(links, pgmnt#hi#link('htmlTag', 'Statement'))

  " json
  call add(links, pgmnt#hi#link('jsonQuote', 'NormalAutoBG'))

  " php
  call add(links, pgmnt#hi#link('phpVarSelector', 'Identifier'))

  " ruby
  call add(links, pgmnt#hi#link('rubyDefine', 'Statement'))
  call add(links, pgmnt#hi#link('rubyInterpolationDelimiter', 'String'))
  call add(links, pgmnt#hi#link('rubySharpBang', 'Comment'))
  call add(links, pgmnt#hi#link('rubyStringDelimiter', 'String'))

  " sass
  call add(links, pgmnt#hi#link('sassClass', 'Special'))

  " sh
  call add(links, pgmnt#hi#link('shFunction', 'NormalAutoBG'))

  " vim
  call add(links, pgmnt#hi#link('vimContinue', 'Comment'))
  call add(links, pgmnt#hi#link('vimIsCommand', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('vimCommand', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('vimVar', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('vimLet', 'Statement'))
  call add(links, pgmnt#hi#link('vimFuncKey', 'Statement'))


  " ale
  call extend(rules, pgmnt#hi#group(
        \ 'ALEErrorSign', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.red,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'ALEWarningSign', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.red,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['ALEStyleError', 'ALEError'], {
        \   'cterm': 'underline',
        \   'gui': 'underline',
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'ALEWarning', {
        \   'cterm': 'underline',
        \   'gui': 'underline',
        \ }))

  " xml
  call add(links, pgmnt#hi#link('xmlAttrib', 'Constant'))
  call add(links, pgmnt#hi#link('xmlAttribPunct', 'Statement'))
  call add(links, pgmnt#hi#link('xmlEndTag', 'Statement'))
  call add(links, pgmnt#hi#link('xmlNamespace', 'Statement'))
  call add(links, pgmnt#hi#link('xmlTag', 'Statement'))
  call add(links, pgmnt#hi#link('xmlTagName', 'Statement'))

  " yaml
  call add(links, pgmnt#hi#link('yamlKeyValueDelimiter', 'Delimiter'))
  " }}}

  " Rules for plugins {{{
  " [CtrlP](https://github.com/ctrlpvim/ctrlp.vim)
  call add(links, pgmnt#hi#link('CtrlPPrtCursor', 'Cursor'))
  call add(links, pgmnt#hi#link('CtrlPMatch', 'Title'))
  call extend(rules, pgmnt#hi#group(
        \ 'CtrlPMode1', {
        \   'ctermbg': c.xline_gradient_bg,
        \   'ctermfg': c.xline_gradient_fg,
        \   'guibg': g.xline_gradient_bg,
        \   'guifg': g.xline_gradient_fg,
        \ }))
  call add(links, pgmnt#hi#link('CtrlPMode2', 'StatusLine'))

  " [Denite](https://github.com/Shougo/denite.nvim)
  call add(links, pgmnt#hi#link('deniteMatched', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('deniteMatchedChar', 'Function'))

  " [EasyMotion](https://github.com/easymotion/vim-easymotion)
  call extend(rules, pgmnt#hi#group(
        \ 'EasyMotionShade', {
        \   'ctermfg': c.easymotion_shade_fg,
        \   'guifg': g.easymotion_shade_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'EasyMotionTarget', {
        \   'ctermfg': c.green,
        \   'guifg': g.green,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['EasyMotionTarget2First', 'EasyMotionTarget2Second'], {
        \   'ctermfg': c.red,
        \   'guifg': g.red,
        \ }))

  " [vim-flow](https://github.com/flowtype/vim-flow)
  call add(links, pgmnt#hi#link('jsFlowType', 'Statement'))
  call add(links, pgmnt#hi#link('jsFlowMaybe', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('jsFlowObject', 'NormalAutoBG'))

  " [vim-graphql](https://github.com/jparise/vim-graphql)
  call add(links, pgmnt#hi#link('graphqlIdentifier', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('graphqlOperator', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('graphqlStructure', 'Statement'))

  " [Git Gutter](https://github.com/airblade/vim-gitgutter)
  call extend(rules, pgmnt#hi#group(
        \ 'GitGutterAdd', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['GitGutterChange', 'GitGutterChangeDelete'], {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'GitGutterDelete', {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.linenr_fg,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.linenr_fg,
        \ }))

  " [vim-javascript](https://github.com/pangloss/vim-javascript)
  call add(links, pgmnt#hi#link('jsArrowFunction', 'Operator'))
  call add(links, pgmnt#hi#link('jsClassMethodType', 'Statement'))
  call add(links, pgmnt#hi#link('jsExport', 'Statement'))
  call add(links, pgmnt#hi#link('jsFuncName', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('jsFunction', 'Function'))
  call add(links, pgmnt#hi#link('jsGlobalObjects', 'Statement'))
  call add(links, pgmnt#hi#link('jsModuleKeywords', 'Statement'))
  call add(links, pgmnt#hi#link('jsModuleOperators', 'Statement'))
  call add(links, pgmnt#hi#link('jsObjectKey', 'Identifier'))
  call add(links, pgmnt#hi#link('jsSuper', 'Statement'))

  " [vim-markdown](https://github.com/tpope/vim-markdown)
  call add(links, pgmnt#hi#link('markdownBold', 'Special'))
  call add(links, pgmnt#hi#link('markdownCode', 'String'))
  call add(links, pgmnt#hi#link('markdownCodeDelimiter', 'String'))
  call add(links, pgmnt#hi#link('markdownHeadingDelimiter', 'Comment'))
  call add(links, pgmnt#hi#link('markdownRule', 'Comment'))

  " [vim-plug](https://github.com/junegunn/vim-plug)
  call add(links, pgmnt#hi#link('plug1', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('plug2', 'Structure'))
  call add(links, pgmnt#hi#link('plugDash', 'Comment'))
  call add(links, pgmnt#hi#link('plugMessage', 'Special'))

  " [coc.nvim](https://github.com/neoclide/coc.nvim)
  call add(links, pgmnt#hi#link('CocErrorFloat', 'Error'))
  call extend(rules, pgmnt#hi#group(
        \ 'CocErrorSign', {
        \   'cterm': 'bold',
        \   'gui': 'bold',
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.orange,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'CocWarningFloat', {
        \   'ctermbg': 'NONE',
        \   'ctermfg': c.orange,
        \   'guibg': 'NONE',
        \   'guifg': g.orange,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'CocWarningSign', {
        \   'cterm': 'bold',
        \   'gui': 'bold',
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.orange,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.orange,
        \ }))

  " [Sneak](https://github.com/justinmk/vim-sneak/)
  call extend(rules, pgmnt#hi#group(
        \ 'Sneak', {
        \   'ctermbg': c.purple,
        \   'ctermfg': c.normal_bg,
        \   'guibg': g.purple,
        \   'guifg': g.normal_bg,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ 'SneakScope', {
        \   'ctermbg': c.visual_bg,
        \   'ctermfg': c.comment_fg,
        \   'guibg': g.visual_bg,
        \   'guifg': g.comment_fg,
        \ }))

  " [SVSS](https://github.com/cocopon/svss.vim)
  call add(links, pgmnt#hi#link('svssBraces', 'Delimiter'))
  
  " [Syntastic](http://github.com/vim-syntastic/syntastic)
  call extend(rules, pgmnt#hi#group(
        \ ['SyntasticErrorSign', 'SyntasticStyleErrorSign'], {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.red,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.red,
        \ }))
  call extend(rules, pgmnt#hi#group(
        \ ['SyntasticStyleWarningSign', 'SyntasticWarningSign'], {
        \   'ctermbg': c.linenr_bg,
        \   'ctermfg': c.red,
        \   'guibg': g.linenr_bg,
        \   'guifg': g.red,
        \ }))

  " [vim-swift](https://github.com/toyamarinyon/vim-swift)
  call add(links, pgmnt#hi#link('swiftIdentifier', 'NormalAutoBG'))

  " [typescript-vim](https://github.com/leafgarland/typescript-vim)
  call add(links, pgmnt#hi#link('typescriptAjaxMethods', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('typescriptBraces', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('typescriptEndColons', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('typescriptGlobalObjects', 'Statement'))
  call add(links, pgmnt#hi#link('typescriptHtmlElemProperties', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('typescriptIdentifier', 'Statement'))
  call add(links, pgmnt#hi#link('typescriptMessage', 'NormalAutoBG'))
  call add(links, pgmnt#hi#link('typescriptNull', 'Constant'))
  call add(links, pgmnt#hi#link('typescriptParens', 'NormalAutoBG'))

  " [tex]
  call add(links, pgmnt#hi#link('texMathZoneC', 'Normal'))

  " [zenspace.vim](https://github.com/thinca/vim-zenspace)
  call extend(rules, pgmnt#hi#group(
        \ 'ZenSpace', {
        \   'ctermbg': c.red,
        \   'guibg': g.red,
        \ }))
  " }}}

  " Palettes for statusline plugins {{{
  call extend(rules, pgmnt#hi#group(
        \ 'icebergALAccentRed', {
        \   'ctermfg': c.red,
        \   'guifg': g.red,
        \ }))
  " }}}

  let term_colors = [
        \   g.normal_bg,
        \   g.red,
        \   g.green,
        \   g.red,
        \   g.blue,
        \   g.purple,
        \   g.lblue,
        \   g.normal_fg,
        \   g.comment_fg,
        \   pgmnt#color#adjust_color(g.red,       {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.green,     {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.red,    {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.blue,      {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.purple,    {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.lblue,     {'saturation': +0.05, 'lightness': +0.05}),
        \   pgmnt#color#adjust_color(g.normal_fg, {'saturation': +0.05, 'lightness': +0.05}),
        \ ]
  let neovim_term_defs = map(
        \ term_colors,
        \ '"let g:terminal_color_" . v:key . " = ''" . v:val . "''"')
  
  return {
        \   'links': links,
        \   'modified': strftime('%Y-%m-%d %H:%M%z'),
        \   'neovim_term_defs': neovim_term_defs,
        \   'rules': rules,
        \ }
endfunction

call pgmnt#compile(s:create_context(), {
      \   'output': '../colors/retro.vim',
      \   'template': './template.vim',
      \ })

function! s:create_xline_context() abort
  let p = retro#palette#dark#create()
  let c = p.cterm
  let g = p.gui

  let col_base = string([
        \   g.xline_base_fg,
        \   g.xline_base_bg,
        \   c.xline_base_fg,
        \   c.xline_base_bg,
        \ ])
  let col_edge = string([
        \   g.xline_edge_fg,
        \   g.xline_edge_bg,
        \   c.xline_edge_fg,
        \   c.xline_edge_bg,
        \ ])
  return {
        \   'col_base': col_base,
        \   'col_tabfill': col_base,
        \   'col_edge': col_edge,
        \   'col_normal': string([
        \       g.normal_bg,
        \       g.red,
        \       c.normal_bg,
        \       c.red,
        \       'bold',
        \]),
        \   'col_tabsel': col_edge,
        \   'col_error': string([
        \     g.normal_bg,
        \     g.red,
        \     c.normal_bg,
        \     c.red,
        \   ]),
        \   'col_gradient': string([
        \     g.xline_gradient_fg,
        \     g.xline_gradient_bg,
        \     c.xline_gradient_fg,
        \     c.xline_gradient_bg,
        \   ]),
        \   'col_nc': string([
        \     g.statuslinenc_fg,
        \     g.statuslinenc_bg,
        \     c.statuslinenc_fg,
        \     c.statuslinenc_bg,
        \     'bold',
        \   ]),
        \   'col_warning': string([
        \     g.normal_bg,
        \     g.red,
        \     c.normal_bg,
        \     c.red,
        \   ]),
        \   'col_insert': string([
        \     g.normal_bg,
        \     g.darkblue,
        \     c.normal_bg,
        \     c.blue,
        \     'bold',
        \   ]),
        \   'col_replace': string([
        \     g.normal_bg,
        \     g.red,
        \     c.normal_bg,
        \     c.red,
        \     'bold',
        \   ]),
        \   'col_visual': string([
        \     g.normal_bg,
        \     g.green,
        \     c.normal_bg,
        \     c.green,
        \     'bold',
        \   ]),
        \   'col_red': string([
        \     g.red,
        \     g.normal_bg,
        \     c.red,
        \     c.normal_bg,
        \   ]),
        \ }
endfunction

call pgmnt#compile(
      \ s:create_xline_context(), {
      \   'output': '../autoload/airline/themes/retro.vim',
      \   'template': './template-airline.vim',
      \ })
call pgmnt#compile(
      \ s:create_xline_context(), {
      \   'output': '../autoload/lightline/colorscheme/retro.vim',
      \   'template': './template-lightline.vim',
      \ })

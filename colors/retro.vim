" _________________________________________
" \_ _/ ____| ____| ___ \ ____| ___ \  ___/
"  | | |____| ____| ___ < ____| __  / |__ \
" /___\_____|_____|_____/_____|_| \_\_____/
"
"  cool-headed perspective for your coding
"
"
" File:       iceberg.vim
" Maintainer: cocopon <cocopon@me.com>
" Modified:   2020-11-10 20:29+0800
" License:    MIT


if !has('gui_running') && &t_Co < 256
  finish
endif

set background=dark
hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'retro'


hi ColorColumn cterm=NONE ctermbg=235 guibg=#bcbfc2
hi CursorColumn cterm=NONE ctermbg=235 guibg=#bcbfc2
hi CursorLine cterm=NONE ctermbg=235 guibg=#bcbfc2
hi Comment ctermfg=242 guifg=#798085
hi Constant ctermfg=140 guifg=#b31313
hi Cursor ctermbg=252 ctermfg=234 guibg=#000000 guifg=#f1f2f2
hi CursorLineNr ctermbg=237 ctermfg=253 guibg=#bcbfc2 guifg=#000000
hi Delimiter ctermfg=252 guifg=#000000
hi DiffAdd ctermbg=29 ctermfg=158 guibg=#b5d3bd guifg=#0c2a14
hi DiffChange ctermbg=23 ctermfg=159 guibg=#deafaf guifg=#350505
hi DiffDelete ctermbg=95 ctermfg=224 guibg=#deafaf guifg=#350505
hi DiffText cterm=NONE ctermbg=30 ctermfg=195 gui=NONE guibg=#cb6c6c guifg=#000000
hi Directory ctermfg=109 guifg=#b31313
hi Error ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b31313
hi ErrorMsg ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b31313
hi WarningMsg ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b31313
hi NonText ctermbg=NONE ctermfg=236 guibg=NONE guifg=#798085
hi SpecialKey ctermbg=NONE ctermfg=236 guibg=NONE guifg=#798085
hi EndOfBuffer ctermbg=NONE ctermfg=236 guibg=NONE guifg=#f1f2f2
hi Folded ctermbg=235 ctermfg=245 guibg=#f1f2f2 guifg=#ffffff
hi FoldColumn ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#798085
hi Function ctermfg=203 gui=bold guifg=#b31313
hi Identifier cterm=NONE ctermfg=109 guifg=#b31313
hi Include ctermfg=110 guifg=#b31313
hi LineNr ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#798085
hi MatchParen ctermbg=237 ctermfg=255 guibg=#1458b7 guifg=#000000
hi MoreMsg ctermfg=150 guifg=#298c43
hi Normal ctermbg=234 ctermfg=252 guibg=NONE guifg=#000000
hi NormalAutoBG ctermbg=NONE ctermfg=252 guibg=NONE guifg=#000000
hi Operator ctermfg=252 guifg=#000000
hi Pmenu ctermbg=235 ctermfg=252 guibg=#d6d8da guifg=#000000
hi PmenuSel ctermbg=237 ctermfg=252 guibg=#93999e guifg=#000000
hi PmenuSbar ctermbg=236 guibg=#d6d8da
hi PmenuThumb ctermbg=251 guibg=#60656a
hi PreProc ctermfg=110 guifg=#b31313
hi Question ctermfg=110 guifg=#b31313
hi Search ctermbg=216 ctermfg=234 guibg=#fbd103 guifg=#000000
hi SignColumn ctermbg=235 ctermfg=239 guibg=NONE guifg=#798085
hi Special cterm=bold ctermfg=110 gui=bold guifg=#b31313
hi SpellBad guisp=#b31313
hi SpellCap guisp=#b31313
hi SpellLocal guisp=#b31313
hi SpellRare guisp=#b31313
hi Statement ctermfg=252 gui=NONE guifg=#000000
hi StatusLine cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#000000 guifg=#bcc0c0 term=reverse
hi StatusLineTerm cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#000000 guifg=#bcc0c0 term=reverse
hi StatusLineNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#333333 guifg=#f0f1f1
hi StatusLineTermNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#333333 guifg=#f0f1f1
hi StorageClass ctermfg=110 guifg=#b31313
hi String ctermfg=109 guifg=#b31313
hi Structure ctermfg=109 guifg=#b31313
hi TabLine cterm=NONE ctermbg=245 ctermfg=234 gui=NONE guibg=#bcc0c0 guifg=#000000
hi TabLineFill cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#000000 guifg=#bcc0c0
hi TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#f1f2f2 guifg=#3c3c3c
hi Title ctermfg=203 gui=NONE guifg=#b31313
hi Todo ctermbg=234 ctermfg=150 guibg=NONE guifg=#b31313
hi Type ctermfg=109 gui=NONE guifg=#b31313
hi Underlined cterm=underline ctermfg=252 gui=underline guifg=#000000 term=underline
hi VertSplit cterm=NONE ctermbg=233 ctermfg=233 gui=NONE guibg=#f0f1f1 guifg=#f0f1f1
hi Visual ctermbg=236 guibg=#aeb2b5
hi WildMenu ctermbg=255 ctermfg=234 guibg=#ffffff guifg=#000000
hi diffAdded ctermfg=150 guifg=#298c43
hi diffRemoved ctermfg=203 guifg=#b31313
hi ALEErrorSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi ALEWarningSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi ALEStyleError cterm=underline gui=underline
hi ALEError cterm=underline gui=underline
hi ALEWarning cterm=underline gui=underline
hi CtrlPMode1 ctermbg=241 ctermfg=234 guibg=#c9cccc guifg=#000000
hi EasyMotionShade ctermfg=239 guifg=#3d4f5b
hi EasyMotionTarget ctermfg=150 guifg=#298c43
hi EasyMotionTarget2First ctermfg=203 guifg=#b31313
hi EasyMotionTarget2Second ctermfg=203 guifg=#b31313
hi GitGutterAdd ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#298c43
hi GitGutterChange ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#0e3f80
hi GitGutterChangeDelete ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#0e3f80
hi GitGutterDelete ctermbg=235 ctermfg=239 guibg=#f1f2f2 guifg=#b31313
hi CocErrorSign cterm=bold ctermbg=235 ctermfg=216 gui=bold guibg=#f1f2f2 guifg=#b31313
hi CocWarningFloat ctermbg=NONE ctermfg=216 guibg=NONE guifg=#ff630a
hi CocWarningSign cterm=bold ctermbg=235 ctermfg=216 gui=bold guibg=#f1f2f2 guifg=#ff630a
hi Sneak ctermbg=140 ctermfg=234 guibg=#b31313 guifg=#f1f2f2
hi SneakScope ctermbg=236 ctermfg=242 guibg=#aeb2b5 guifg=#798085
hi SyntasticErrorSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi SyntasticStyleErrorSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi SyntasticStyleWarningSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi SyntasticWarningSign ctermbg=235 ctermfg=203 guibg=#f1f2f2 guifg=#b31313
hi ZenSpace ctermbg=203 guibg=#b31313
hi icebergALAccentRed ctermfg=203 guifg=#b31313

hi! link cssBraces Delimiter
hi! link cssClassName Special
hi! link cssClassNameDot NormalAutoBG
hi! link cssPseudoClassId Function
hi! link cssTagName Statement
hi! link helpHyperTextJump Constant
hi! link htmlArg Constant
hi! link htmlEndTag Statement
hi! link htmlTag Statement
hi! link jsonQuote NormalAutoBG
hi! link phpVarSelector Identifier
hi! link rubyDefine Statement
hi! link rubyInterpolationDelimiter String
hi! link rubySharpBang Comment
hi! link rubyStringDelimiter String
hi! link sassClass Special
hi! link shFunction NormalAutoBG
hi! link vimContinue Comment
hi! link vimIsCommand NormalAutoBG
hi! link vimCommand NormalAutoBG
hi! link vimVar NormalAutoBG
hi! link vimLet Statement
hi! link vimFuncKey Statement
hi! link xmlAttrib Constant
hi! link xmlAttribPunct Statement
hi! link xmlEndTag Statement
hi! link xmlNamespace Statement
hi! link xmlTag Statement
hi! link xmlTagName Statement
hi! link yamlKeyValueDelimiter Delimiter
hi! link CtrlPPrtCursor Cursor
hi! link CtrlPMatch Title
hi! link CtrlPMode2 StatusLine
hi! link deniteMatched NormalAutoBG
hi! link deniteMatchedChar Function
hi! link jsFlowType Statement
hi! link jsFlowMaybe NormalAutoBG
hi! link jsFlowObject NormalAutoBG
hi! link graphqlIdentifier NormalAutoBG
hi! link graphqlOperator NormalAutoBG
hi! link graphqlStructure Statement
hi! link jsArrowFunction Operator
hi! link jsClassMethodType Statement
hi! link jsExport Statement
hi! link jsFuncName NormalAutoBG
hi! link jsFunction Function
hi! link jsGlobalObjects Statement
hi! link jsModuleKeywords Statement
hi! link jsModuleOperators Statement
hi! link jsObjectKey Identifier
hi! link jsSuper Statement
hi! link markdownBold Special
hi! link markdownCode String
hi! link markdownCodeDelimiter String
hi! link markdownHeadingDelimiter Comment
hi! link markdownRule Comment
hi! link plug1 NormalAutoBG
hi! link plug2 Structure
hi! link plugDash Comment
hi! link plugMessage Special
hi! link CocErrorFloat Error
hi! link svssBraces Delimiter
hi! link swiftIdentifier NormalAutoBG
hi! link typescriptAjaxMethods NormalAutoBG
hi! link typescriptBraces NormalAutoBG
hi! link typescriptEndColons NormalAutoBG
hi! link typescriptGlobalObjects Statement
hi! link typescriptHtmlElemProperties NormalAutoBG
hi! link typescriptIdentifier Statement
hi! link typescriptMessage NormalAutoBG
hi! link typescriptNull Constant
hi! link typescriptParens NormalAutoBG
hi! link texMathZoneC Normal

if has('nvim')
  let g:terminal_color_0 = '#f1f2f2'
  let g:terminal_color_1 = '#b31313'
  let g:terminal_color_2 = '#298c43'
  let g:terminal_color_3 = '#b31313'
  let g:terminal_color_4 = '#b31313'
  let g:terminal_color_5 = '#b31313'
  let g:terminal_color_6 = '#b31313'
  let g:terminal_color_7 = '#000000'
  let g:terminal_color_8 = '#798085'
  let g:terminal_color_9 = '#cf0f0f'
  let g:terminal_color_10 = '#29a449'
  let g:terminal_color_11 = '#cf0f0f'
  let g:terminal_color_12 = '#cf0f0f'
  let g:terminal_color_13 = '#cf0f0f'
  let g:terminal_color_14 = '#cf0f0f'
  let g:terminal_color_15 = '#0d0c0c'
endif

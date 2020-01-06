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
" Modified:   2020-01-06 16:13+0800
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


hi! ColorColumn cterm=NONE ctermbg=235 guibg=#bcbfc2
hi! CursorColumn cterm=NONE ctermbg=235 guibg=#bcbfc2
hi! CursorLine cterm=NONE ctermbg=235 guibg=#bcbfc2
hi! Comment ctermfg=242 guifg=#798085
hi! Constant ctermfg=140 guifg=#b71421
hi! Cursor ctermbg=252 ctermfg=234 guibg=#0c0c0c guifg=#f4f4f4
hi! CursorLineNr ctermbg=237 ctermfg=253 guibg=#93999e guifg=#0c0c0c
hi! Delimiter ctermfg=252 guifg=#0c0c0c
hi! DiffAdd ctermbg=29 ctermfg=158 guibg=#afddd6 guifg=#0d3b33
hi! DiffChange ctermbg=23 ctermfg=159 guibg=#e1b0b4 guifg=#3f0e12
hi! DiffDelete ctermbg=95 ctermfg=224 guibg=#e1b0b4 guifg=#3f0e12
hi! DiffText cterm=NONE ctermbg=30 ctermfg=195 gui=NONE guibg=#cf6d75 guifg=#0c0c0c
hi! Directory ctermfg=109 guifg=#b71421
hi! Error ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b71421
hi! ErrorMsg ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b71421
hi! WarningMsg ctermbg=NONE ctermfg=203 guibg=NONE guifg=#b71421
hi! EndOfBuffer ctermbg=NONE ctermfg=236 guibg=NONE guifg=#798085
hi! NonText ctermbg=NONE ctermfg=236 guibg=NONE guifg=#798085
hi! SpecialKey ctermbg=NONE ctermfg=236 guibg=NONE guifg=#798085
hi! Folded ctermbg=235 ctermfg=245 guibg=#bcbfc2 guifg=#ffffff
hi! FoldColumn ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#798085
hi! Function ctermfg=203 gui=bold guifg=#b71421
hi! Identifier cterm=NONE ctermfg=109 guifg=#b71421
hi! Include ctermfg=110 guifg=#b71421
hi! LineNr ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#798085
hi! MatchParen ctermbg=237 ctermfg=255 guibg=#5b8ed6 guifg=#0c0c0c
hi! MoreMsg ctermfg=150 guifg=#11aa91
hi! Normal ctermbg=234 ctermfg=252 guibg=NONE guifg=#0c0c0c
hi! NormalAutoBG ctermbg=NONE ctermfg=252 guibg=NONE guifg=#0c0c0c
hi! Operator ctermfg=252 guifg=#0c0c0c
hi! Pmenu ctermbg=235 ctermfg=252 guibg=#d6d8da guifg=#0c0c0c
hi! PmenuSel ctermbg=237 ctermfg=252 guibg=#93999e guifg=#0c0c0c
hi! PmenuSbar ctermbg=236 guibg=#d6d8da
hi! PmenuThumb ctermbg=251 guibg=#60656a
hi! PreProc ctermfg=110 guifg=#b71421
hi! Question ctermfg=110 guifg=#b71421
hi! Search ctermbg=216 ctermfg=234 guibg=#b71421 guifg=#f4f4f4
hi! SignColumn ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#798085
hi! Special cterm=bold ctermfg=110 gui=bold guifg=#b71421
hi! SpellBad guisp=#b71421
hi! SpellCap guisp=#b71421
hi! SpellLocal guisp=#b71421
hi! SpellRare guisp=#b71421
hi! Statement ctermfg=252 gui=NONE guifg=#0c0c0c
hi! StatusLine cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#0c0c0c guifg=#868c91 term=reverse
hi! StatusLineTerm cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#0c0c0c guifg=#868c91 term=reverse
hi! StatusLineNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#3f3f3f guifg=#bbbec1
hi! StatusLineTermNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#3f3f3f guifg=#bbbec1
hi! StorageClass ctermfg=110 guifg=#b71421
hi! String ctermfg=109 guifg=#b71421
hi! Structure ctermfg=109 guifg=#b71421
hi! TabLine cterm=NONE ctermbg=245 ctermfg=234 gui=NONE guibg=#868c91 guifg=#0c0c0c
hi! TabLineFill cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#0c0c0c guifg=#868c91
hi! TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#f4f4f4 guifg=#464646
hi! Title ctermfg=203 gui=NONE guifg=#b71421
hi! Todo ctermbg=234 ctermfg=150 guibg=NONE guifg=#b71421
hi! Type ctermfg=109 gui=NONE guifg=#b71421
hi! Underlined cterm=underline ctermfg=252 gui=underline guifg=#0c0c0c term=underline
hi! VertSplit cterm=NONE ctermbg=233 ctermfg=233 gui=NONE guibg=#bbbec1 guifg=#bbbec1
hi! Visual ctermbg=236 guibg=#b2b2b2
hi! WildMenu ctermbg=255 ctermfg=234 guibg=#d6d8d9 guifg=#0c0c0c
hi! diffAdded ctermfg=150 guifg=#11aa91
hi! diffRemoved ctermfg=203 guifg=#b71421
hi! ALEErrorSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! ALEWarningSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! ALEStyleError cterm=underline gui=underline
hi! ALEError cterm=underline gui=underline
hi! ALEWarning cterm=underline gui=underline
hi! CtrlPMode1 ctermbg=241 ctermfg=234 guibg=#b0b3b5 guifg=#0c0c0c
hi! EasyMotionShade ctermfg=239 guifg=#3d4f5b
hi! EasyMotionTarget ctermfg=150 guifg=#11aa91
hi! EasyMotionTarget2First ctermfg=203 guifg=#b71421
hi! EasyMotionTarget2Second ctermfg=203 guifg=#b71421
hi! GitGutterAdd ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#11aa91
hi! GitGutterChange ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#1458b7
hi! GitGutterChangeDelete ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#1458b7
hi! GitGutterDelete ctermbg=235 ctermfg=239 guibg=#bcbfc2 guifg=#b71421
hi! CocErrorSign cterm=bold ctermbg=235 ctermfg=216 gui=bold guibg=#bcbfc2 guifg=#b71421
hi! CocWarningFloat ctermbg=NONE ctermfg=216 guibg=NONE guifg=#ff630a
hi! CocWarningSign cterm=bold ctermbg=235 ctermfg=216 gui=bold guibg=#bcbfc2 guifg=#ff630a
hi! Sneak ctermbg=140 ctermfg=234 guibg=#b71421 guifg=#f4f4f4
hi! SneakScope ctermbg=236 ctermfg=242 guibg=#b2b2b2 guifg=#798085
hi! SyntasticErrorSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! SyntasticStyleErrorSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! SyntasticStyleWarningSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! SyntasticWarningSign ctermbg=235 ctermfg=203 guibg=#bcbfc2 guifg=#b71421
hi! ZenSpace ctermbg=203 guibg=#b71421
hi! icebergALAccentRed ctermfg=203 guifg=#b71421

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
  let g:terminal_color_0 = '#f4f4f4'
  let g:terminal_color_1 = '#b71421'
  let g:terminal_color_2 = '#11aa91'
  let g:terminal_color_3 = '#b71421'
  let g:terminal_color_4 = '#b71421'
  let g:terminal_color_5 = '#b71421'
  let g:terminal_color_6 = '#b71421'
  let g:terminal_color_7 = '#0c0c0c'
  let g:terminal_color_8 = '#798085'
  let g:terminal_color_9 = '#d31020'
  let g:terminal_color_10 = '#0ec6a8'
  let g:terminal_color_11 = '#d31020'
  let g:terminal_color_12 = '#d31020'
  let g:terminal_color_13 = '#d31020'
  let g:terminal_color_14 = '#d31020'
  let g:terminal_color_15 = '#191717'
endif

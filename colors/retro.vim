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
" Modified:   2018-09-02 01:43+0800
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


hi! ColorColumn cterm=NONE ctermbg=235 guibg=#eeeeea
hi! CursorColumn cterm=NONE ctermbg=235 guibg=#eeeeea
hi! CursorLine cterm=NONE ctermbg=235 guibg=#eeeeea
hi! Comment ctermfg=242 guifg=#aeae9c
hi! Constant ctermfg=140 guifg=#b71414
hi! Cursor ctermbg=252 ctermfg=234 guibg=#0c0c0c guifg=#fafaf8
hi! CursorLineNr ctermbg=237 ctermfg=253 guibg=#d7d7cd guifg=#1f1f1f
hi! Delimiter ctermfg=252 guifg=#0c0c0c
hi! DiffAdd ctermbg=29 ctermfg=158 guibg=#e5b5b3 guifg=#3f0e0e
hi! DiffChange ctermbg=23 ctermfg=159 guibg=#e5b5b3 guifg=#3f0e0e
hi! DiffDelete ctermbg=95 ctermfg=224 guibg=#e5b5b3 guifg=#3f0e0e
hi! DiffText cterm=NONE ctermbg=30 ctermfg=195 gui=NONE guibg=#d1706f guifg=#0c0c0c
hi! Directory ctermfg=109 guifg=#b71414
hi! Error ctermbg=234 ctermfg=203 guibg=#fafaf8 guifg=#b71414
hi! ErrorMsg ctermbg=234 ctermfg=203 guibg=#fafaf8 guifg=#b71414
hi! WarningMsg ctermbg=234 ctermfg=203 guibg=#fafaf8 guifg=#b71414
hi! EndOfBuffer ctermbg=234 ctermfg=236 guibg=#fafaf8 guifg=#ffffff
hi! NonText ctermbg=234 ctermfg=236 guibg=#fafaf8 guifg=#ffffff
hi! SpecialKey ctermbg=234 ctermfg=236 guibg=#fafaf8 guifg=#ffffff
hi! Folded ctermbg=235 ctermfg=245 guibg=#eeeeea guifg=#ffffff
hi! FoldColumn ctermbg=235 ctermfg=239 guibg=#eeeeea guifg=#a9a995
hi! Function ctermfg=203 guifg=#b71414
hi! Identifier cterm=NONE ctermfg=109 guifg=#b71414
hi! Include ctermfg=110 guifg=#b71414
hi! LineNr ctermbg=235 ctermfg=239 guibg=#eeeeea guifg=#a9a995
hi! MatchParen ctermbg=237 ctermfg=255 guibg=#ffffff guifg=#8b8b8b
hi! MoreMsg ctermfg=150 guifg=#b71414
hi! Normal ctermbg=234 ctermfg=252 guibg=#fafaf8 guifg=#0c0c0c
hi! Operator ctermfg=110 guifg=#b71414
hi! Pmenu ctermbg=236 ctermfg=251 guibg=#5b5b3d guifg=#0c0c0c
hi! PmenuSbar ctermbg=236 guibg=#5b5b3d
hi! PmenuSel ctermbg=240 ctermfg=255 guibg=#89895b guifg=#f4f4ef
hi! PmenuThumb ctermbg=251 guibg=#0c0c0c
hi! PreProc ctermfg=150 guifg=#b71414
hi! Question ctermfg=150 guifg=#b71414
hi! Search ctermbg=216 ctermfg=234 guibg=#e4aa80 guifg=#392313
hi! SignColumn ctermbg=235 ctermfg=239 guibg=#eeeeea guifg=#a9a995
hi! Special ctermfg=150 guifg=#b71414
hi! SpellBad guisp=#b71414
hi! SpellCap guisp=#b71414
hi! SpellLocal guisp=#b71414
hi! SpellRare guisp=#b71414
hi! Statement ctermfg=110 gui=NONE guifg=#b71414
hi! StatusLine cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#1b1b17 guifg=#969681 term=reverse
hi! StatusLineTerm cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#1b1b17 guifg=#969681 term=reverse
hi! StatusLineNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#ffffff guifg=#f3f3ef
hi! StatusLineTermNC cterm=reverse ctermbg=238 ctermfg=233 gui=reverse guibg=#ffffff guifg=#f3f3ef
hi! StorageClass ctermfg=110 guifg=#b71414
hi! String ctermfg=109 guifg=#b71414
hi! Structure ctermfg=109 guifg=#b71414
hi! TabLine cterm=NONE ctermbg=245 ctermfg=234 gui=NONE guibg=#969681 guifg=#1b1b17
hi! TabLineFill cterm=reverse ctermbg=234 ctermfg=245 gui=reverse guibg=#1b1b17 guifg=#969681
hi! TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#fafaf8 guifg=#474747
hi! Title ctermfg=203 gui=NONE guifg=#b71414
hi! Todo ctermbg=234 ctermfg=150 guibg=#fafaf8 guifg=#e5e599
hi! Type ctermfg=109 gui=NONE guifg=#b71414
hi! Underlined cterm=underline ctermfg=110 gui=underline guifg=#b71414 term=underline
hi! VertSplit cterm=NONE ctermbg=233 ctermfg=233 gui=NONE guibg=#f3f3ef guifg=#f3f3ef
hi! Visual ctermbg=236 guibg=#ffffff
hi! WildMenu ctermbg=255 ctermfg=234 guibg=#dbdbd4 guifg=#1b1b17
hi! diffAdded ctermfg=150 guifg=#b71414
hi! diffRemoved ctermfg=203 guifg=#b71414
hi! CtrlPMode1 ctermbg=241 ctermfg=234 guibg=#cacac0 guifg=#1b1b17
hi! EasyMotionShade ctermfg=239 guifg=#5b5b3d
hi! EasyMotionTarget ctermfg=150 guifg=#b71414
hi! EasyMotionTarget2First ctermfg=203 guifg=#b71414
hi! EasyMotionTarget2Second ctermfg=203 guifg=#b71414
hi! GitGutterAdd ctermbg=235 ctermfg=150 guibg=#eeeeea guifg=#b71414
hi! GitGutterChange ctermbg=235 ctermfg=109 guibg=#eeeeea guifg=#b71414
hi! GitGutterChangeDelete ctermbg=235 ctermfg=109 guibg=#eeeeea guifg=#b71414
hi! GitGutterDelete ctermbg=235 ctermfg=203 guibg=#eeeeea guifg=#b71414
hi! Sneak ctermbg=140 ctermfg=234 guibg=#b71414 guifg=#fafaf8
hi! SneakScope ctermbg=236 ctermfg=242 guibg=#ffffff guifg=#aeae9c
hi! SyntasticErrorSign ctermbg=235 ctermfg=203 guibg=#eeeeea guifg=#b71414
hi! SyntasticStyleErrorSign ctermbg=235 ctermfg=203 guibg=#eeeeea guifg=#b71414
hi! SyntasticStyleWarningSign ctermbg=235 ctermfg=203 guibg=#eeeeea guifg=#b71414
hi! SyntasticWarningSign ctermbg=235 ctermfg=203 guibg=#eeeeea guifg=#b71414
hi! ZenSpace ctermbg=203 guibg=#b71414
hi! icebergALAccentRed ctermfg=203 guifg=#b71414

hi! link cssBraces Delimiter
hi! link cssClassName Special
hi! link cssClassNameDot Normal
hi! link cssPseudoClassId Function
hi! link cssTagName Statement
hi! link helpHyperTextJump Constant
hi! link htmlArg Constant
hi! link htmlEndTag Statement
hi! link htmlTag Statement
hi! link jsonQuote Normal
hi! link phpVarSelector Identifier
hi! link rubyDefine Statement
hi! link rubyInterpolationDelimiter String
hi! link rubySharpBang Comment
hi! link rubyStringDelimiter String
hi! link sassClass Special
hi! link shFunction Normal
hi! link vimContinue Comment
hi! link vimIsCommand Statement
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
hi! link deniteMatched Normal
hi! link deniteMatchedChar Function
hi! link jsFlowType Statement
hi! link jsFlowMaybe Normal
hi! link jsFlowObject Normal
hi! link graphqlIdentifier Normal
hi! link graphqlOperator Normal
hi! link graphqlStructure Statement
hi! link jsArrowFunction Operator
hi! link jsClassMethodType Statement
hi! link jsExport Statement
hi! link jsFuncName Normal
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
hi! link plug1 Normal
hi! link plug2 Structure
hi! link plugDash Comment
hi! link plugMessage Special
hi! link svssBraces Delimiter
hi! link swiftIdentifier Normal
hi! link typescriptAjaxMethods Normal
hi! link typescriptBraces Normal
hi! link typescriptEndColons Normal
hi! link typescriptGlobalObjects Statement
hi! link typescriptHtmlElemProperties Normal
hi! link typescriptIdentifier Statement
hi! link typescriptMessage Normal
hi! link typescriptNull Constant
hi! link typescriptParens Normal

if has('nvim')
  let g:terminal_color_0 = '#fafaf8'
  let g:terminal_color_1 = '#b71414'
  let g:terminal_color_2 = '#b71414'
  let g:terminal_color_3 = '#b71414'
  let g:terminal_color_4 = '#b71414'
  let g:terminal_color_5 = '#b71414'
  let g:terminal_color_6 = '#b71414'
  let g:terminal_color_7 = '#0c0c0c'
  let g:terminal_color_8 = '#aeae9c'
  let g:terminal_color_9 = '#d31010'
  let g:terminal_color_10 = '#d31010'
  let g:terminal_color_11 = '#d31010'
  let g:terminal_color_12 = '#d31010'
  let g:terminal_color_13 = '#d31010'
  let g:terminal_color_14 = '#d31010'
  let g:terminal_color_15 = '#191717'
endif

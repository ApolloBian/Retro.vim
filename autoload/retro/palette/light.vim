function! retro#palette#light#create() abort
" # data source: ./external/retro_palette/colors.json

  " color palette
  let hue_red = 355
  let hue_blue = 215
  let hue_green = 170
  let hue_bgwhite = 350
  let hue_fgblack = 205
  let hue_modgray = 205
  let hue_orange = 22
  " some other alternative colors
  " #1095a9 (river blue)


  " gui {{{
  let g = {}

  let g.red    = "#b31313"
  let g.darkblue = "#0e3f80"
  let g.blue   = "#b31313"
  " let g.green   = "#12a58c"
  let g.green   = "#327343"
  let g.green   = "#298c43"
  let g.light_green   = "#a4e57e"
  let g.lblue   = "#b31313"
  let g.purple   = "#b31313"
  let g.orange   = pgmnt#color#hsl(hue_orange, 1.00, 0.52)
  let g.highlight_bg = "#1458b7"
  let g.yellow = "#fbd103"

  " normal
  let g.normal_bg = "#f2f2f2"
  let g.normal_fg = "#000000"

  " linenr
  let g.linenr_bg = "#bfbfbf"
  let g.linenr_bg = g.normal_bg
  let g.linenr_fg = "#7f7f7f"
  let g.cursorlinenr_bg = "#999999"
  let g.cursorlinenr_fg = g.normal_fg

  " diff
  let g.diffadd_bg = pgmnt#color#mix(g.green, g.normal_bg, 0.30)
  let g.diffadd_fg = pgmnt#color#mix(g.green, g.normal_fg, 0.30)
  let g.diffchange_bg = pgmnt#color#mix(g.lblue, g.normal_bg, 0.30)
  let g.diffchange_fg = pgmnt#color#mix(g.lblue, g.normal_fg, 0.30)
  let g.diffdelete_bg = pgmnt#color#mix(g.red, g.normal_bg, 0.30)
  let g.diffdelete_fg = pgmnt#color#mix(g.red, g.normal_fg, 0.30)

  " statusline
  let g.statusline_bg = "#8c8c8c"
  let g.statusline_fg = g.normal_fg
  let g.statuslinenc_bg = "#bfbfbf"
  let g.statuslinenc_fg = "#333333"

  " cursorline
  let g.cursorline_bg = "#bfbfbf"
  let g.visual_bg = "#b2b2b2"

  " pmenu
  " let g.pmenu_bg = pgmnt#color#hsl(hue_modgray, 0.20, 0.99)
  " let g.pmenu_bg = g.cursorline_bg
  let g.pmenu_bg = "#a5a5a5"
  let g.pmenu_bg = "#7f7f7f"
  let g.pmenu_bg = g.cursorline_bg
  let g.pmenu_fg = g.normal_fg
  " let g.pmenusel_bg = pgmnt#color#hsl(hue_modgray, 0.20, 0.45)
  let g.pmenusel_bg = "#999999"
  let g.pmenusel_fg = g.normal_fg
  let g.pmenuthumb_bg  = "#666666"

  " misc
  let g.comment_fg = "#7f7f7f"
  let g.folded_bg = "#bfbfbf"
  let g.folded_fg = "#666666"
  let g.matchparen_bg = g.highlight_bg
  let g.matchparen_fg = g.normal_fg
  " let g.search_bg = #ffdb72 " yellow
  let g.search_bg = g.red
  let g.search_fg = g.normal_bg
  let g.search_bg = g.yellow
  let g.search_fg = g.normal_fg
  let g.specialkey_fg = g.comment_fg
  let g.todo_fg = g.blue
  let g.wildmenu_bg = "#d8d8d8"
  let g.wildmenu_fg = g.statusline_fg

  " airline/lightline
  let g.xline_base_bg = "#d8d8d8"
  let g.xline_base_fg = g.normal_fg
  let g.xline_edge_bg = g.statusline_bg
  let g.xline_edge_fg = g.statusline_fg
  let g.xline_gradient_bg = "#b2b2b2"
  let g.xline_gradient_fg = g.xline_edge_fg

  " plugins
  let g.easymotion_shade_fg = "#4c4c4c"
  " }}}

  " cterm {{{
  let c = {}

  " palette
  let c.blue = 110
  let c.green = 150
  let c.lblue = 109
  let c.orange = 216
  let c.purple = 140
  let c.red = 203

  " normal
  let c.normal_bg = 234
  let c.normal_fg = 252

  " linenr
  let c.linenr_bg = 235
  let c.linenr_fg = 239
  let c.cursorlinenr_bg = 237
  let c.cursorlinenr_fg = 253

  " diff
  let c.diffadd_bg = 29
  let c.diffadd_fg = 158
  let c.diffchange_bg = 23
  let c.diffchange_fg = 159
  let c.diffdelete_bg = 95
  let c.diffdelete_fg = 224

  " statusline
  let c.statusline_bg = 245
  let c.statusline_fg = 234
  let c.statuslinenc_bg = 233
  let c.statuslinenc_fg = 238

  " pmenu
  let c.pmenu_bg = 236
  let c.pmenu_fg = 251
  let c.pmenusel_bg = 240
  let c.pmenusel_fg = 255

  " misc
  let c.comment_fg = 242
  let c.cursorline_bg = c.linenr_bg
  let c.folded_bg = c.linenr_bg
  let c.folded_fg = 245
  let c.matchparen_bg = 237
  let c.matchparen_fg = 255
  let c.search_bg = c.orange
  let c.search_fg = c.normal_bg
  let c.specialkey_fg = 236
  let c.todo_fg = c.green
  let c.visual_bg = 236
  let c.wildmenu_bg = 255
  let c.wildmenu_fg = c.statusline_fg

  " airline/lightline
  let c.xline_base_bg = 237
  let c.xline_base_fg = 243
  let c.xline_edge_bg = c.statusline_bg
  let c.xline_edge_fg = c.statusline_fg
  let c.xline_gradient_bg = 241
  let c.xline_gradient_fg = c.xline_edge_fg

  " plugins
  let c.easymotion_shade_fg = 239
  " }}}

  return {
        \   'cterm': c,
        \   'gui': g,
        \ }
endfunction

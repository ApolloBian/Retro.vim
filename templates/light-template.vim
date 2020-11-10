function! retro#palette#light#create() abort
" {% source ./external/retro_palette/colors.json}

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

  let g.red    = "{% hex.ansi.red}"
  let g.darkblue = "{% hex.ansi.blue}"
  let g.blue   = "{% hex.ansi.red}"
  " let g.green   = "{% hex.ansi.light_green}"
  let g.green   = "#327343"
  let g.green   = "#298c43"
  let g.light_green   = "#a4e57e"
  let g.lblue   = "{% hex.ansi.red}"
  let g.purple   = "{% hex.ansi.red}"
  let g.orange   = pgmnt#color#hsl(hue_orange, 1.00, 0.52)
  let g.highlight_bg = "{% hex.ansi.light_blue}"
  let g.yellow = "{% hex.ansi.yellow}"

  " normal
  let g.normal_bg = "{% hex.ansi.white}"
  let g.normal_fg = "{% hex.ansi.black}"

  " linenr
  let g.linenr_bg = "{% hex.shades.shade75}"
  let g.linenr_bg = g.normal_bg
  let g.linenr_fg = "{% hex.shades.shade50}"
  let g.cursorlinenr_bg = "{% hex.shades.shade60}"
  let g.cursorlinenr_fg = g.normal_fg

  " diff
  let g.diffadd_bg = pgmnt#color#mix(g.green, g.normal_bg, 0.30)
  let g.diffadd_fg = pgmnt#color#mix(g.green, g.normal_fg, 0.30)
  let g.diffchange_bg = pgmnt#color#mix(g.lblue, g.normal_bg, 0.30)
  let g.diffchange_fg = pgmnt#color#mix(g.lblue, g.normal_fg, 0.30)
  let g.diffdelete_bg = pgmnt#color#mix(g.red, g.normal_bg, 0.30)
  let g.diffdelete_fg = pgmnt#color#mix(g.red, g.normal_fg, 0.30)

  " statusline
  " let g.statusline_bg = pgmnt#color#hsl(hue_modgray, 0.09, 0.55)
  let g.statusline_bg = pgmnt#color#darken(g.linenr_bg, 0.2)
  let g.statusline_fg = g.normal_fg
  " let g.statuslinenc_bg = pgmnt#color#lighten(g.statusline_bg, 0.30)
  let g.statuslinenc_bg = pgmnt#color#lighten(g.statusline_bg, 0.2)
  let g.statuslinenc_fg = pgmnt#color#lighten(g.statusline_fg, 0.2)

  " cursorline
  let g.cursorline_bg = "{% hex.shades.shade75}"
  let g.visual_bg = pgmnt#color#adjust_color(
        \ g.cursorline_bg, {
        \   'saturation': 0,
        \   'lightness': -0.05,
        \ })

  " pmenu
  " let g.pmenu_bg = pgmnt#color#hsl(hue_modgray, 0.20, 0.99)
  " let g.pmenu_bg = g.cursorline_bg
  let g.pmenu_bg = pgmnt#color#lighten(g.cursorline_bg, 0.1)
  let g.pmenu_fg = g.normal_fg
  " let g.pmenusel_bg = pgmnt#color#hsl(hue_modgray, 0.20, 0.45)
  let g.pmenusel_bg = g.cursorlinenr_bg
  let g.pmenusel_fg = g.normal_fg
  let g.pmenuthumb_bg = pgmnt#color#darken(g.pmenusel_bg, 0.2)

  " misc
  let g.comment_fg = g.linenr_fg
  let g.folded_bg = g.linenr_bg
  let g.folded_fg = pgmnt#color#adjust_color(
        \ g.folded_bg, {
        \   'saturation': -0.05,
        \   'lightness': +0.35,
        \ })
  let g.matchparen_bg = g.highlight_bg
  let g.matchparen_fg = g.normal_fg
  " let g.search_bg = #ffdb72 " yellow
  let g.search_bg = g.red
  let g.search_fg = g.normal_bg
  let g.search_bg = g.yellow
  let g.search_fg = g.normal_fg
  let g.specialkey_fg = g.comment_fg
  let g.todo_fg = g.blue
  let g.wildmenu_bg = pgmnt#color#lighten(g.statusline_bg, 0.30)
  let g.wildmenu_fg = g.statusline_fg

  " airline/lightline
  let g.xline_base_bg = pgmnt#color#adjust_color(
        \ g.normal_bg, {
        \   'saturation': 0.00,
        \   'lightness': -0.10,
        \ })
  let g.xline_base_fg = g.normal_fg
  let g.xline_edge_bg = g.statusline_bg
  let g.xline_edge_fg = g.statusline_fg
  let g.xline_gradient_bg = pgmnt#color#mix(g.xline_base_bg, g.xline_edge_bg, 0.50)
  let g.xline_gradient_fg = g.xline_edge_fg

  " plugins
  let g.easymotion_shade_fg = pgmnt#color#hsl(hue_modgray, 0.20, 0.30)
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

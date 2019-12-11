let s:save_cpo = &cpo
set cpo&vim


function! s:build_palette() abort
  let col_base     = ['#0c0c0c', '#dadada', 243, 237]
  let col_edge     = ['#0c0c0c', '#868c91', 234, 245]
  let col_error    = ['#f4f4f4', '#b71421', 234, 203]
  let col_gradient = ['#0c0c0c', '#b0b3b5', 234, 241]
  let col_nc       = ['#3f3f3f', '#bbbec1', 238, 233]
  let col_warning  = ['#f4f4f4', '#b71421', 234, 203]
  let col_insert   = ['#f4f4f4', '#1458b7', 234, 110]
  let col_replace  = ['#f4f4f4', '#b71421', 234, 203]
  let col_visual   = ['#f4f4f4', '#11aa91', 234, 150]
  let col_red      = ['#b71421', '#f4f4f4', 203, 234]

  let p = {}
  let p.inactive = airline#themes#generate_color_map(
        \ col_nc,
        \ col_nc,
        \ col_nc)
  let p.normal = airline#themes#generate_color_map(
        \ col_edge,
        \ col_gradient,
        \ col_base)
  let p.insert = airline#themes#generate_color_map(
        \ col_insert,
        \ col_gradient,
        \ col_base)
  let p.replace = airline#themes#generate_color_map(
        \ col_replace,
        \ col_gradient,
        \ col_base)
  let p.visual = airline#themes#generate_color_map(
        \ col_visual,
        \ col_gradient,
        \ col_base)

  " Accents
  let p.accents = {
        \   'red': col_red,
        \ }

  " Error
  let p.inactive.airline_error = col_error
  let p.insert.airline_error = col_error
  let p.normal.airline_error = col_error
  let p.replace.airline_error = col_error
  let p.visual.airline_error = col_error

  " Warning
  let p.inactive.airline_warning = col_warning
  let p.insert.airline_warning = col_warning
  let p.normal.airline_warning = col_warning
  let p.replace.airline_warning = col_warning
  let p.visual.airline_warning = col_warning

  return p
endfunction


let g:airline#themes#retro#palette = s:build_palette()


let &cpo = s:save_cpo
unlet s:save_cpo

let s:save_cpo = &cpo
set cpo&vim


function! s:build_palette() abort
  let col_base     = ['#000000', '#d8d8d8', 243, 237]
  let col_edge     = ['#000000', '#8c8c8c', 234, 245]
  let col_error    = ['#f2f2f2', '#b31313', 234, 203]
  let col_gradient = ['#000000', '#b2b2b2', 234, 241]
  let col_nc       = ['#333333', '#bfbfbf', 238, 233, 'bold']
  let col_warning  = ['#f2f2f2', '#b31313', 234, 203]
  let col_insert   = ['#f2f2f2', '#0e3f80', 234, 110, 'bold']
  let col_replace  = ['#f2f2f2', '#b31313', 234, 203, 'bold']
  let col_visual   = ['#f2f2f2', '#298c43', 234, 150, 'bold']
  let col_red      = ['#b31313', '#f2f2f2', 203, 234]

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

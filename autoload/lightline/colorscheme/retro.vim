let s:save_cpo = &cpo
set cpo&vim


function! s:build_palette() abort
  let p = {
        \ 'normal':   {},
        \ 'inactive': {},
        \ 'insert':   {},
        \ 'replace':  {},
        \ 'visual':   {},
        \ 'tabline':  {}}

  let col_base     = ['#000000', '#d8d8d8', 243, 237]
  let col_edge     = ['#000000', '#8c8c8c', 234, 245]
  let col_gradient = ['#000000', '#b2b2b2', 234, 241]
  let col_nc       = ['#333333', '#bfbfbf', 238, 233, 'bold']
  let col_tabfill  = ['#000000', '#d8d8d8', 243, 237]
  let col_normal   = ['#f2f2f2', '#b31313', 234, 203, 'bold']
  let col_error    = ['#f2f2f2', '#b31313', 234, 203]
  let col_warning  = ['#f2f2f2', '#b31313', 234, 203]
  let col_insert   = ['#f2f2f2', '#0e3f80', 234, 110, 'bold']
  let col_replace  = ['#f2f2f2', '#b31313', 234, 203, 'bold']
  let col_visual   = ['#f2f2f2', '#298c43', 234, 150, 'bold']
  let col_tabsel   = ['#000000', '#8c8c8c', 234, 245]

  let p.normal.middle = [
        \ col_base]
  let p.normal.left = [
        \ col_normal,
        \ col_gradient]
  let p.normal.right = [
        \ col_edge,
        \ col_gradient]
  let p.normal.error = [
        \ col_error]
  let p.normal.warning = [
        \ col_warning]

  let p.insert.left = [
        \ col_insert,
        \ col_gradient]
  let p.replace.left = [
        \ col_replace,
        \ col_gradient]
  let p.visual.left = [
        \ col_visual,
        \ col_gradient]

  let p.inactive.middle = [
        \ col_nc]
  let p.inactive.left = [
        \ col_nc,
        \ col_nc]
  let p.inactive.right = [
        \ col_nc,
        \ col_nc]

  let p.tabline.middle = [
        \ col_tabfill]
  let p.tabline.left = [
        \ col_tabfill]
  let p.tabline.tabsel = [
        \ col_tabsel]

  let p.tabline.right = copy(p.normal.right)

  return p
endfunction


let g:lightline#colorscheme#retro#palette = s:build_palette()


let &cpo = s:save_cpo
unlet s:save_cpo

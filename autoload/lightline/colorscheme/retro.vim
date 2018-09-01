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

  let col_base     = ['#ffffff', '#ffffff', 243, 237]
  let col_edge     = ['#1b1b17', '#969681', 234, 245]
  let col_gradient = ['#1b1b17', '#cacac0', 234, 241]
  let col_nc       = ['#ffffff', '#f3f3ef', 238, 233]
  let col_tabfill  = ['#ffffff', '#ffffff', 243, 237]
  let col_normal   = ['#1b1b17', '#969681', 234, 245]
  let col_error    = ['#fafaf8', '#b71414', 234, 203]
  let col_warning  = ['#fafaf8', '#b71414', 234, 203]
  let col_insert   = ['#fafaf8', '#b71414', 234, 110]
  let col_replace  = ['#fafaf8', '#b71414', 234, 203]
  let col_visual   = ['#fafaf8', '#b71414', 234, 150]
  let col_tabsel   = ['#1b1b17', '#969681', 234, 245]

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

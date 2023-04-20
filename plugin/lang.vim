" vim: set sw=2 ts=2 sts=2 foldmethod=marker:

" In case this gets sourced twice.
if exists('s:ins_layout')
  finish
endif

let s:ins_layout=''

if exists('g:XkbSwitchEnable') && g:XkbSwitchEnable == 0
  finish
endif

if !exists('g:XkbSwitchLib')
	echoerr "Xkb Switch is enabled but missing path to library"
  finish
endif

if !filereadable(g:XkbSwitchLib)
	echoerr "Cannot open XkbSwitchLib, might be outdated"
  finish
endif

function! s:SwitchLayout()
  let s:ins_layout=libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
  if s:ins_layout == 'us'
    let s:ins_layout=''
  endif
  call libcall(g:XkbSwitchLib, 'Xkb_Switch_setXkbLayout', 'us')
  return ''
endfunction

function! s:RestoreLayout()
  if !empty(s:ins_layout)
    call libcall(g:XkbSwitchLib, 'Xkb_Switch_setXkbLayout', s:ins_layout)
  endif
  let s:ins_layout=''
  return ''
endfunction

autocmd InsertLeave * call <SID>SwitchLayout()
autocmd InsertEnter * call <SID>RestoreLayout()

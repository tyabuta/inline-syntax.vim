let s:save_cpo = &cpo
set cpo&vim

if !exists('g:inline_syntax_filetypes')
  let g:inline_syntax_filetypes = {
        \ "vim" : {
        \   "start" : "vim",
        \},
        \ "diff" : {
        \   "start" : "diff",
        \},
        \ "c" : {
        \   "start" : "c",
        \},
        \ "cpp" : {
        \   "start" : "cpp",
        \},
        \ "php" : {
        \   "start" : "php",
        \},
        \ "java" : {
        \   "start" : "java",
        \},
        \ "ruby" : {
        \   "start" : "\\%(ruby\\|rb\\)",
        \},
        \ "python" : {
        \   "start" : "\\%(python\\|py\\)",
        \},
        \ "perl" : {
        \   "start" : "\\%(perl\\|pl\\)",
        \},
        \ "javascript" : {
        \   "start" : "\\%(javascript\\|js\\)",
        \},
        \ "html" : {
        \   "start" : "html",
        \},
        \ "sh" : {
        \   "start" : "sh",
        \},
        \ "sql" : {
        \   "start" : "sql",
        \},
  \}
endif




function! s:do_include( regionDefinition, filetype )
    let l:syntaxGroupName = 'synInclude' . toupper(a:filetype[0]) . tolower(a:filetype[1:])

    if exists('b:current_syntax')
	let l:current_syntax = b:current_syntax
	unlet b:current_syntax
    endif

    execute printf('syntax include @%s syntax/%s.vim', l:syntaxGroupName, a:filetype)

    if exists('l:current_syntax')
	let b:current_syntax = l:current_syntax
    else
	unlet! b:current_syntax
    endif

    execute printf('syntax region %s %s contains=@%s',
    \   l:syntaxGroupName,
    \   a:regionDefinition,
    \   l:syntaxGroupName
    \)
endfunction

function! s:include( startPattern, endPattern, filetype, ... )
    call s:do_include(
    \   printf('%s keepend start="%s" end="%s" containedin=ALL',
    \       (a:0 ? 'matchgroup=' . a:1 : ''),
    \       a:startPattern,
    \       a:endPattern
    \   ),
    \   a:filetype
    \)
endfunction

function! inline_syntax#apply( startLine, endLine, filetype )
    call s:include(
    \   printf('\%%%dl', a:startLine),
    \   (a:startLine < a:endLine && a:endLine == line('$') ?
    \       '\%$' :
    \       printf('\%%%dl', (a:endLine + 1))
    \   ),
    \   a:filetype
    \)
endfunction

function! inline_syntax#enable_auto_syntax()
  for [filetype, option] in items(g:inline_syntax_filetypes)
    let regexp_start = "^\\s*```" . option.start . "$"
    let regexp_end   = "^\\s*```\\ze\\s*$"
    call s:include(regexp_start, regexp_end, filetype)
  endfor
endfunction

function! inline_syntax#apply_files_default()
  return ["txt","md"]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


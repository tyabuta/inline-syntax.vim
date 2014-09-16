if exists('g:loaded_inline_syntax') || (v:version < 700)
    finish
endif
let g:loaded_inline_syntax = 1

command! -bar -range -nargs=1                  InlineSyntaxApply call inline_syntax#apply(<line1>, <line2>, <q-args>)
command! -bar -range -nargs=1 -complete=syntax InlineSyntaxApply call inline_syntax#apply(<line1>, <line2>, <q-args>)

if !exists('g:inline_syntax_apply_files')
  let g:inline_syntax_apply_files = inline_syntax#apply_files_default()
endif

augroup augroup_inline_syntax
  autocmd!
  execute printf("autocmd BufNewFile,BufRead *.{%s} call inline_syntax#enable_auto_syntax()", join(g:inline_syntax_apply_files,','))
augroup END


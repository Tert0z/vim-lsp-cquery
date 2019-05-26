if exists('g:lsp_cquery_loaded')
    finish
endif
let g:lsp_cquery_loaded = 1

augroup cquery_enable_highlight
    autocmd!
    autocmd User lsp_register_server call cquery#register_highlight()
autocmd InsertEnter call cquery#ui#highlight#remove_highlight_at_line(nvim_get_current_buf(), line('.'))
augroup END

command! LspCqueryDerived call cquery#references#derived()
command! LspCqueryBase call cquery#references#base()
command! LspCqueryVars call cquery#references#vars()
command! LspCqueryCallers call cquery#references#callers()

hi cqueryMember guifg=#689d6a gui=bold
hi cqueryMethod guifg=#458588 gui=bold
hi cqueryFunction guifg=#83a598
hi cqueryLocalVariable guifg=#fabd2f
hi cqueryStaticVariable guifg=None gui=italic
hi cqueryGlobalVariable guifg=None gui=bold
hi cqueryParameter guifg=None
hi cqueryClass guifg=#57934C
hi cqueryStruct guifg=#57934C
hi cqueryNamespace guifg=#fb4934
"hi cqueryDefault guifg=Grey

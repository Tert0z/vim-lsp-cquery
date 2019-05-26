if exists('g:lsp_cquery_loaded')
    finish
endif
let g:lsp_cquery_loaded = 1

augroup cquery_enable_highlight
    autocmd!
    autocmd User lsp_register_server call cquery#register_highlight()
augroup END

command! LspCqueryDerived call cquery#references#derived()
command! LspCqueryBase call cquery#references#base()
command! LspCqueryVars call cquery#references#vars()
command! LspCqueryCallers call cquery#references#callers()
autocmd InsertEnter call cquery#ui#highlight#remove_highlight_at_line(nvim_get_current_buf(), line('.'))

hi cqueryMember ctermfg=Blue
hi cqueryMethod ctermfg=Red cterm=bold
hi cqueryLocalVariable ctermfg=Cyan
hi cqueryStaticVariable ctermfg=Cyan cterm=italic
hi cqueryGlobalVariable ctermfg=Cyan cterm=bold
hi cqueryParameter ctermfg=DarkMagenta

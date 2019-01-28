
function! s:get_target_buffer(uri)
    let l:buf_list = nvim_list_bufs()
    let l:buffer_name = lsp#utils#uri_to_path(a:uri)
    for l:buf in l:buf_list
        if nvim_buf_get_name(l:buf) ==# l:buffer_name
            return l:buf
        endif
    endfor
endfunction

function! s:is_cuquery_supported()
    let l:server_names = lsp#get_server_names()
    return len(l:server_names) && count(l:server_names, 'cquery')
endfunction

function! s:highlight_notify_handler(server_name, data)
    let l:response = a:data.response
    if has_key(l:response, 'method')
        if l:response.method ==# '$cquery/publishSemanticHighlighting'
            let l:target_buffer = s:get_target_buffer(l:response.params.uri)
            if l:target_buffer
                let l:symbols = l:response.params.symbols
                call cquery#ui#highlight#add_highlights(l:target_buffer, l:symbols)
            endif
        endif
    endif
endfunction

function! cquery#register_highlight() abort
    if s:is_cuquery_supported()
        call lsp#register_notifications("highlight_cquery", function('s:highlight_notify_handler'))
    endif
endfunction

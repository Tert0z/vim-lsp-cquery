" Kind :
let s:Unknown = 0
let s:File = 1
let s:Module = 2
let s:Namespace = 3
let s:Package = 4
let s:Class = 5
let s:Method = 6
let s:Property = 7
let s:Field = 8
let s:Constructor = 9
let s:Enum = 10
let s:Interface = 11
let s:Function = 12
let s:Variable = 13
let s:Constant = 14
let s:String = 15
let s:Number = 16
let s:Boolean = 17
let s:Array = 18
let s:Object = 19
let s:Key = 20
let s:Null = 21
let s:EnumMember = 22
let s:Struct = 23
let s:Event = 24
let s:Operator = 25
let s:TypeParameter = 26
let s:TypeAlias = 252
let s:Parameter = 253
let s:StaticMethod = 254
let s:Macro = 255

" Storage :
let s:Invalid = 1
let s:None = 2
let s:Extern = 3
let s:Static = 4
let s:PrivateExtern = 5
let s:Auto = 6
let s:Register = 7

" storage -> parentKind -> kind
let s:highlights_mapping =
            \{
            \   'default' :
            \   {
            \       'default':
            \       {
            \           s:Field : 'cqueryMember',
            \           s:Parameter : 'cqueryParameter',
            \           s:Method : 'cqueryMethod',
            \           s:Variable : 'cqueryGlobalVariable'
            \       },
            \       s:Function :
            \       {
            \           s:Variable : 'cqueryLocalVariable',
            \           s:Parameter : 'cqueryParameter'
            \       },
            \       s:Method :
            \       {
            \           s:Variable : 'cqueryLocalVariable',
            \           s:Parameter : 'cqueryParameter'
            \       },
            \       s:StaticMethod :
            \       {
            \           s:Variable : 'cqueryLocalVariable'
            \       },
            \       s:Constructor :
            \       {
            \           s:Variable : 'cqueryLocalVariable',
            \           s:Parameter : 'cqueryParameter'
            \       }
            \   }
            \}


function! s:get_buffer_namespace(target_buffer)
    try
        let l:buffer_namespace = nvim_buf_get_var(a:target_buffer, 'cquery_hi_namespace')
    catch
        call nvim_buf_set_var(a:target_buffer, 'cquery_hi_namespace', nvim_create_namespace(''))
        let l:buffer_namespace = nvim_buf_get_var(a:target_buffer, 'cquery_hi_namespace')
    endtry
    return l:buffer_namespace
endfunction

function! s:map_symbol_to_highlight(symbol)
    let l:storage_selector = 'default'
    let l:parent_selector = 'default'

    if has_key(s:highlights_mapping, a:symbol.storage)
        let l:storage_selector = a:symbol.storage
    endif

    if has_key(s:highlights_mapping[l:storage_selector], a:symbol.parentKind)
        let l:parent_selector = a:symbol.parentKind
    endif

    if has_key(s:highlights_mapping[l:storage_selector][l:parent_selector], a:symbol.kind)
        return s:highlights_mapping[l:storage_selector][l:parent_selector][a:symbol.kind]
    endif
    return ''
endfunction

function! s:add_highlights(buffer, symbols)
    call s:remove_highlights(a:buffer, 0, -1)
    for l:symbol in a:symbols
        let l:highlight = s:map_symbol_to_highlight(l:symbol)
        if len(l:highlight) > 0
            for l:range in l:symbol.ranges
                call nvim_buf_add_highlight(a:buffer,
                            \ l:buffer_namespace,
                            \ l:highlight,
                            \ l:range['start']['line'],
                            \ l:range['start']['character'],
                            \ l:range['end']['character'])
            endfor
        endif
    endfor
endfunction

function! s:remove_highlights(buffer, line_start, line_end)
    let l:buffer_namespace = s:get_buffer_namespace(a:buffer)
    call nvim_buf_clear_namespace(a:buffer, l:buffer_namespace, line_start, line_end)
endfunction

function! cquery#ui#highlight#remove_highlight_at_line(buffer, line) abort
    call s:remove_highlights(a:buffer, line, line+1)
endfunction

function! cquery#ui#highlight#add_highlights(buffer, symbols) abort
    call s:add_highlights(a:buffer, a:symbols)
endfunction

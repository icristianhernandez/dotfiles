" PSeInt Formatter Integration
"
" Ensure you have python3 installed and pseint_formatter.py is executable.
" Replace '/path/to/pseint_formatter.py' with the actual absolute path
" to your pseint_formatter.py script.
" Or, ensure pseint_formatter.py is in your system's PATH and use:
" let g:pseint_formatter_cmd = 'python3 pseint_formatter.py'
"
" If pseint_formatter.py is in the same directory as the .psc file you are editing:
" let g:pseint_formatter_cmd = 'python3 ' . expand('%:p:h') . '/pseint_formatter.py'

if executable('python3')
    " Define the command to call the PSeInt formatter script.
    " Users should change this path to the correct location of their script.
    " If the script is in PATH, 'python3 pseint_formatter.py' might suffice.
    let g:pseint_formatter_cmd = 'python3 /path/to/pseint_formatter.py'

    function! s:FormatPSeInt(line1, line2)
        let l:save_cursor = winsaveview()
        let l:cmd = ''
        if a:line1 == 0 && a:line2 == 0 " Whole buffer
            let l:cmd = '%!' . g:pseint_formatter_cmd
        else " Range
            let l:cmd = "'" . a:line1 . "," . a:line2 . "!" . g:pseint_formatter_cmd
        endif

        try
            execute l:cmd
        catch
            echohl ErrorMsg
            echo "PSeInt formatting failed. Error: " . v:exception
            echohl None
        finally
            call winrestview(l:save_cursor)
        endtry
    endfunction

    " Command for formatting the whole buffer or a range
    command! -range=% FormatPSeInt call <SID>FormatPSeInt(<line1>, <line2>)

    " Normal mode mapping: format entire buffer
    nnoremap <silent> <leader>fp :call <SID>FormatPSeInt(0, 0)<CR>
    " Visual mode mapping: format selected range
    vnoremap <silent> <leader>fp :<C-U>call <SID>FormatPSeInt(line("'<"), line("'>"))<CR>

    echom "PSeInt Formatter integration loaded. Use <leader>fp to format."
else
    echohl WarningMsg
    echom "python3 executable not found. PSeInt formatter disabled."
    echohl None
endif

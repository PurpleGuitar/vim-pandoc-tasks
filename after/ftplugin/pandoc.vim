" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

autocmd BufWritePre <buffer> :normal! mzgg=G`z

function! PandocTasksExtraSyntax()
    if &ft == 'pandoc'

        syntax match   PandocTaskTODOLine /TODO .*/            contained containedin=PandocUListItem
        syntax match   PandocTaskTODOTag  /TODO/               contained containedin=PandocTaskTODOLine
        syntax match   PandocTaskTODODate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskTODOLine

        syntax match   PandocTaskDONELine /DONE .*/            contained containedin=PandocUListItem
        syntax match   PandocTaskDONETag  /DONE/               contained containedin=PandocTaskDONELine
        syntax match   PandocTaskDONEDate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskDONELine

        syntax match   PandocTaskWAITLine /WAIT .*/            contained containedin=PandocUListItem
        syntax match   PandocTaskWAITTag  /WAIT/               contained containedin=PandocTaskWAITLine
        syntax match   PandocTaskWAITDate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskWAITLine

        highlight link PandocTaskTODOLine PandocUListItem
        highlight link PandocTaskTODOTag  Type
        highlight link PandocTaskTODODate PreProc

        highlight link PandocTaskDONELine Comment
        highlight link PandocTaskDONETag  Constant
        highlight link PandocTaskDONEDate Comment

        highlight link PandocTaskWAITLine PandocUListItem
        highlight link PandocTaskWAITTag  Tag
        highlight link PandocTaskWAITDate PreProc

    endif
endfun
autocmd BufEnter,BufWinEnter * call PandocTasksExtraSyntax()

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

function! PandocTasksExtraSyntax()
    if &ft == 'pandoc'
        syntax match   PandocTaskTagTODO  /TODO/               contained containedin=PandocUListItem
        syntax match   PandocTaskTagDONE  /DONE/               contained containedin=PandocUListItem
        syntax match   PandocTaskTagWAIT  /WAIT/               contained containedin=PandocUListItem
        syntax match   PandocTaskDate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocUListItem
    endif
endfun
autocmd BufEnter,BufWinEnter * call PandocTasksExtraSyntax()

highlight link PandocTaskTagTODO  Type
highlight link PandocTaskTagDONE  Constant
highlight link PandocTaskTagWAIT  Tag
highlight link PandocTaskDate PreProc

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

syntax match PandocTaskTODO /\<TODO\>/ contained containedin=PandocUListItem
syntax match PandocTaskDONE /\<DONE\>/ contained containedin=PandocUListItem
syntax match PandocTaskWAIT /\<WAIT\>/ contained containedin=PandocUListItem

highlight link PandocTaskTODO Tag
highlight link PandocTaskDONE Constant
highlight link PandocTaskWAIT Type


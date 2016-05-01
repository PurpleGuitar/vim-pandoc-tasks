" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

syntax match   PandocTaskTODOLine /TODO .*/            contained containedin=PandocUListItem
syntax match   PandocTaskTODOTag  /TODO/               contained containedin=PandocTaskTODOLine
syntax match   PandocTaskTODODate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskTODOLine

highlight link PandocTaskTODOLine PandocUListItem
highlight link PandocTaskTODOTag  Tag
highlight link PandocTaskTODODate PreProc

syntax match   PandocTaskDONELine /DONE .*/            contained containedin=PandocUListItem
syntax match   PandocTaskDONETag  /DONE/               contained containedin=PandocTaskDONELine
syntax match   PandocTaskDONEDate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskDONELine

highlight link PandocTaskDONELine Comment
highlight link PandocTaskDONETag  Constant
highlight link PandocTaskDONEDate Comment

syntax match   PandocTaskWAITLine /WAIT .*/            contained containedin=PandocUListItem
syntax match   PandocTaskWAITTag  /WAIT/               contained containedin=PandocTaskWAITLine
syntax match   PandocTaskWAITDate /\d\d\d\d-\d\d-\d\d/ contained containedin=PandocTaskWAITLine

highlight link PandocTaskWAITLine PandocUListItem
highlight link PandocTaskWAITTag  Type
highlight link PandocTaskWAITDate PreProc

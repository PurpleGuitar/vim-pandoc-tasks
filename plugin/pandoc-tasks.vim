
let s:FIRST_STATUS = 0
let s:STATUS_TODO = 0
let s:STATUS_DONE = 1
let s:STATUS_WAIT = 2
let s:NUM_STATUSES = 3
let s:STATUS_NAMES = [
    \ 'TODO',
    \ 'DONE',
    \ 'WAIT'
    \ ]
let s:STATUS_REGEXES = [
    \ '\<TODO\>',
    \ '\<DONE\>',
    \ '\<WAIT\>'
    \ ]


function! s:task_toggle()
    let line = getline('.')
    let index = 0
    while index < s:NUM_STATUSES
        let match = matchstr(line, s:STATUS_REGEXES[index])
        if match != ""
            let next_index = index + 1
            if next_index >= s:NUM_STATUSES
                let next_index = s:FIRST_STATUS
            endif
            let text = s:STATUS_NAMES[next_index]
            let line = substitute(line, s:STATUS_REGEXES[index], text, '')
            let cursor_pos = getcurpos()
            call setline('.', line)
            if mode() == 'n'
                call cursor(cursor_pos[1], cursor_pos[4])
            endif
            return
        endif
        let index = index + 1
    endwhile
endfunction

command! -range TaskToggle <line1>,<line2>call s:task_toggle()

" " PANDOC TASKS EXPERIMENT
"
" let s:REGEX_TASK_TODO        = '!\[_\] '
" let s:REGEX_TASK_WAITING     = '!\[w\] '
" let s:REGEX_TASK_DONE        = '!\[x\] \(\d\d\d\d-\d\d-\d\d \)\?'
" let s:REGEX_TASK_UNFINISHED  = s:REGEX_TASK_TODO . '\|' . s:REGEX_TASK_WAITING
" let s:REGEX_TASK_ANY         = s:REGEX_TASK_TODO . '\|' . s:REGEX_TASK_WAITING . '\|' . s:REGEX_TASK_DONE
" let s:REGEX_PANDOC_LIST_ITEM = '^\(\s*\)\(- \)\?\(.*\)$'
"
"
" function! s:task_toggle()
"     let line=getline('.')
"     if matchstr(line, s:REGEX_TASK_TODO) != ""
"         let timestamp=strftime("%Y-%m-%d")
"         let line = substitute(line, s:REGEX_TASK_TODO, '![x] ' . timestamp . ' ', '')
"     elseif matchstr(line, s:REGEX_TASK_DONE) != ""
"         let line = substitute(line, s:REGEX_TASK_DONE, '![_] ', '')
"     elseif matchstr(line, s:REGEX_TASK_WAITING) != ""
"         let line = substitute(line, s:REGEX_TASK_WAITING, '![_] ', '')
"     elseif matchstr(line, s:REGEX_PANDOC_LIST_ITEM) != ""
"         let groups = matchlist(line, s:REGEX_PANDOC_LIST_ITEM)
"         let line = groups[1] . groups[2] . '![_] ' . groups[3]
"     else
"         return
"     endif
"     call setline('.', line)
" endfunction
"
"
" function! s:task_wait()
"     let line=getline('.')
"     if matchstr(line, s:REGEX_TASK_ANY) != ""
"         let line = substitute(line, s:REGEX_TASK_ANY, '![w] ', '')
"     elseif matchstr(line, s:REGEX_PANDOC_LIST_ITEM) != ""
"         let groups = matchlist(line, s:REGEX_PANDOC_LIST_ITEM)
"         let line = groups[1] . groups[2] . '![w] ' . groups[3]
"     else
"         return
"     endif
"     call setline('.', line)
" endfunction
"
"
" function! s:task_delete()
"     let line=getline('.')
"     if matchstr(line, s:REGEX_TASK_ANY) != ""
"         let line = substitute(line, s:REGEX_TASK_ANY, '', '')
"     else
"         return
"     endif
"     call setline('.', line)
" endfunction
"
"
" function! s:compare_tasks_by_name(i1, i2)
"     let i1_text = substitute(a:i1.text, '^\s*\(.\{-}\)\s*$', '\1', '')
"     let i2_text = substitute(a:i2.text, '^\s*\(.\{-}\)\s*$', '\1', '')
"     return i1_text < i2_text ? -1 : 1
" endfunction
"
" function! s:compare_tasks_by_name_reverse(i1, i2)
"     let i1_text = substitute(a:i1.text, '^\s*\(.\{-}\)\s*$', '\1', '')
"     let i2_text = substitute(a:i2.text, '^\s*\(.\{-}\)\s*$', '\1', '')
"     return i1_text < i2_text ? 1 : -1
" endfunction
"
"
" function! s:quickfix_tasks()
"     let task_regex = '/' . s:REGEX_TASK_UNFINISHED . '/'
"     try
"         execute 'vimgrep' task_regex '%'
"     catch
"         echom "No tasks."
"     endtry
" endfunction
"
" function! s:quickfix_tasks_done()
"     let task_regex = '/' . s:REGEX_TASK_DONE . '/'
"     try
"         execute 'vimgrep' task_regex '%'
"     catch
"         echom "No tasks."
"     endtry
" endfunction
"
"
" function! s:quickfix_tasks_by_name()
"     let task_regex = '/' . s:REGEX_TASK_UNFINISHED . '/'
"     try
"         execute 'vimgrep' task_regex '%'
"         let sortedList = sort(getqflist(), 's:compare_tasks_by_name')
"         call setqflist(sortedList)
"         cc 1
"     catch
"         echom "No tasks."
"     endtry
" endfunction
"
" function! s:quickfix_tasks_done_by_name()
"     let task_regex = '/' . s:REGEX_TASK_DONE . '/'
"     try
"         execute 'vimgrep' task_regex '%'
"         let sortedList = sort(getqflist(), 's:compare_tasks_by_name')
"         call setqflist(sortedList)
"         cc 1
"     catch
"         echom "No tasks."
"     endtry
" endfunction
"
" function! s:quickfix_tasks_done_by_name_reverse()
"     let task_regex = '/' . s:REGEX_TASK_DONE . '/'
"     try
"         execute 'vimgrep' task_regex '%'
"         let sortedList = sort(getqflist(), 's:compare_tasks_by_name_reverse')
"         call setqflist(sortedList)
"         cc 1
"     catch
"         echom "No tasks."
"     endtry
" endfunction
"
" command! TaskList call s:quickfix_tasks()
" command! TaskListByName call s:quickfix_tasks_by_name()
" command! TaskListDone call s:quickfix_tasks_done()
" command! TaskListDoneByName call s:quickfix_tasks_done_by_name()
" command! TaskListDoneByNameReverse call s:quickfix_tasks_done_by_name_reverse()
" command! -range TaskToggle <line1>,<line2>call s:task_toggle()
" command! -range TaskWait <line1>,<line2>call s:task_wait()
" command! -range TaskDelete <line1>,<line2>call s:task_delete()

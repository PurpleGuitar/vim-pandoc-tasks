
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
    \ '\<TODO\>\C',
    \ '\<DONE\( \d\d\d\d-\d\d-\d\d\)\?\>\C',
    \ '\<WAIT\>\C'
    \ ]
let s:STATUS_REGEXES_NO_DATE = [
    \ '\<TODO\>\C',
    \ '\<DONE\>\C',
    \ '\<WAIT\>\C'
    \ ]
let s:STATUS_REGEX_UNFINISHED =
    \ s:STATUS_REGEXES[s:STATUS_TODO] .
    \ '\|' .
    \ s:STATUS_REGEXES[s:STATUS_WAIT]
let s:STATUS_REGEX_TASK =
    \ s:STATUS_REGEXES[s:STATUS_TODO] .
    \ '\|' .
    \ s:STATUS_REGEXES[s:STATUS_WAIT] .
    \ '\|' .
    \ s:STATUS_REGEXES[s:STATUS_DONE]
let s:STATUS_REGEX_TASK_NO_DATE =
    \ s:STATUS_REGEXES_NO_DATE[s:STATUS_TODO] .
    \ '\|' .
    \ s:STATUS_REGEXES_NO_DATE[s:STATUS_WAIT] .
    \ '\|' .
    \ s:STATUS_REGEXES_NO_DATE[s:STATUS_DONE]


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
            if next_index == s:STATUS_DONE
                let timestamp = strftime("%Y-%m-%d")
                let text = text . ' ' . timestamp
            endif
            let line = substitute(line, s:STATUS_REGEXES[index], text, '')
            call setline('.', line)
            return
        endif
        let index = index + 1
    endwhile
endfunction

function! s:task_delete()
    let line=getline('.')
    if matchstr(line, s:STATUS_REGEX_TASK) != ""
        let line = substitute(line, s:STATUS_REGEX_TASK, '', '')
    else
        return
    endif
    call setline('.', line)
endfunction

function! s:compare_tasks_by_text(i1, i2)
    let i1_text = substitute(a:i1.text, '^\s*\(.\{-}\)\s*$', '\1', '')
    let i1_text = substitute(i1_text, s:STATUS_REGEX_TASK_NO_DATE, '', '')
    let i2_text = substitute(a:i2.text, '^\s*\(.\{-}\)\s*$', '\1', '')
    let i2_text = substitute(i2_text, s:STATUS_REGEX_TASK_NO_DATE, '', '')
    return i1_text < i2_text ? -1 : 1
endfunction

function! s:compare_tasks_by_text_reverse(i1, i2)
    let result = s:compare_tasks_by_text(a:i1, a:i2)
    return result * -1
endfunction

function! s:task_list(regex, sort_function, ...)
    let glob1 = '%'
    let glob2 = ''
    if a:0 > 0
        let glob1 = a:1
    endif
    if a:0 > 1
        let glob2 = a:2
    endif
    let task_regex = '/' . a:regex . '/j'
    try
        silent execute 'vimgrep' task_regex glob1 glob2
        let task_list = getqflist()
        if a:sort_function != ''
            let task_list = sort(task_list, a:sort_function)
        endif
        call setqflist(task_list)
    catch
        echom "No tasks."
    endtry
endfunction


command! -range PandocTaskToggle <line1>,<line2>call s:task_toggle()
command! -range PandocTaskDelete <line1>,<line2>call s:task_delete()

" command! -nargs=? PandocTaskTest             call s:task_list(s:STATUS_REGEXES[s:STATUS_TODO], '', <args>)

command! -nargs=* PandocTaskListTodo             call s:task_list ( s:STATUS_REGEXES[s:STATUS_TODO] , ''                                , <args> )
command! -nargs=* PandocTaskListTodoSorted       call s:task_list ( s:STATUS_REGEXES[s:STATUS_TODO] , 's:compare_tasks_by_text'         , <args> )
command! -nargs=* PandocTaskListWait             call s:task_list ( s:STATUS_REGEXES[s:STATUS_WAIT] , ''                                , <args> )
command! -nargs=* PandocTaskListWaitSorted       call s:task_list ( s:STATUS_REGEXES[s:STATUS_WAIT] , 's:compare_tasks_by_text'         , <args> )
command! -nargs=* PandocTaskListDone             call s:task_list ( s:STATUS_REGEXES[s:STATUS_DONE] , ''                                , <args> )
command! -nargs=* PandocTaskListDoneSorted       call s:task_list ( s:STATUS_REGEXES[s:STATUS_DONE] , 's:compare_tasks_by_text_reverse' , <args> )
command! -nargs=* PandocTaskListUnfinished       call s:task_list ( s:STATUS_REGEX_UNFINISHED       , ''                                , <args> )
command! -nargs=* PandocTaskListUnfinishedSorted call s:task_list ( s:STATUS_REGEX_UNFINISHED       , 's:compare_tasks_by_text'         , <args> )

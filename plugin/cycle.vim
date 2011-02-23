" cycle.vim - Toggle between related words
"
" TODO: 
"
" 1. Filetype specific cycle groups (see endwise.vim for inspiration)
"
" 2. The ability to handle pairs: quotes, brackets, html tags, etc.
"
" 3. Operate on non-lowercase text and retain case
" 
" 4. Allow work on substrings - 8px to 8%
"
" 5. Put cursor back at beginning of word if it started there
"
" Bugs:
"
" - Calling Cycle from whitespace before a matching word
" - Does not work with speeddating.vim, only one or the other.
"

" Uncomment for production
"
" if exists("g:loaded_cycle")
"   finish
" endif
" let g:loaded_cycle = 1

let s:options = [
  \ ['==', '!='],
  \ ['+=', '-='],
  \ ['&&', '||'],
  \ ['and', 'or'],
  \ ['if', 'unless'],
  \ ['true', 'false'],
  \ ['YES', 'NO'],
\]

" CSS/Sass/JavaScript/HTML
let s:options = s:options + [
  \ ['px', '%', 'em'],
  \ ['left', 'right'],
  \ ['top', 'bottom'],
  \ ['margin', 'padding'],
  \ ['height', 'width'],
  \ ['div', 'p', 'span'],
  \ ['h1', 'h2', 'h3'],
  \ ['png', 'jpg', 'gif'],
\]


function! AddCycleGroup(group)
  call add(s:options, a:group)
endfunction


function! s:Cycle(word, direction)
  let groups = filter(copy(s:options), "index(v:val, a:word) >= 0")

  " echo(string(groups)) 

  if empty(groups)
    if exists("g:loaded_speeddating")
      echo 'speed dating!'
    else
      echo 'no speed dating'
    endif
      
    if a:direction == 1
      exe "norm! \<C-A>"
    else
      exe "norm! \<C-X>"
    endif
  else
    " Currently doesn't account for more than one group
    let group = groups[0]
    let index = index(group, a:word) + a:direction
   
		let max_index = (len(group) - 1)

		if index > max_index
			let index = 0
		endif

		exe "normal ciw".group[index]
  endif

endfunction



call AddCycleGroup(['one', 'two', 'three'])

" Ruby
call AddCycleGroup(['else', 'elsif'])

" top
" unless
" one
" ||
" margin
" ==
" right
" div

nnoremap <silent> <Plug>CycleNext   :<C-U>call <SID>Cycle(expand("<cword>"), 1)<CR>
nnoremap <silent> <Plug>CyclePrevious :<C-U>call <SID>Cycle(expand("<cword>"), -1)<CR>
" vnoremap <silent> <Plug>CycleUp   :<C-U>call <SID>incrementvisual(v:count1)<CR>
" vnoremap <silent> <Plug>CycleDown :<C-U>call <SID>incrementvisual(-v:count1)<CR>

if !exists("g:cycle_no_mappings") || !g:cycle_no_mappings
  nmap  <C-A>     <Plug>CycleNext
  nmap  <C-X>     <Plug>CyclePrevious
  " xmap  <C-A>     <Plug>CycleUp
  " xmap  <C-X>     <Plug>CycleDown
endif

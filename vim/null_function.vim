function!	s:null_function()
	let	l:line			= getline('.')
	let	l:cword			= expand("<cword>")
	let	l:substr		= matchlist(l:line, '\v' . l:cword . '\((.*)\)')

	if s:define_exists()
		return
	endif
	if !empty(l:substr)
		call s:write_define(l:cword, l:substr[1])
	else
		let l:substr	= matchlist(l:line, '\v(\w+)\((.*)\)')
		if !empty(l:substr)
			call s:write_define(l:substr[1], l:substr[2])
		else
			echo "Error: Cannot detect a regular function name"
		endif
	endif
endfunction

function!	s:define_exists()
	let l:line			= getline(line('.') - 1)

	if empty(l:line)
		return 0
	endif

	let l:match			= matchstr(l:line, '\v^#define \w+\(.*\) .*$')
	if !empty(l:match)
		execute "normal! kddjdd"
		return 1
	endif
	return 0
endfunction

function!	s:write_define(function_name, params)
	let l:params_string	= s:get_params_string(a:params)

	if empty(l:params_string)
		echo "Error: Cannot handle that much parameters"
	else
		execute "normal! O#define " . a:function_name . "(" . l:params_string . ") 0\<ESC>jo#undef " . a:function_name . "\<ESC>"
	endif
endfunction

function!	s:get_params_string(params)
	let l:i				= 0
	let l:str			= ""
	let l:params_count	= count(a:params, ',') + 1

	if l:params_count > 26
		return ""
	endif
	while l:i < l:params_count
		if l:i > 0
			let l:str	.= ", "
		endif
		let l:str		.= nr2char(char2nr('a') + l:i)
		let l:i			+= 1
	endwhile
	return l:str
endfunction

command! NullFunction call s:null_function ()
map ,n :NullFunction<CR>

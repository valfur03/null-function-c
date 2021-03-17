function!	s:null_function()
	let	l:line		= expand(getline('.'))
	let	l:cword		= expand("<cword>")
	let	l:substr	= matchstr(l:line, '\v' . l:cword . '\(.*\)')

	if !empty(l:substr)
		call s:write_define(l:cword)
	else
		let l:substr	= matchlist(l:line, '\v(\w+)\(.*\)')
		if !empty(l:substr)
			call s:write_define(l:substr[1])
		else
			echo "Warning: Cannot detect a regular function name"
		endif
	endif
endfunction

function!	s:write_define(function_name)
	execute "normal! O#define " . a:function_name . "(x) 0\<ESC>jo#undef " . a:function_name . "\<ESC>"
endfunction

command! NullFunction call s:null_function ()
map ,n :NullFunction<CR>

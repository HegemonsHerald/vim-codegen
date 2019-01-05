" UTILITY FUNCTIONS

" Formatting

" selects n lines downwards and calls '='
" Format(0) formats the active line;
" Format(1) formats the active line and the line below it, and so on...
func! Format(n)

	" visually select the lines with n down moves and call '='
	if a:n == 0
		silent exec 'norm! V='
	else
		silent exec 'norm! V'.a:n.'j='
	endif

	" the execs are silent, so '=' doesn't tell you it indented lines

endfunc

" turns a list of words to a concatenated string in upper camel case format
func! ToUpperCamelCase(list)

	" upper-case the first letter of each word in the list
	call map(a:list, {i, v -> substitute(v, '^\(.\)\(.*\)', '\U\1\E\2', '')})

	" return the joined list
	return join(a:list, '')

endfunc

" turns a list of words to a concatenated string in lower camel case format
func! ToLowerCamelCase(list)

	" upper-case the first letter of each word in the list, except for the
	" first word
	let rest = a:list[1:len(a:list)]
	let str = ToUpperCamelCase(rest)

	" join that rest with the first (lower-case) word and return
	return join([a:list[0], str], '')

endfunc

" turns a list of words to a concatenated string in snake case format
func! ToSnakeCase(list)

	" insert underscore in front of every word, escept the first word
	let rest = a:list[1:len(a:list)]
	let str = ToSnakeCaseHelper(rest)

	" join the words with the first, not-underscored word
	return join([a:list[0], str], '')

endfunc

" inserts the underscores for snake case in front of every word in the list
func! ToSnakeCaseHelper(list)

	" insert underscore in front of every word in list
	call map(a:list, {i, v -> '_'.v})

	return join(a:list, '')

endfunc

" turns a list of words to a concatenated string in snake case format, but in
" all caps
func! ToAllCapsSnakeCase(list)

	" make snake case phrase
	let str = ToSnakeCase(a:list)

	" make it all upper case
	return toupper(str)

endfunc


" Adders

" Adds a string to the end of the current line
func! AddString(string)

	set paste

	" add string on the line below
	call append(line('.'), [a:string])

	" merge line below into current line
	norm! J

	" reformat the changed line
	call Format(0)

	set nopaste

endfunc

" Adds a list of lines at the end of the current line
func! AddLines(lines)

	set paste

	" add lines on the line below
	call append(line('.'), a:lines)

	" merge line below into current line
	norm! J

	" reformat the changed lines
	call Format(len(a:lines)-1)

	set nopaste

endfunc

" Adds a C-style {} code block to the end of the current line
func! AddBlock()

	set paste

	" what a block is
	let block = ['{', '', '░', '', '}' ]

	" add block below current line
	call append(line('.'), block)

	" merge line below into current line
	norm! J

	" format the block
	call Format(4)

	" remove the format-locker symbol in the middle line
	norm! 2j
	norm! $
	norm! x
	norm! 2k

	set nopaste

endfunc

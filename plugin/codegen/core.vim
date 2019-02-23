
" Prompts without a second argument to input()
func! Prompt(prompt, transformer, default)
	return PromptRunner(a:prompt, a:transformer, a:default, '')
endfunc

" Prompts with the second argument to input() set to default
func! Prompt2(prompt, transformer, default)
	return PromptRunner(a:prompt, a:transformer, a:default, a:default)
endfunc

" Prompts with prompt as first argument to input(), promptDefault as second.
" If the return of input() is '', default will be used instead.
" Before returning transformer will be applied to the string.
"
" A standard list of transformers is provided as a set of lambdas in global
" variables in the transformers.vim file.
func! PromptRunner(prompt, transformer, default, promptDefault)
	let i = trim(input(a:prompt, a:promptDefault))

	if i == ''
		let i = a:default
	endif

	return a:transformer(i)
endfunc

" Returns a snippet.
"
" name		The name of the snippet, will be printed above the prompts.
"
" fString	A format string to insert the results of the prompts into.
"
" prompts	A list of lambdas, that return a string ot insert in the
" 		format string. Usually these call prompt.
"
" 		Calls to prompt have to be wrapped in lambdas, cause you can't
" 		pass around functions as arguments in vimscript. The Prompts
" 		would be evaluated before they are passed as arguments, which
" 		isn't what we want.
func! Snippet(name, fString, prompts)
	" Output snippet name
	echo a:name

	let format  = a:fString

	" Evaluate Prompts
	let prompts = Map({P -> P()}, a:prompts)

	" Insert the one-to-one tokens

	return Format(format, prompts)
endfunc

" Optional Snippet, prompts whether it should be inserted or not.
"
" The default arg should be either 'Y' or 'N', which will determine the
" default behaviour of the prompt.
"
" The optional argument is an override return value for when the user said no,
" but you still want to return something else than ''.
"
" Note, that while the OptSnippet creates a Snippet, it does NOT supply that
" Snippet with a name, so that the name will only be printed for the
" OptSnippet. (This behaviour could be changed for LISP, where it should also
" be easily possible to have the Prompt()s prompt with 'SNIPPET-NAME / PROMPT > '
func! OptSnippet(name, default, format, prompts, ...)
	let p = a:default == 'Y' ? 'Y/n' : 'y/N'
	let i = trim(input('Insert '.a:name.'? '.p.' > '))

	if (i == '' && a:default == 'Y') || (i[0] != 'n' && i[0] != 'N')
		return Snippet('', a:format, a:prompts)
	else
		if a:0 > 0
			return a:1
		else
			return ''
		endif
	endif
endfunc

" Takes input format: [ string, moves, [12] ]
"
" string	The string (possibly with newlines) to insert at the current
" 		cursor position.
"
" moves		The series of key-strokes to execute using norm!, this allows
" (optional)	you to reposition the cursor after the insertion.
" 		If this isn't provided, no motions will be run.
"
" [12]		If this is 1, startinsert will be called.
" (optional)	If this is 2, startinsert! will be called.
" 		If this isn't provided, startinsert won't be called at all.
"
" Based on the number of newlines found in string the '=' formatter
" will be run
"
" TODO explain exactly how the formatting is done
func! Inserter(data)
	let data   = a:data
	let string = data[0]

	" insert
	exec 'norm! $a'.string

	" format
	let lines = len(split(string, "\n"))
	exec 'norm! '.lines.'=kj$'

	" handle moves and startinsert
	if len(data) > 1 

		" execute moves
		if data[1] != ''
			exec 'norm! '.data[1]
		endif

		" execute startinsert
		if len(data) > 2
			if     data[2] == 1
				startinsert
			elseif data[2] == 2
				startinsert!
			endif
		endif

	endif
endfunc

" Helper with making decision about motions in case of conditional inputs
" Wraps: match(string, pattern) != -1 ? found : notFound
func! Motion(string, pattern, found, notFound)
	return match(a:string, a:pattern) != -1 ? a:found : a:notFound
endfunc

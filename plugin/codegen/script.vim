source functionals.vim

" PROMPT FUNCTIONS ===========================================================

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
func! PromptRunner(prompt, transformer, default, promptDefault)
	let i = trim(input(a:prompt, a:promptDefault))

	if i == ''
		let i = a:default
	endif

	return a:transformer(i)
endfunc

" SNIPPET FUNCTIONS ==========================================================

" name		the name of the snippet
" format	a format string to insert the results of the prompts into
" prompts	a list of lambdas, that return something (usually call prompt)
" 		=> These have to be wrapped in lambdas, cause I can't pass
" 		around func!tions as arguments in vimscript. The Prompts would
" 		be evaluated before they are passed as arguments, which isn't
" 		what we want.
func! Snippet(name, format, prompts)
	" Output snippet name
	echo a:name

	let format  = a:format

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

" FORMAT FUNCTION ============================================================

func! Format(fString, tokens)
	let tokens = a:tokens
	let format = a:fString

	" Linear substitution
	let format = SubstLinear  (format, tokens)

	" Indexed substitution
	let format = SubstIndexed (format, tokens)

	return format
endfunc

func! SubstLinear(fString, tokens)
	return FlattenStr(AlternateFull(split(a:fString, '{\@<!{}}\@!'), a:tokens))
endfunc

func! SubstIndexed(fString, tokens)
	let r  = '{\@<!{\d\+}}\@!'

	" in order of application (bottom up):
	"   - split the string on the index pattern
	"   - map the substrings, that match the index pattern, to their
	"     corresponding token
	"      - s[1:len(s)-2] removes the first and last
	"        character of s, leaving just the index
	"   - concatenate to a string and return

	return FlattenStr(
			\  Map({ s -> match(s, r) != -1 ? a:tokens[ s[1:len(s)-2] ] : s },
			\  SplitStr(a:fString, r)))
endfunc

" ============================================================================
" TRANSFORMERS ===============================================================

" If the key has a value in the dict, this returns the value,
" otherwise it returns the key
func! MaybeLookup(key, dict)
	if has_key(a:dict, a:key)
		return a:dict[a:key]
	else
		return a:key
	endif
endfunc

" Type transformer
let s:TypeDict = {'i': 'int', 'd': 'double'}
let s:Type = { string -> MaybeLookup(string, s:TypeDict)}

" Name transformers
let s:SnakeCase      = { string -> join(    split(trim(string)                                        ), '_') }
let s:LowerSnakeCase = { string -> join(map(split(trim(string)), {i,v -> tolower(v)}                  ), '_') }
let s:UpperSnakeCase = { string -> join(map(split(trim(string)), {i,v -> toupper(v[0]).tolower(v[1:])}), '_') }
let s:UpperCase      = { string -> join(map(split(trim(string)), {i,v -> toupper(v)}                  ), '_') }
let s:CamelCase      = { string -> join(map(split(trim(string)), {i,v -> toupper(v[0]).v[1:]}         ),  '') }
let s:LowerCamelCase = { string -> trim(string)[0].s:CamelCase(trim(string))[1:] }

" Do nothing transformer
let s:Id = {string -> string}








func! Tester()

	let i = input('> ')

	echo s:Type           (i)
	echo s:SnakeCase      (i)
	echo s:LowerSnakeCase (i)
	echo s:UpperSnakeCase (i)
	echo s:UpperCase      (i)
	echo s:CamelCase      (i)
	echo s:LowerCamelCase (i)
	echo s:Id             (i)

endfunc


" takes input format: [ string, moves, [12] ]
"
"  - string	The string (possibly with newlines) to insert at the current
"  		cursor position.
"
"  - moves	The series of key-strokes to execute using norm!, this allows
"  		you to reposition the cursor after the insertion.
"  		If this isn't provided, no motions will be run.
"  		[ optional ]
"
"  - [12]	If this is 1, startinsert will be called.
"  		If this is 2, startinsert! will be called.
"  		If this isn't provided, startinsert won't be called at all.
"  		[ optional ]
"
" based on the number of newlines found in string the '=' formatter
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

func! Visibility(visibility)
	if a:visibility == 1
		return 'private '
	elseif a:visibility == 2
		return  'public '
	else
		return ''
	endif
endfunc


let s:TypePrompt = {   -> Prompt('type: ', s:Type,            'int') }
let s:NamePrompt = {   -> Prompt('name: ', s:LowerCamelCase, 'name') }
let s:IdPrompt   = { p -> Prompt(       p, s:Id,                 '') }
let s:ValuesPrompt = { -> s:IdPrompt('values: ') }

let s:LitSnippet = { fString         -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, s:ValuesPrompt]) }
let s:ConSnippet = { fString, lambda -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, lambda]) }

func! ObjLiteral(visibility)
	let visib = Visibility(a:visibility)
	return [ s:LitSnippet(visib."{} {} = {};"), '', 1 ]
endfunc

func! ArrLiteral(visibility)
	let visib = Visibility(a:visibility)
	return [ s:LitSnippet(visib."{}[] {} = \{ {} \};"), '2h', 1 ]
endfunc

func! ObjConstructor(visibility)
	let visib = Visibility(a:visibility)
	return [ s:ConSnippet(visib."{} {} = new {0}({});", {-> s:IdPrompt('constructor arguments: ')}) , 'h', 1 ]
endfunc

func! ArrConstructor(visibility)
	let visib = Visibility(a:visibility)
	return [ s:ConSnippet(visib."{}[] {} = new {0}[{}];", {-> s:IdPrompt('number of elements: ')}) , 'h', 1 ]
endfunc



let s:block = " {\n\nX\n\n}"
let s:blockMotions = '2j$x'

func! If()
	return [ Snippet('', "if ({})".s:block, [{-> s:IdPrompt('if condition: ')}]), s:blockMotions, 1 ]
endfunc

func! ElseIf()
	let if = If()
	return [ ' else '.if[0], s:blockMotions , 1 ]
endfunc

func! Else()
	return [ " else ".s:block, s:blockMotions , 1 ]
endfunc

func! IfOne()
	let l = Snippet('', "if ({}) ;", [{-> s:IdPrompt('if condition: ')}])
	return [ l, Motion(l, '()', '2h', ''), '', 1 ]
endfunc

" Helper with making decision about motions in case of conditional inputs
" Wraps: match(string, pattern) != -1 ? found : notFound
func! Motion(string, pattern, found, notFound)
	return match(a:string, a:pattern) != -1 ? a:found : a:notFound
endfunc

" vim: set foldmethod=indent


" WHAT THIS IS
"
" I'm learning haskell right now, and it gave me some ideas on the structure
" of functions... Since vimscript is mostly procedural and even has some
" functional features you can apply some of those ideas to create some really
" need code, as it turns out.
" The stuff below doesn't actually work, cause I couldn't be assed to debug
" and finish it, but as a little test it was quite satisfying.


" this is the tag prompter fully functionally implemented

let s:newlinePattern = '\\ \|\\n'


func! Rest(list)

	return a:list[1:len(a:list)]

endfunc!


func! JdocPrompt(promptString, default)

	let i = input(' > '.a:promptString.' ')

	if i == ''
		let i = a:default
	endif

	return split(i, s:newlinePattern)

endfunc


func! JdocSpaces(n)

	let spaces = '	'

	if a:n > 0

		for i in range(a:n)

			let spaces = ' '.spaces

		endfor

	endif

	return spaces

endfunc


func! JdocFirstline(line)

	let l = a:line

	if l[len(l)-1] != '.'
		let l = l.'.'
	endif

	return toupper(l[0]).l[1:len(l)]

endfunc


func! JdocGetDesc(default)

	let desc  = JdocPrompt('', a:default)
	let basic = [' * '.JdocFirstline(desc[0])]

	if len(desc) == 1

		return basic

	else

		return basic + map(Rest(desc), "' * '.v:val")

	endif

endfunc

func! JdocGetTags(tagString, indentNum, default)

	" Where clause...
	let desc  = JdocPrompt(a:tagString, a:default)
	let basic = [' *', ' * '.a:tagString.JdocSpaces(a:indentNum - len(a:tagString)).desc[0]]

	if len(desc) == 1

		return basic

	else

		let fullSpaces = JdocSpaces(a:indentNum)
		return basic + map(Rest(desc), "' * '.fullSpaces.v:val")

	endif

endfunc

func! Flat2d(list)

	let flatList = []

	for element in a:list

		let flatList = flatList + element

	endfor

	return flatList

endfunc

" If you just want a description, you might get a one-liner...
func! JdocDesc(default)

	" Where...
	let desc = JdocGetDesc(a:default)

	" Match Guard 1
	if len(desc) == 1

		" Function definition...
		let d = desc[0]

		return ['/*'.d[1:len(d)].' */']

	endif

	" Otherwise function definition...
	return ['/**'] + desc + [' */']

endfunc

func! JdocIndentSpaces(list)

	let list = copy(a:list)

	let len = map(list, "len(v:val)")

	return max(len)

endfunc

func! JdocMulti(descDefault, parameters, exceptions, return)

	" Where...
	let desc = JdocGetDesc(a:descDefault)


	let params = a:parameters
	let paramsTags = copy(params)
	let paramsTags = map(paramsTags, "'@params '.v:val")

	let except = a:exceptions
	let exceptTags = copy(except)
	let exceptTags = map(exceptTags, "'@params '.v:val")

	let returnTag  = '@return'

	" This'd be a local function
	if params == []
		let indentSpaces = JdocIndentSpaces(exceptTags)
	else
		let indentSpaces = JdocIndentSpaces(paramsTags + [returnTag])
	endif


	" I can merge all the tags to prompt for now, cause I know how many
	" spaces I'll need!
	if a:return != ''
		let names = params + except + [a:return]
		let tags  = paramsTags + exceptTags + [returnTag]
	else
		let names = params + except
		let tags  = paramsTags + exceptTags
	endif

	let tags = map(tags, { i, v -> JdocGetTags(v, indentSpaces, names[i]) })
	let tags = Flat2d(tags)

	" Function definition...
	return ['/**'] + desc + tags + [' */']

endfunc







" Ok, so like a lot of this works now, and that's just fucking great!
" I'm still not going to use this solution, cause I already got a working one,
" and I don't want to have to finish debugging this one. This is a really
" bloody good solution though, kudos haskell you already taught me a lot here!




" jdoc =  print line
" \ 	print helpText
" \ 	AddLines $ jdocMakeComment dict name line
" 	where	line = getline(line('.'))
" 		type = typeOf line
" 		name = nameOf line type
" 		dict = stdDict ++ makeDict type line
" 
" jdocMakeComment type dict name line
" 	| type == const  = substTokens dict JdocGetDesc(name)
" 	| type == method = substTokens dict JdocGetTags(name, methodParams line, excepts line, return line)
" 	| type == class  = substTokens dict JdocGetTags(name, typeParams line, [], [])



" public void name() {
" public int name() {
" public int name( int ho) {
" class honk<T> {

func! Jdoc()

	" Where...
	let line     = getline(line('.'))
	let type     = JdocTypeOf(line)
	let dict     = JdocDict(line, type)
	let helpText = JdocHelpText(dict, type)

	" Definition...
	echo line
	echo helpText

	return JdocAddLines( JdocMakeComment(type, dict, line) )

endfunc

func! JdocAddLines(lines)
	return a:lines
endfunc

func! JdocHelpText(dict, type)

	return '%n: '.a:dict['%n']

endfunc

func! JdocDict(line, type)

	" Where...
	let line = a:line
	let dict = { '%{':'{@code' }

	" Match Guards...
	if a:type == s:typeConst

		let dict['%n'] = substitute(line, 'static\s\+final\s\+\<\w\+\>\s\+\(\<\w\+\>\)', '\1', '')
		let dict['%t'] = substitute(line, 'static\s\+final\s\+\(\<\w\+\>\)\s\+\<\w\+\>', '\1', '')

	elseif a:type == s:typeMethod

		let dict['%n'] = substitute(line, '.*\<\w\+\>\s\+\(\<\w\+\>\)\s*(.*)\s*{', '\1', '')
		let dict['%t'] = substitute(line, '\(\<\w\+\>\)\s\+\<\w\+\>\s*(.*)\s*{', '\1', '')

		let params = JdocGetMethodParams(line)
		for i in range(len(params))
			let dict['%p'.i] = params[i]
		endfor

		let excepts = JdocGetExcepts()
		for i in range(len(excepts))
			let dict['%e'.i] = excepts[i]
		endfor

	elseif a:type == s:typeClass

		let dict['%n'] = substitute(line, '\(class\)\|\(interface\)\|\(enum\)\s\+\(\<\w\+\>\)', '\4', '')

		let params = JdocGetTypeParams(line)
		for i in range(len(params))
			let dict['%p'.i] = params[i]
		endfor

	elseif a:type == s:typeNone

		return {}

	endif

	return dict

endfunc

let s:typeConst  = 'const'
let s:typeClass  = 'class'
let s:typeMethod = 'method'
let s:typeNone   = 'not commentable'

func! JdocTypeOf(line)

	let line = a:line

	if match([line], 'static\s\+final') == 0
		return s:typeConst

	elseif match([line], '\(class\)\|\(interface\)\|\(enum\)') == 0
		return s:typeClass

	elseif match([line], '.*\<\w\+\>\s\+\<\w\+\>\s*(.*)\s*{') == 0
		return s:typeMethod

	else
		return s:typeNone
	endif

endfunc




func! JdocMakeComment(type, dict, line)

	" Where...
	let line = a:line
	let dict = a:dict
	let name = dict['%n']

	" Match Guards...
	if a:type == s:typeConst

		return JdocSubstTokens(dict, JdocDesc(name))

	elseif a:type == s:typeMethod

		return JdocSubstTokens(dict, JdocMulti(name, JdocGetMethodParams(line), JdocGetExcepts(), JdocGetReturn(line)))

	elseif a:type == s:typeClass

		return JdocSubstTokens(dict, JdocMulti(name, JdocGetTypeParams(line), [], []))

	elseif a:type == s:typeNone

		return []

	endif

endfunc

func! JdocSubstTokens(dict, lines)

	return map(a:lines, { i,v -> JdocSubstTokensHelper(a:dict, v) })

endfunc

func! JdocSubstTokensHelper(dict, line)

	let line = a:line

	for token in keys(a:dict)
		let line = substitute(line, token, a:dict[token], '')
	endfor

	return line

endfunc


func! JdocGetTypeParams(line)

	let params = split(substitute(a:line, '.*<\(.*\)>\s*{', '\1', ''), ',')
	let params = map(params, "trim(v:val)")

	return params

endfunc


func! JdocGetMethodParams(line)

	let params = split(substitute(a:line, '.*(\(.*\)).*', '\1', ''), ',')
	let params = map(params, "substitute(trim(v:val), '\w\+\s\+\(\w\+\)', '\1', '')")
	let params = map(params, "trim(v:val)")

	return params

endfunc

func! JdocGetExcepts()

	" That annoying thing from the other bit...
	return []

endfunc

func! JdocGetReturn(line)

	let r = substitute(a:line, '.*\(\<\w\+\>\)\s\+\<\w\+\>\s*(.*)\s*{', '\1', '')

	if r != 'public' && r != 'void'
		return r
	else
		return ''
	endif

endfunc

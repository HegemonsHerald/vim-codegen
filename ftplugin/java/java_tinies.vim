runtime codegen_lib/transformers.vim
runtime codegen_lib/functionals.vim
runtime codegen_lib/format.vim
runtime codegen_lib/core.vim


" 0 => ''
" 1 => 'private '
" 2 => 'public '
func! Visibility(visibility)
	if a:visibility == 1
		return 'private '
	elseif a:visibility == 2
		return  'public '
	else
		return ''
	endif
endfunc


" IMPORTANT NOTICE:
" All functions that take 'prefix' as argument will prefix their output with
" that argument. This is used for Visibility keywords and Constant Declarations:
"
" 	:call Function(Visibility(NUMBER))	=> adds a visibility modifier
" 	:call Function('static final ')		=> adds a 'static final '



" REUSABLE PROMPTS AND VARIABLES

let s:block = " {\n\nX\n\n}"
let s:blockMotions = '2j$x'

" for the TypePrompt, see below
let s:TypePrompt = {   -> Prompt('type: ', { s -> TypeTransformer(s) }, 'int') }
let s:NamePrompt = {   -> Prompt('name: ', g:LowerCamelCase, 'name') }
let s:IdPrompt   = { p -> Prompt(       p, g:Id,                 '') }
let s:ValuesPrompt = { -> s:IdPrompt('values: ') }



" THE TYPE PROMPT IMPLEMENTATION

let s:TypeDict    = { 'i':'int',     'S':'short', 'c':'char', 'd':'double', 'f':'float', 'b':'boolean', 's':'String', 'al':'ArrayList<', 'v':'Vector<' }
let s:GenericDict = { 'i':'Integer', 'S':'Short', 'c':'Char', 'd':'Double', 'f':'Float', 'b':'Boolean', 's':'String', 'al':'ArrayList<', 'v':'Vector<' }

func! TypeTransformer(string)
	return TTransformer(a:string, s:TypeDict, '')
endfunc

func! GenericsTransformer(string, previousString)
	" if we pass always the previously parsed token to this function as
	" well, we an call AddIfNotThere() from here, to get that neat
	" behaviour as well!
	return TTransformer(a:string, s:GenericDict, a:previousString)
endfunc

" Prompts recursively with GenericsTransformer() if the input ends in ',' or
" in '<' or, if the input is an abbreviation, the substitution of the
" abbreviation does.
func! TTransformer(string, dict, previousString)
	let string = trim(a:string)
	let s = TypeFormat(string, a:dict)

	let lastChar = Last(Chars(s))

	if lastChar == '<'
		" TODO split this into a neat multi-line thing so one can read it....
		let genericParams = SnippetExtendedIterate('Type Argument', 'N', '{}', [{-> Prompt('type (generic) - '.a:previousString.s.' : ', { m -> GenericsTransformer(m, a:previousString.s) }, 'Integer') }], { s -> FlattenStr(Map({ s -> s.',' }, Init(s)) + [Last(s)]) }, 1)
		echo s.genericParams.'>'
		return s . genericParams . '>'
	else
		return s
	endif
endfunc

func! TypeFormat(token, dict)
	let l = TypeLookup(a:token, a:dict)
	return l[0] ? l[1] : s:FixGeneric(g:CamelCase(l[1]))
endfunc

" g:CamelCase takes care of whitespace removal
let s:FixGeneric = { s -> match(s, '<>\=$') != -1 ? substitute(s, '>$', '', '') : s }

" returns [1,value] if the lookup was successfull,
" and     [0, key ] if the lookup failed
func! TypeLookup(token, dict)
	return has_key(a:dict, a:token) ? [ 1, a:dict[a:token] ] : [ 0, a:token ]
endfunc



" CONSTANTS, CONSTRUCTORS AND LITERALS

let s:LitSnippet = { fString         -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, s:ValuesPrompt]) }
let s:ConSnippet = { fString, lambda -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, lambda]) }

func! ObjLiteral(prefix)
	call Inserter( [ s:LitSnippet(a:prefix."{} {} = {};"), '', 1 ] )
endfunc

func! ArrLiteral(prefix)
	call Inserter( [ s:LitSnippet(a:prefix."{}[] {} = \{ {} \};"), '2h', 1 ] )
endfunc

func! ObjConstructor(prefix)
	call Inserter( [ s:ConSnippet(a:prefix."{} {} = new {0}({});", {-> s:IdPrompt('constructor arguments: ')}) , 'h', 1 ] )
endfunc

func! ArrConstructor(prefix)
	call Inserter( [ s:ConSnippet(a:prefix."{}[] {} = new {0}[{}];", {-> s:IdPrompt('number of elements: ')}) , 'h', 1 ] )
endfunc

" TODO vector, arraylist variants
" TODO constant variants
" TODO proper type transformer



" CONTROL FLOW CONSTRUCTS

" Basic Control Flow

func! Iff(promptStr)
	let l = Snippet('', "if ({})".s:block, [{-> s:IdPrompt(a:promptStr)}])
	return [ l ] + Motion(l, '()', [s:blockMotions.'2k0f)', 1], [s:blockMotions, 2])
endfunc

func! If()
	call Inserter( Iff('if condition: ') )
endfunc

func! ElseIf()
	let if = Iff('else if condition: ')
	call Inserter( [ 'else'.if[0] ] + Tail(if) )
endfunc

func! Else()
	call Inserter( [ 'else'.s:block, s:blockMotions , 2 ] )
endfunc

" Oneliners

func! Ifo(promptStr)
	let l = Snippet('', "if ({}) ;", [{-> s:IdPrompt(a:promptStr)}])
	return [ l, Motion(l, '()', '2h', ''), 1 ]
endfunc

func! IfOne()
	call Inserter( Ifo('if condition (oneline): ') )
endfunc

func! ElseIfOne()
	let if = Ifo('else if condition (oneline): ')
	call Inserter( [ 'else '.if[0] ] + Tail(if) )
endfunc

func! ElseOne()
	call Inserter( [ "else ;", '', 1 ] )
endfunc


" The Switch statement
" This template function has multiple optional prompts. First it prompts for a
" switch condition. Then it will continuously prompt for the varying cases and
" their code blocks. The snippet execution ends, when the user declines to
" enter another case, when prompted.
"
" After the user decided to enter a case two prompts will happen.
"
" The 'Enter Case(s): ' prompt expects a whitespace separated list of cases.
" Entering as follows
"
" 	Enter Case(s): 1 2 3 4 7
"
" will result in
"
" 	case 1: case 2: case 3:
" 	case 4: case 7:
"
" The 'Enter Code: ' prompt expects the code for the current case statement.
" By default a "\nbreak;" will be appended. To override this behaviour the
" entered string must end in " nobreak".
"
" You may use "\n" for linebreaks in the code block, though it seems advisable
" to use this snippet more to quickly generate the infrastructure and to add
" the code afterwards.
func! Switch()
	" Transformers
	let s:CaseTransformer = { s -> Unlines( Map( {l->Unwords(l)}, GroupNFull( 3, Map( { w -> 'case '.w.':' }, split(s) ) ) ) ) . "\n" }
	let s:CodeTransformer = { s -> s:CodeTrans( substitute(s, '\\n', '\n', 'g') ) }
	let s:CodeTrans       = { s -> Unwords( Init(Words(s)) + Map( { w -> w == 'nobreak' ? '' : w."\nbreak;" }, [Last(Words(s))] ) ) }
	let s:Inspect         = { s -> SwitchPrint(s) }

	" Case Snippet
	let Snip  = { -> s:Inspect( OptSnippet('Case', 'Y', "{} {}\n", [
				\ { -> Prompt('Enter Case(s): ', s:CaseTransformer, '0') },
				\ { -> Prompt('Enter Code: ', s:CodeTransformer, '42;') } ]) ) }

	" Repeatedly prompt for Cases
	let Cases = { -> FlattenStr( IterateWhile( { p -> p != '' }, Snip, Snip() ) ) }

	" snippets have an output heigth of 2 lines, if a name is provided
	let old_cmdheight = &cmdheight
	let &cmdheight = 1000

	" The Switch Statement
	let s = Snippet('Switch', "switch ({}) {\n{}}", [
				\ { -> Prompt('Enter Switch Condition: ', g:Id, 'true') },
				\ Cases ])

	" reset output height
	let &cmdheight = old_cmdheight

	call Inserter( [ s ] )
endfunc

" Helper to print string in a call chain, so the user gets output the case he
" just entered.
func! SwitchPrint(string)
	echo "\n\n> ".substitute(a:string[0:len(a:string)-2], '\n', '\n> ', 'g')."\n\n"
	return a:string
endfunc


" TODO loops and their transformers => grammar definition



" Methods
" TODO methods

func! MakeMethod(prefix)
endfunc

" vim: foldmethod=indent

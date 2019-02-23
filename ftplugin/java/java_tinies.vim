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



" REUSABLE PROMPTS AND VARIABLES

let s:block = " {\n\nX\n\n}"
let s:blockMotions = '2j$x'

let s:TypePrompt = {   -> Prompt('type: ', Type,            'int') }
let s:NamePrompt = {   -> Prompt('name: ', LowerCamelCase, 'name') }
let s:IdPrompt   = { p -> Prompt(       p, Id,                 '') }
let s:ValuesPrompt = { -> s:IdPrompt('values: ') }



" CONSTANTS, CONSTRUCTORS AND LITERALS

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

" TODO vector, arraylist variants
" TODO constant variants
" TODO proper type transformer



" CONTROL FLOW CONSTRUCTS

" Basic Control Flow

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
func! JavaSwitch()
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
				\ { -> Prompt('Enter Switch Condition: ', b:Id, 'true') },
				\ Cases ])

	" reset output height
	let &cmdheight = old_cmdheight

	return [ s ]
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

" vim: foldmethod=indent

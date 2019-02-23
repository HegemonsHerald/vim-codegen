" TODO remove these, these are for dev
runtime codegen/lib/transformers.vim
runtime codegen/lib/functionals.vim
runtime codegen/lib/format.vim
runtime codegen/lib/core.vim


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

let s:TypePrompt = {   -> Prompt('type: ', {-> 'int'},'int') }
let s:NamePrompt = {   -> Prompt('name: ', g:LowerCamelCase, 'name') }
let s:IdPrompt   = { p -> Prompt(       p, g:Id,                 '') }
let s:ValuesPrompt = { -> s:IdPrompt('values: ') }



" CONSTANTS, CONSTRUCTORS AND LITERALS

let s:LitSnippet = { fString         -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, s:ValuesPrompt]) }
let s:ConSnippet = { fString, lambda -> Snippet('', fString, [s:TypePrompt, s:NamePrompt, lambda]) }

func! ObjLiteral(prefix)
	return [ s:LitSnippet(a:prefix."{} {} = {};"), '', 1 ]
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
	call Inserter( [ l, Motion(l, '()', s:blockMotions.'2k0f)', s:blockMotions), 1 ] )
endfunc

func! If()
	call Inserter( Iff('if condition: ') )
endfunc

func! ElseIf()
	let if = Iff('else if condition: ')
	call Inserter( [ ' else '.if[0] ] + Tail(if) )
endfunc

func! Else()
	call Inserter( [ " else ".s:block, s:blockMotions , 1 ] )
endfunc

" Oneliners

func! Ifo(promptStr)
	let l = Snippet('', "if ({}) ;", [{-> s:IdPrompt(a:promptStr)}])
	call Inserter( [ l, Motion(l, '()', '2h', ''), '', 1 ] )
endfunc

func! IfOne()
	call Inserter( Ifo('if condition (oneline): ') )
endfunc

func! ElseIfOne()
	let if = Ifo('else if condition (oneline): ')
	call Inserter( [ 'else '.if[0] ] + Tail(if) )
endfunc

func! ElseOne()
	call Inserter( [ "else ;", '', '', 1 ] )
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

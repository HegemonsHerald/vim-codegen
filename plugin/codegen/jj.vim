func! Motion(string, pattern, found, notFound)
	return match(a:string, a:pattern) != -1 ? a:found : a:notFound
endfunc

source functionals.vim
source script.vim

let s:Id = {i->i}
let s:Empty = {->''}
let s:templateStr = "package {};\n\npublic class {}{}{}{\n\n	{}\n\n}"

let s:Extend = { s -> s == '' ? s : ' extends '.s.' ' }
let s:Implem = { s -> s == '' ? s : ' implements '.s.' ' }

let s:mainStr = "	public static void main(String[] args) {\n\n		x\n\n	}"

func! JavaClassDefault()

	" snippets have an output heigth of 2 lines, if a name is provided
	let old_cmdheight = &cmdheight
	let &cmdheight = 2

	let l = Snippet( 'Default Java Class', s:templateStr, [
				\ {-> Prompt2('package > ', s:Id, expand('%:p:h:t'))},
				\ {-> Prompt2('class > ',   s:Id, expand('%:p:t:r'))},
				\ {-> Prompt('... extends ',    s:Extend, '')},
				\ {-> Prompt('... implements ', s:Implem, '')},
				\ {-> OptSnippet('main method', 'N', s:mainStr, [s:Empty], 'x')}] )

	" reset output height
	let &cmdheight = old_cmdheight

	return [ l, Motion(l, 'main(String[] args)', '5j$x', '3j$x'), 1 ]

endfunc

func! Print(string)
	echo "\n\n> ".substitute(a:string[0:len(a:string)-2], '\n', '\n> ', 'g')."\n\n"
	return a:string
endfunc

" Put the different functions into different scripts so we don't have such a
" hassle with naming script-locally

" The 'Enter Case(s): ' prompt expects a whitespace separated list of cases:
" 	Enter Case(s): 1 2 3 4 7
" 	=> case 1: case 2: case 3: case 4: case 7:
" The 'Enter Code: ' prompt expects the code for the current case statement.
" By default a "\nbreak;" will be appended. To override this the entered
" string must end in " nobreak". One may use "\n" for linebreaks.
func! JavaSwitch()

	" Transformers
	let s:CaseTransformer = { s -> Unlines( Map( {l->Unwords(l)}, GroupNFull( 3, Map( { w -> 'case '.w.':' }, split(s) ) ) ) ) . "\n" }
	let s:CodeTransformer = { s -> s:CodeTrans( substitute(s, '\\n', '\n', 'g') ) }
	let s:CodeTrans       = { s -> Unwords( Init(Words(s)) + Map( { w -> w == 'nobreak' ? '' : w."\nbreak;" }, [Last(Words(s))] ) ) }
	let s:Inspect         = { s -> Print(s) }

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
				\ { -> Prompt('Enter Switch Condition: ', s:Id, 'true') },
				\ Cases ])

	" reset output height
	let &cmdheight = old_cmdheight

	return [ s ]

endfunc


source core.vim
source transformers.vim

" Definitions

let s:Empty = {->''}



" The generic Java Class Template

let s:templateStr = "package {};\n\npublic class {}{}{}{\n\n	{}\n\n}"
let s:mainStr = "	public static void main(String[] args) {\n\n		x\n\n	}"

let s:Extend = { s -> s == '' ? s : ' extends '.s.' ' }
let s:Implem = { s -> s == '' ? s : ' implements '.s.' ' }

func! JavaClassDefault()

	" snippets have an output heigth of 2 lines, if a name is provided
	let old_cmdheight = &cmdheight
	let &cmdheight = 2

	let l = Snippet( 'Default Java Class', s:templateStr, [
				\ {-> OptSnippet('package', 'Y', '{}', [{-> Prompt2('package > ', b:Id, expand('%:p:h:t'))}])},
				\ {-> Prompt2('class > ',   b:Id, expand('%:p:t:r'))},
				\ {-> Prompt('... extends ',    s:Extend, '')},
				\ {-> Prompt('... implements ', s:Implem, '')},
				\ {-> OptSnippet('main method', 'N', s:mainStr, [s:Empty], 'x')}] )

	" reset output height
	let &cmdheight = old_cmdheight

	return [ l, Motion(l, 'main(String[] args)', '5j$x', '3j$x'), 1 ]

endfunc


runtime codegen_lib/transformers.vim
runtime codegen_lib/functionals.vim
runtime codegen_lib/format.vim
runtime codegen_lib/core.vim


" Definitions

let s:Empty = {->''}



" The generic Java Class Template

let s:templateStr = "{}\n\npublic class {}{}{} {\n\n	{}\n\n}"
let s:mainStr = "	public static void main(String[] args) {\n\n		x\n\n	}"

let s:Package = { s -> s == '' ? s : 'package '.s.';' }
let s:Extend  = { s -> s == '' ? s : ' extends '.s }
let s:Implem  = { s -> s == '' ? s : ' implements '.s }

func! JavaClassDefault()

	" snippets have an output heigth of 2 lines, if a name is provided
	let old_cmdheight = &cmdheight
	let &cmdheight = 2

	let l = Snippet( 'Default Java Class', s:templateStr, [
				\ {-> OptSnippet('package', 'Y', '{}', [{-> Prompt2('package > ', s:Package, expand('%:p:h:t'))}])},
				\ {-> Prompt2('class > ',   g:Id, expand('%:p:t:r'))},
				\ {-> Prompt('... extends ',    s:Extend, '')},
				\ {-> Prompt('... implements ', s:Implem, '')},
				\ {-> OptSnippet('main method', 'N', s:mainStr, [s:Empty], 'x')}] )

	" reset output height
	let &cmdheight = old_cmdheight

	return [ l, Motion(l, 'main(String[] args)', 'gg6j$x', 'gg4j$x'), 2 ]

endfunc


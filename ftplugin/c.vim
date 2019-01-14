
" There isn't much here, I konw. I just didn't want to have this stuff
" crowding up my vimrc...


" TEMPLATES
" =========

" C Template
func! CTemplateGeneral()

	let stdio	= '#include <stdio.h>'
	let locale	= '#include <locale.h>'
	let main	= 'int main() {'

	let unicode1	= '// Make unicode work'
	let unicode2	= 'setlocale(0, "");'

	let ret		= 'return 0;'

	let lines = [ stdio, locale, '', main, '', unicode1, unicode2, '', '', ret, '}']

	call AddLines(lines)

	norm 7jo∙
	norm x

	startinsert!

endfunc

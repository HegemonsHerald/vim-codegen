" think about adding
" {@link } to the thing...



" functions that end within parens if no expression was provided and end in a
" code block if an expr was provided
"
" jforadvanced
" jwhileadvanced
" jdowhileadvanced
" jifblock
" jelseifblock
" jifoneline
" jelseifoneline
"


"
" There are as little comments in this code as possible.
" I think it's mostly selfexplanatory, what happens. At some
" points helpful examples are given to explain how annoying concatenations
" work. Otherwise it should all be too obvious to be documented.
"
"
" Functions to call
"
" conLit	constant literal
" objLit	object literal
" arrLit	array literal
"
" conCon	constant constructor
" objCon	object constructor
" arrCon	array constructor
"
" methodCon	method constructor
"
"
" all of these take visibility as first arg:
" 0 for no keyword, 1 for private, 2 for public
"
" methodCon takes static as second arg:
" 1 for 'add static keyword to method'
"

" Mappings
"
" always j
" then nothing, p or P for no keyword, private, public
" then:
"   o for object
"   a for array
"   then: c for constructor
" then:
"   sf for static final
"   then:
"     c for constructor
"     a for array
"     then: c for constructor
" or:
"   s for static
"   then: m for method
"
"
" It's a language based on the order of keywords in java things.
" eg:
"
" Public Static void Method()
" is jPsm = java public static method
"
" Private Static Final type name[] = new type[n];
" is jpsfac = java private static final array constructor
"


" Templates
" =========

" Makes a basic java class with package and main() method.
" The package is simply the name of the folder the file's in.
func! JavaTemplateGeneral()

	let filename	= expand('%:p:t:r')
	let dirname	= expand('%:p:h:t')
	let package	= 'package '.dirname.';'
	let class	= 'public class '.filename.' {'
	let main	= 'public static void main(String args[]) {'

	let lines = [ package, '', class, '', main, '', '', '}', '', '}' ]

	call AddLines(lines)

	norm 5joN
	norm x

	startinsert!

endfunc

" Creates a basic ACM ConsoleProgram
func! JavaTemplateACMConsole()

	let filename	= expand('%:p:t:r')
	let dirname	= expand('%:p:h:t')
	let package	= 'package '.dirname.';'
	let import	= 'import acm.program.ConsoleProgram;'
	let override    = '@Override'
	let class	= 'public class '.filename.' extends ConsoleProgram {'
	let main	= 'public void run() {'

	let lines = [ package, '', import, '', class, '', override, main, '', '', '}', '', '}' ]

	call AddLines(lines)

	norm 8joN
	norm x

	startinsert!

endfunc

" Creates a basic ACM GraphicsProgram
func! JavaTemplateACMGraphics()

	let filename	= expand('%:p:t:r')
	let dirname	= expand('%:p:h:t')
	let package	= 'package '.dirname.';'
	let import1	= 'import acm.program.GraphicsProgram;'
	let import2	= 'import acm.graphics.*;'
	let override    = '@Override'
	let class	= 'public class '.filename.' extends GraphicsProgram {'
	let main	= 'public void run() {'

	let lines = [ package, '', import1, import2, '', class, '', override, main, '', '', '}', '', '}' ]

	call AddLines(lines)

	norm 9joN
	norm x

	startinsert!

endfunc


" Mappings
" ========

" All of these are leader commands now, cause otherwise stuff
" like jo interferes with words like join, and that we can't have!

" java println
autocmd FileType java inoremap <buffer> <leader>js <Esc>ISystem.out.println(<Esc>A);<Esc>V=$F)i
autocmd FileType java nnoremap <buffer> <leader>js ISystem.out.println(<Esc>A);<Esc>V=$F)

" java object
autocmd FileType java inoremap <buffer> <leader>jo <Esc>:call <SID>ObjLit(0, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpo <Esc>:call <SID>ObjLit(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPo <Esc>:call <SID>ObjLit(2, 1)<Cr>

" java object constructor
autocmd FileType java inoremap <buffer> <leader>joc <Esc>:call <SID>ObjCon(0, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpoc <Esc>:call <SID>ObjCon(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPoc <Esc>:call <SID>ObjCon(2, 1)<Cr>

" java array
autocmd FileType java inoremap <buffer> <leader>ja <Esc>:call <SID>ArrLit(0, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpa <Esc>:call <SID>ArrLit(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPa <Esc>:call <SID>ArrLit(2, 1)<Cr>

" java array constructor
autocmd FileType java inoremap <buffer> <leader>jac <Esc>:call <SID>ArrCon(0, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpac <Esc>:call <SID>ArrCon(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPac <Esc>:call <SID>ArrCon(2, 1)<Cr>

" java array list constructor
autocmd FileType java inoremap <buffer> <leader>jl <Esc>:call <SID>ListCon(0, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpl <Esc>:call <SID>ListCon(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPl <Esc>:call <SID>ListCon(2, 1)<Cr>

" java static final
autocmd FileType java inoremap <buffer> <leader>jpsfo <Esc>:call <SID>ConLit(1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsfo <Esc>:call <SID>ConLit(2)<Cr>

" java static final array
autocmd FileType java inoremap <buffer> <leader>jpsfa <Esc>:call <SID>ConArrLit(1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsfa <Esc>:call <SID>ConArrLit(2)<Cr>

" java static final constructor<buffer>
autocmd FileType java inoremap <buffer> <leader>jpsfoc <Esc>:call <SID>ConCon(1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsfoc <Esc>:call <SID>ConCon(2)<Cr>

" java static final array const<buffer> ructor
autocmd FileType java inoremap <buffer> <leader>jpsfac <Esc>:call <SID>ConArrCon(1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsfac <Esc>:call <SID>ConArrCon(2)<Cr>

" java static final ArrayList
autocmd FileType java inoremap <buffer> <leader>jpsfl <Esc>:call <SID>ConListCon(1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsfl <Esc>:call <SID>ConListCon(2)<Cr>

" java method
autocmd FileType java inoremap <buffer> <leader>jpm <Esc>:call <SID>MethodCon(1, 0)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPm <Esc>:call <SID>MethodCon(2, 0)<Cr>
autocmd FileType java inoremap <buffer> <leader>jpsm <Esc>:call <SID>MethodCon(1, 1)<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsm <Esc>:call <SID>MethodCon(2, 1)<Cr>

" for loops
autocmd FileType java inoremap <buffer> jfor <Esc>:call <SID>ForBasic()<Cr>
autocmd FileType java inoremap <buffer> Jfor <Esc>:call <SID>ForAdvanced()<Cr>
autocmd FileType java inoremap <buffer> jFOR <Esc>:call <SID>ForComplete()<Cr>

" while loops
autocmd FileType java inoremap <buffer> jwhile <Esc>:call <SID>WhileBasic()<Cr>
autocmd FileType java inoremap <buffer> Jwhile <Esc>:call <SID>WhileAdvanced()<Cr>

" do while loops
autocmd FileType java inoremap <buffer> jdo <Esc>:call <SID>DoWhileBasic()<Cr>
autocmd FileType java inoremap <buffer> Jdo <Esc>:call <SID>DoWhileAdvanced()<Cr>

" for each loop
autocmd FileType java inoremap <buffer> jeach <Esc>:call <SID>ForEach()<Cr>

" if blocks
autocmd FileType java inoremap <buffer> jif <Esc>:call <SID>IfBlock()<Cr>
autocmd FileType java inoremap <buffer> jelif <Esc>:call <SID>ElseIfBlock()<Cr>
autocmd FileType java inoremap <buffer> jelse <Esc>:call <SID>ElseBlock()<Cr>

" if oneliners
autocmd FileType java inoremap <buffer> Jif <Esc>:call <SID>IfOneline()<Cr>
autocmd FileType java inoremap <buffer> Jelif <Esc>:call <SID>ElseIfOneline()<Cr>
autocmd FileType java inoremap <buffer> Jelse <Esc>:call <SID>ElseOneline()<Cr>

" switch statement
" ...

" javadocs
autocmd FileType java nnoremap <buffer> <leader>jdoc :call Jdoc()<Cr>


" IMPL
" ====



" Constructors
" ============

" Constant Constructor
func! s:ConCon(visibility)
	call s:Visibility(a:visibility)
	call AddString('static final')

	" call with no visibility, cause already handled
	call s:ObjCon(0, 0)
endfunc

" Constant Array Constructor
func! s:ConArrCon(visibility)
	call s:Visibility(a:visibility)
	call AddString('static final')

	" call with no visibility, cause already handled
	call s:ArrCon(0, 0)
endfunc

" Object Constructor
func! s:ObjCon(visibility, upper)
	call s:Visibility(a:visibility)
	call s:ObjConCon('', '()', a:upper)
endfunc

" Array Constructor
func! s:ArrCon(visibility, upper)
	call s:Visibility(a:visibility)
	call s:ObjConCon('[]', '[]', a:upper)
endfunc

" ArrayList Constructor
func! s:ListCon(visibility, upper)
	call s:Visibility(a:visibility)
	call s:ArrListCon(a:upper)
endfunc



" Literals
" ========

" Constant Literal
func! s:ConLit(visibility)
	call s:Visibility(a:visibility)
	call AddString('static final')

	" call with no visibility, cause already handled
	call s:ObjLit(0, 0)
endfunc

" Constant Array Literal
func! s:ConArrLit(visibility)
	call s:Visibility(a:visibility)
	call AddString('static final')

	" call with no visibility, cause already handled
	call s:ArrLit(0, 0)
endfunc

" ArrayList Constructor
func! s:ConListCon(visibility)
	call s:Visibility(a:visibility)
	call AddString('static final')

	" call with no visibility, cause already handled
	call s:ListCon(0, 0)
endfunc

" Object Literal
func! s:ObjLit(visibility, upper)
	call s:Visibility(a:visibility)
	call s:ObjLitCon('', '', a:upper)
endfunc

" Array Literal, leaves you on the '}' of the right hand value
func! s:ArrLit(visibility, upper)
	call s:Visibility(a:visibility)
	call s:ObjLitCon('[]', '{}', a:upper, 1)
endfunc


" Actual Maker Functions
" ======================

" Object Constructor Constructor
" to construct object vars with constructor calls and arrays with array-constructor calls
func! s:ObjConCon(name_suffix, arg_surround, upper)

	let type = s:GetType()
	let name = s:GetName(a:upper)

	let string = type.' '.name.a:name_suffix.' = new '.type.a:arg_surround.';'

	" There's an example of how the concat above works in objLitCon's
	" definition.
	" The arg_surround and suffix vars are for things like
	" '[]' and the parens around constructors, so you can create both
	" arrays and objects with just one function.

	call AddString(string)

	" move the cursor to where the user wants to enter stuff and start
	" inserting
	norm! $h
	startinsert

endfunc

" Object Literal Constructor
" to construct object and array literals
" Takes optional argument: startinsert offset from eol
func! s:ObjLitCon(name_suffix, arg_surround, upper, ...)

	let type = s:GetType()
	let name = s:GetName(a:upper)

	let string = type.' '.name.a:name_suffix.' = '.a:arg_surround.';'

	" The arg_surround and suffix vars are for things like
	" '[]' and the parens around constructors, so you can create both
	" arrays and objects with just one function.
	"
	" EG (you fill in the concatenator-variables to construct stuff like this):
	" String name[] = {};
	" int number = ;
	"
	" TYPE   NAME   SUFFIX = SURROUND;
	" String name     []   =   {}    ;
	" int    number        =         ;

	call AddString(string)

	" put the cursor, were it belongs and start inserting
	norm! $

	" if there is an offset to move, do just that
	if a:0 > 0
		exec "norm! ".a:1."h"
	endif

	startinsert

endfunc

" ArrayList constructor
" checks if the import for array list exists and prompts you to add it, if it
" doesn't
func! s:ArrListCon(upper)

	" check for arraylist import

	" save where the cursor is
	let oldPos = getpos('.')
	call cursor(1, 1)

	" try to find the import
	let import = search('import java.util.ArrayList;')

	" if the import couldn't be found...
	if import == 0
		" ... prompt the user to import!
		let i = input("ArrayList hasn't been imported.\nDo you wish to import? Y/n: ")

		" if the user wishes to import
		if i == 'Y' || i == 'y' || i == ''
			" ... add the import statement
			call append(1, ['', 'import java.util.ArrayList;'])

			" add 2 lines to the old cursor position, cause it has
			" to be shifted now... (unless it was right at the
			" top, but I'm not gonna test for that)
			let oldPos[1] += 2
		endif
	endif

	" put the cursor back where it belongs
	call setpos('.', oldPos)

	let type = s:GetTypeGeneric()
	let name = s:GetName(a:upper)

	let string = 'ArrayList<'.type.'> '.name.' = new ArrayList<'.type.'>();'

	call AddString(string)

	" move the cursor to the end of the new line
	norm! $
endfunc

" Method Constructor
" to construct method signatures and code blocks
func! s:MethodCon(visibility, static)

	let type = s:GetType('void')
	let name = s:GetName(1)
	let args = s:GetArgs("Enter the method's arguments: ")

	let signature = type.' '.name.'('.args.')'

	" add optional keywords
	call s:Visibility(a:visibility)
	call s:MethodStatic(a:static)

	" add method signature and code block
	call AddString(signature)
	call AddBlock()

	" EG for keywords and signatures:
	"
	" VISIBILITY STATIC TYPE    NAME  ( ARGUMENTS  )
	" public     static  int AddString(int a, int b)
	" private           void sayQuack (            )

	" move to the middle line of the code block
	norm! 2j

	startinsert! " the ! makes it behave like A

endfunc



" Control Flow Makers
" ===================

" for loop with most things filled in
func! s:ForBasic()

	let cnt = input('Name of Counter: ')
	let ref = input('Name of Reference: ')

	if cnt == ''
		let cnt = 'i'
	endif

	if ref == ''
		let ref = 'REF'
	endif

	call s:ForCon('int '.cnt.' = 0', cnt.' < '.ref, cnt.'++')

endfunc

" more flexible for loop
" name of counter can't be 'name'
func! s:ForAdvanced()

	" get type and name of counter variable
	let cnt_type = s:GetType('', 'Enter counter type: ')

	let cnt_name = s:GetName(1, 'Enter counter name: ')

	" handle default
	if cnt_name == 'name'
		let cnt_name = 'i'
	endif


	" get start value of counter variable
	let startval = input('Enter counter start value: ')

	" get comparison expression (with reference variable/value)
	let cmp = input('Enter comparison: ', cnt_name.' <')


	" get update expression
	let updt = input('Enter update expression (default is +1): ', cnt_name)

	" if nothing was entered...
	if updt == cnt_name

		" ... if the type's an integer
		if cnt_type == 'int' || cnt_type == 'char' || cnt_type == 'short'

			" ...use default operation post-increment
			let updt = cnt_name.'++'

			"... otherwise use the float-safe operation
		else
			let updt = cnt_name.' += 1'
		endif

	endif

	call s:ForCon(cnt_type.' '.cnt_name.' = '.startval, cmp, updt)

endfunc

" completely custom for loop
func! s:ForComplete()

	let expr1 = input('Enter expression 1: ')
	let expr2 = input('Enter expression 2: ')
	let expr3 = input('Enter expression 3: ')

	call s:ForCon(expr1, expr2, expr3)

endfunc

" for constructor
func! s:ForCon(expr1, expr2, expr3)

	let str = 'for ('.a:expr1.'; '.a:expr2.'; '.a:expr3.')'

	call AddString(str)
	call AddBlock()

	" put the cursor in the code block
	norm! 2j

	startinsert!

endfunc

" for each, also called enhanced for loop
" name of element can't be 'name'
func! s:ForEach()

	" get element variable
	let el_type = s:GetType('', 'Enter type for element: ')
	let el_name = s:GetName(1, 'Enter name for element: ')

	" default
	if el_name == 'name'
		let el_name = 'elem'
	endif

	let el = el_type.' '.el_name


	" get collection
	let coll = input('Name of Collection: ')

	" default
	if coll == ''
		let coll = 'REF'
	endif


	let str = 'for ('.el.' : '.coll.')'

	call AddString(str)
	call AddBlock()

	" put the cursor in the code block
	norm! 2j

	startinsert!

endfunc

" while signature, creates just the 'while(expr)' part
func! s:WhileSignature(exp)

	let str = 'while ('.a:exp.')'

	call AddString(str)

endfunc

" basic while loop, presupposes a counter akin to a for loop
func! s:WhileBasic()

	" get counter var
	let cnt = input('Enter name of counter: ')

	if cnt == ''
		let cnt = 'i'
	endif

	" get comparison expression (with reference variable/value)
	let cmp = input('Enter comparison: ', cnt.' <')

	" default
	if cmp == cnt.' <'
		let cmp = cmp.' REF'
	endif

	call s:WhileSignature(cmp)
	call AddBlock()

	" get update operation
	let updt = input('Enter update operation: ', cnt)

	if updt == cnt
		let updt = cnt.'++;'
	endif

	" if the user forgot the ; at the line's end, add it
	if updt[len(updt)-1] != ';'
		let updt = updt.';'
	endif

	" add update operation
	norm! 2j
	call AddLines(['N;', '', updt])
	norm! 2x

	" I have to use N; here or Format will insert updt too far.

	startinsert!

endfunc

" advanced while loop for complete customizability
func! s:WhileAdvanced()

	" get signature expression
	let expr = input('Enter while expression: ')

	call s:WhileSignature(expr)
	call AddBlock()

	" get update operation
	let updt = input('Enter update operation (optional): ')

	" reposition for insert mode
	norm! 2j

	" if an update op has been provided
	if updt != ''

		" if the user forgot the ; at the line's end, add it
		if updt[len(updt)-1] != ';'
			let updt = updt.';'
		endif

		" add update operation
		call AddLines(['N;', '', updt])
		norm! 2x

	endif

	" if no expression was provided startinsert in the parens
	if expr == ''
		norm! 2k
		norm! $F)
		startinsert
	else
		startinsert!
	endif

endfunc

" same as s:WhileBasic just do while form
func! s:DoWhileBasic()

	" get counter var
	let cnt = input('Enter name of counter: ')

	if cnt == ''
		let cnt = 'i'
	endif

	" get comparison expression (with reference variable/value)
	let cmp = input('Enter comparison: ', cnt.' <')

	" default
	if cmp == cnt.' <'
		let cmp = cmp.' REF'
	endif


	call AddString('do')
	call AddBlock()

	" get update operation
	let updt = input('Enter update operation: ', cnt)

	if updt == cnt
		let updt = cnt.'++;'
	endif

	" if the user forgot the ; at the line's end, add it
	if updt[len(updt)-1] != ';'
		let updt = updt.';'
	endif

	" add update operation
	norm! 2j
	call AddLines(['N;', '', updt])
	norm! 2x

	" add the while signature
	norm! 4j
	call s:WhileSignature(cmp)

	" add missing semicolon and remove the space from joining the lines in
	" addstring
	call AddString(';')
	norm! $hx

	" move back up
	norm! 4k

	startinsert!

endfunc

" same as s:WhileAdvanced just do while form
func! s:DoWhileAdvanced()

	" get signature expression
	let expr = input('Enter while expression: ')

	call AddString('do')
	call AddBlock()

	" move to '}' line and add signature
	norm! 4j
	call s:WhileSignature(expr)

	" add missing semicolon and remove the space from joining the lines in
	" addstring
	call AddString(';')
	norm! $hx

	" move to middle of block
	norm! 2k

	" get update operation
	let updt = input('Enter update operation (optional): ')

	" if an update op has been provided
	if updt != ''

		" if the user forgot the ; at the line's end, add it
		if updt[len(updt)-1] != ';'
			let updt = updt.';'
		endif

		" add update operation
		call AddLines(['N;', '', updt])
		norm! 2x

	endif

	" if no expression has been provided, move into the parens to start insert
	if expr == ''
		" move down to while signature line,
		" depends on how many lines are in the block
		if updt == ''
			norm! 2j
		else
			norm! 4j
		endif

		norm! $F)
		startinsert
	else
		startinsert!
	endif

endfunc

" make an if block
"
" if you don't provide an expression, you start insert mode within the parens
" of the if statement
func! s:IfBlock()

	let expr = input('Enter condition expression: ')

	let str = 'if ('.expr.')'

	call AddString(str)
	call AddBlock()

	" if an expression was provided...
	if expr != ''
		" ... move into the block
		norm! 2j
		startinsert!
	else
		" ... else move into the () for the expr
		norm! $F)
		startinsert
	endif

endfunc

" else if block
func! s:ElseIfBlock()

	call AddString('else')

	call s:IfBlock()

endfunc

" else block
func! s:ElseBlock()

	call AddString('else')

	call AddBlock()

	norm! 2j
	startinsert!

endfunc

" if oneline
func! s:IfOneline()

	let expr = input('Enter expression (oneline): ')

	let str = 'if ('.expr.') ;'

	call AddString(str)

	" if an expression was provided
	if expr != ''
		norm! $
		startinsert

		" if it wasn't
	else
		norm! $F)
		startinsert
	endif

endfunc

" else if oneline
func! s:ElseIfOneline()

	call AddString('else')

	call s:IfOneline()

endfunc

" else oneline
func! s:ElseOneline()

	call AddString('else ;')

	norm! $
	startinsert

endfunc


" switch



" JavaDoc Maker
" =============

" General Regex patterns

" In jdoc-prompts you can use '\ ' or '\n' to denote a line-break
let s:r_newlinePattern = '\(\\ \)\|\(\\n\)'

let s:r_word = '\w\+'
let s:r_arrayBrackets   = '\(\s*\[\]\)\?'
let s:r_genericBrackets = '\(\s*<[^>]>)\='
let s:r_type = '\u\w*\(\s*<[^>]>\)\?\(\s*\[\]\)\?'		" the '<...>' of generics or array-denoting '[]' could be after the type...
let s:r_name = s:r_word.s:r_arrayBrackets

" Patterns to identify the line types with
let s:r_classKeywordPattern = '\(interface\|class\|enum\)'
let s:r_classExtendsPattern = '\s\+\(extends\s\+'.s:r_word.'\)\='
let s:r_constKeywordPattern = 'static\s\+final'
let s:r_excepKeywordPattern = '\s*throw\s\+\(new\s\+\)\='


" The pattern for methods is a bit more complicated
let s:whitespace_required = '\s\+'

" match any of the possible keywords or a word starting upper case, possibly followed by <.*> and []
let s:method_type	  = '\(public\|void\|short\|int\|char\|double\|float\|boolean\|long\|byte\|\u\w*\(\s*<[^>]>\)\?\(\s*\[\]\)\?\)'
let s:method_name	  = '\w\+'
let s:method_keywords	  = '\(void\|short\|int\|char\|double\|float\|boolean\|long\|byte\)'
let s:method_r_type	  = '\(void\|short\|int\|char\|double\|float\|boolean\|long\|byte\|\u\w*\(\s*<[^>]>\)\?\(\s*\[\]\)\?\)'

" match a type, followed by a name, followed by parenthesis, which do not
" contain parenthesis
let s:r_methodPattern = s:method_type.'\s\+'.s:method_name.'\s*'.'('.'[^()]*'.')'

" Creates JavaDocs for whatever thing the cursor is on, provided the cursor is
" on one of the following:
"   - a method declaration
"   - a class or interface declaration
"   - a static final
"
" note: this function assumes, that you put the '{' one the same line as eg the method signature and not below!
func! Jdoc()

	" Check, if the currently active line is commented-out and refuse to work
	if match([getline(line('.'))], '^\s*\(\(//\)\|\(/\*\)\)') == 0
		" regex checks for '//' and '/*' at the beginning of the line, only preceded by whitespace
		echo 'Line '.line('.')." is commented-out. Can't create JavaDoc!"
		return
	endif

	" Check for existing jdocs and given such prompt for override
	if match([getline(line('.')-1)], '\(/\*\*\)\|\(\*/\)') == 0
		" regex checks for '/**' and '*/' anywhere in the line
		let i = input('The preceeding line may be a JavaDoc. Do you wish to insert below (Y/n)? ')

		if i == 'n'
			return
		endif

		" Let's not have the above prompt's message fill up my
		" echo-space, eh?
		redraw
	endif


	" Figure out, what type of line the cursor's on
	let lineType = JdocLineType()

	" Now call the appropriate generator function
	" 0 = class or interface signature
	if lineType == 0

		let str = JdocGenClass()

	" 1 = static final constant
	elseif lineType == 1

		let str = JdocGenConst()

	" 2 = method definition
	elseif lineType == 2

		let str = JdocGenMethod()

	" -1 = none of the above
	elseif lineType == -1

		return

	endif

	call JdocAddComment(str)

endfunc

" If the line above line_number contains Jdocs, this function returns 1, else 0
func! JdocExists(line_number)

	" Get the line above the current line...
	let line = getline(a:line_number-1)

	" ... and check it for javadocs
	" regex: either the beginning of a jdoc, or whitespace followed by an asterisk followed by anything, which is the middle of a comment, or match against '*/', which is a comment's end...
	if match([line], '/\*\*') == 0 || match([line], '^\s*\*.*') == 0 || match([line], '.*\*/') == 0 || match([line], '@Override') == 0
		return 1
	endif

	" If there's no javadoc
	return 0

endfunc

" Figures out, which of the jdoc-able line-types the current line is.
"
" returns -1	on a commented line
" returns  0	on a class or interface declaration
" returns  1	on a static final (the only one-liner statement, that gets commentary)
" returns  2	on a method signature
func! JdocLineType()

	let line = getline(line('.'))

	" The regex patterns to check against
	let pattClass  = s:r_classKeywordPattern
	let pattConst  = s:r_constKeywordPattern
	let pattMethod = s:r_methodPattern

	" Note, that the pattMethod also matches constructors, clever, eh?

	" Match against the various possible patterns
	if match([line], pattClass) == 0
		return 0
	elseif match([line], pattConst) == 0
		return 1
	elseif match([line], pattMethod) == 0
		return 2
	endif

	echo "This is not a jdoc-able line."

	return -1

endfunc


" Removes a list of keywords from the provided line
func! JdocRemoveKeywords(line, list)

	let line = a:line
	let list = a:list

	for keyword in list
		let line = substitute(line, keyword, '', '')
	endfor

	return trim(line)

endfunc

" Generates Jdocs for a class, enum or interface declaration.
"
" The function returns a list of lines, that can be added to the file with
" AddLines()
func! JdocGenClass()

	" Get data

	let line = getline('.')

	let rName = s:r_type
	let newlinePattern = s:r_newlinePattern

	let keywordPattern = s:r_classKeywordPattern
	let extendsPattern = s:r_classExtendsPattern


	let line = JdocRemoveKeywords(line, ['public', 'private', 'protected', 'class', 'enum', 'interface'])
	" name {
	" name extends something {
	" name<T> {
	" name<T> extends something{


	" Get the first word of the line
	let name     = substitute(line, '^\(\w\+\).*', '\1', '')

	" Get what might be in between '<>' after the first word of the line
	let generics = substitute(line, '.*\(<.*>\).*', '\1', '')
	if generics == line	" If you didn't find any generics
		let generics = ''
	endif


	" Figure out Generics
	" -------------------

	" Get rid of any spaces among the parameters
	let genericParameters = substitute(trim(generics), ' ', '', '')

	" Separate into just parameters
	let genericParameters = split(genericParameters, ',')


	" Let's make a token dictionairy, shall we?
	" And then let's prompt, eh?
	" -----------------------------------------

	let substDict = { '%n': name, '%{': '{@code' }

	" Dynamic Generic Type Parameter Tokens
	for i in range(len(genericParameters))
		let substDict['%p'.i] = genericParameters[i]
	endfor

	" Prompt with name, type params and if there is, also the superclass
	let promptLine  = name.generics.substitute(line, '.*\(\s\+extends\s\+\w\+\)\s*{', '\1', '')
	let promptLine  = trim(promptLine)

	let tokenString = '   %n: '.name

	" Add the dynamic tokens for Generic Type Parameters
	for i in range(len(genericParameters))
		let tokenString = tokenString.', %p'.i.': '.genericParameters[i]
	endfor


	" And now, let's actually let the magic happen
	" ============================================

	" Helping Output
	echo promptLine
	echo tokenString


	" Handle description prompt

	" Prompt for the description
	let desc = JdocInput('', name)

	" Possibly multiple lines...
	let desc = split(desc, newlinePattern)

	" Substitute tokens
	let desc = JdocSubstituteTokens(desc, substDict)

	" Add period if missing
	let desc[0] = JdocCapitalAndPeriod(desc[0])


	" Possibly prompt for generic types

	let genericParamsTags = []
	let genericParamsDesc = []

	if len(genericParameters) > 0

		" Get arguments descriptions and argument tags
		for i in range(len(genericParameters))
			let genericParamsTags = genericParamsTags + ['@param '.genericParameters[i]]
			let genericParamsDesc = genericParamsDesc + [JdocInput(genericParamsTags[i].' ', 'A value for '.genericParameters[i])]
		endfor

	endif


	" Create the final comment
	" ------------------------

	let lenDesc = len(desc)
	let lenGen  = len(genericParameters)

	" If there are multiple description lines or at least one generic
	" parameter it must be a multi-line comment...
	if lenDesc > 1 || lenGen > 0

		" ... start making a comment...
		let comment = ['/**']

		" ... add all the lines of the description...
		for line in desc
			let comment = comment + [' * '.line]
		endfor

		" ... add the possibly existing generic parameter tags
		let comment = comment + JdocBuildTagsDescs(genericParamsTags, genericParamsDesc)

		" ... and add a comment-closer
		let comment = comment + [' */']


	" ... It's a single-line comment if there's only one line to add...
	elseif lenDesc == 1 && lenGen == 0
		" ... so make a single-line javadoc!
		let comment = ['/** '.desc[0].' */']
	endif

	" Don't forget to substitute!
	let comment = JdocSubstituteTokens(comment, substDict)

	return comment

endfunc

" Generates Jdocs for a static final
"
" The function returns a list of lines, that can be added to the file with
" AddLines()
"
" This one is getting a bit long, even with some repeated code... But since
" I'm not going to repeat any of this stuff exactly anywhere else, I'm going
" to leave it all inline - in proper procedural manner =)
func! JdocGenMethod()

	" ============================================================================
	" GET DATA AND SETUP

	let oldPos = getpos('.')
	let line = trim(getline(line('.')))

	" \n and \  are allowed for newline
	let newlinePattern = s:r_newlinePattern

	let rWord = s:r_word
	let rType = s:method_r_type
	let rKeys = s:method_keywords
	let rName = s:r_name
	let rExcPattern = s:r_excepKeywordPattern

	let exceptPattern = rExcPattern.rWord
	" Regex: match against...
	"   at least some whitespace
	"   'throw'
	"   more whitespace
	"   possibly 'new' followed by whitespace
	"   a word -> that's the name of the exception


	" Get type and name of the method
	" -------------------------------


	let line = JdocRemoveKeywords(line, ['public', 'private', 'protected', 'static'])

	" Check for constructor
	if match([line], '\w\+\s*(') == 0

		" The method is a constructor if after removing 'public' from
		"   public name() {
		" there's only left one word and the parens:
		"   name() {

		let name = substitute(line, '\(\w\+\)\s*(.*', '\1', '')

		" Constructor doesn't get return tag
		let addReturnTag = v:false

	else

		" After JdocRemoveKeywords the first word in the line is the
		" type, so no .* in the front

		let type = substitute(line, '\('.rType.'\).*', '\1', '')

		" The type might have Generics, so get what might be surrounded by '<>'
		let generics = substitute(type, '[^<]*\(<[^>]*>\).*', '\1', '')

		" There might not be any Generics
		if type == generics
			let generics = ''
		endif

		" The type might also be an array...
		let array = substitute(type, '[^\[]*\[\].*', '\[\]', '')
		if array == type
			let array = ''
		endif

		" Whether or not to prompt for and add a return tag
		if type == 'void'
			let addReturnTag = v:false
		else
			let addReturnTag = v:true
		endif

		" Get the word after the type
		let name = substitute(line, rType.'\s\+\(\w\+\).*', '\4', '')	" I know, rType contains capture groups and that results in \4 here, which ain't nice...
		let name = trim(name)

	endif

	" Get parameters to the method
	" ----------------------------

	let params = substitute(line, '[^(]*(\([^()]*\)).*', '\1', '')			" get everything that's in between '(' and ')'
	let params = split(params, ',')							" split into just the arguments
	let params = map(params, 'trim(v:val)')						" get rid of whitespace
	let params = map(params, 'substitute(v:val, "^.* ", "", "")')			" get rid of the type annotations


	" Get Exceptions, that might be thrown
	" ------------------------------------

	" Note: This will return anything that uses the word 'throw' and isn't
	" in a style-guide conform comment

	" Til where should you search for exceptions?
	let methodEnd = JdocFindMethodEndLine()

	let excepts = []

	" Try to find a first exception in the method
	let exceptMatch = search(exceptPattern, 'W', methodEnd)

	" If there was an exception found...
	while exceptMatch != 0

		" ... add it to the list of exceptions!

		" Get the line with the exception
		let e = getline(line('.'))

		" Make sure the line isn't commented out
		if match([e], '\(//.*throw\)\|\(^\s*\*.*throw\)\|\(/\*.*throw\)') != 0
		" Regex: match any of the following...
		"   // .* throw		single-line comment before 'throw' somewhere
		" ^  * .* throw		a star is the first char in the line -> by notation convention multi-line comment
		"   /* .* throw		beginning of multi-line comment somewhere before the 'throw'

			" Get just the exception's name
			let e = substitute(e, '^'.rExcPattern.'\(\w\+\)', '\2', '')
			" Regex: match against...
			"   anything, til you find
			"   'throw'
			"   some whitespace
			"   possibly 'new' and whitespace
			"   the name of the exception
			" and subst for:
			"   the name of the exception

			" Get rid of possible semi-colons and parens from
			" constructors...
			let e = substitute(e, ';', '', '')
			let e = substitute(e, '(.*).*', '', '')

			" Add found exception to the excepts
			let excepts = excepts + [e]

		endif

		" Then continue searching!
		let exceptMatch = search(exceptPattern, 'W', methodEnd)

	endwhile

	" Go back to original position (the search() moves the cursor)
	call setpos('.', oldPos)


	" ============================================================================
	" SETUP DATA STRUCTURES


	" Create the Token Dictionairy
	" ----------------------------

	" Standard tokens
	let substDict = { '%n': name, '%t': type, '%r': '@return', '%x': '@throws', '%{': '{@code' }

	" Dynamic parameter tokens
	for i in range(len(params))
		let substDict['%p'.i] = params[i]
	endfor

	" Dynamic exceptions tokens
	for i in range(len(excepts))
		let substDict['%e'.i] = excepts[i]
	endfor


	" Create the dynamic Token-Help-String
	" ------------------------------------

	let tokenString = '   %n: '.name

	" Add the return type, if it exists
	if addReturnTag
		let tokenString = tokenString.', %t: '.type
	endif

	" Add the dynamic tokens for parameters
	for i in range(len(params))
		let tokenString = tokenString.', %p'.i.': '.params[i]
	endfor

	" Add the dynamic tokens for exceptions
	for i in range(len(excepts))
		let tokenString = tokenString.', %e'.i.': '.excepts[i]
	endfor


	" ============================================================================
	" PROMPTING

	" Output the help for the user
	echo line
	echo tokenString

	" Get description
	let desc = JdocInput('', name)


	" @-Override
	" ----------

	" If the first thing, that was entered is just an '@', this should
	" just add the '@Override' thingy
	if desc == '@'

		" If the override is added, nothing else needs to be added
		return ['@Override']

	endif


	" Otherwise: Regular Pompting
	" ---------------------------

	" Get arguments descriptions and argument tags
	let paramsTags = []
	let paramsDesc = []
	for i in range(len(params))
		let paramsTags = paramsTags + ['@param '.params[i]]
		let paramsDesc = paramsDesc + [JdocInput(paramsTags[i].' ', 'A value for '.params[i])]
	endfor

	" Get exceptions descriptions and exceptions tags
	let exceptTags = []
	let exceptDesc = []
	for i in range(len(excepts))
		let exceptTags = exceptTags + ['@throws '.excepts[i]]
		let exceptDesc = exceptDesc + [JdocInput(exceptTags[i].' ', 'This method might throw a '.excepts[i])]
	endfor

	" Get return description and return tag
	let typeTag  = ''
	let typeDesc = ''
	if addReturnTag
		let typeTag  = '@return '
		let typeDesc = JdocInput('@return ', 'The method returns a value of type '.type)
	endif


	" ============================================================================
	" FORMATTING, COMPOSITION AND NEWLINES

	" Tag Indentation
	" ---------------
	"
	" Note: this is mostly handled by the function JdocComputeIndent() now...
	"
	" The bit, where I want the tags to all be aligned like this:
	"
	"   * @param honk       	a honk
	"   * @param honkers    	a bonk
	"   * @param honkbonkers	a stonk
	"   * @return           	what you get is honk bonk stonk
	"
	" How this works:
	"                      â
	"   * @param honk      |	a honk
	"   * @param honkers   |	a bonk
	"   * @param honkbonkers	a stonk
	"   * @return          |	what you get is honk bonk stonk
	"                      â
	"
	" I compute the number of chars up to the marked position,
	" then I add spaces to the @-tags until they all match up
	" in length, so that I just need to add a tab-char and the
	" description afterwards.
	"
	" I also create a string of just spaces the length of how
	" long each tag should be. I use that to indent in case of
	" line-breaks in descriptions.
	"
	" The Exceptions Tags only figure into this, if there are
	" no return and no parameter tags, because of their length.
	" Naming in Java is a bit cumbersome at times...
	"
	" Note: this code could be optimized a lot. But this is a lot more
	" readable, and more importantly, extendable


	" Compute, how many chars long all tags should be
	" -----------------------------------------------


	" Find the longest argument tag
	let longestTagLength = JdocComputeIndent(paramsTags)

	" Check, if the return tag would be longer.
	if addReturnTag
		let n = len(typeTag)
		if n > longestTagLength
			let longestTagLength = n
		endif
	endif

	" Find longest possible exceptions tag and adjust accordingly, but
	" only if there are only exceptions tags to be added. Exception names
	" are really long and unwieldy, I want this stuff to remain
	" readable...
	if longestTagLength == 0
		let longestTagLength = JdocComputeIndent(exceptTags)
	endif



	" MAKE THE ACTUAL COMMENT
	" =======================

	" A javadoc comment starts with '/**'
	let comment = ['/**']


	" Description lines
	let desc = split(desc, newlinePattern)

	" Add a period to the end of the first line, if it hasn't gotten one.
	let desc[0] = JdocCapitalAndPeriod(desc[0])

	" Add description lines to the comment
	for line in desc
		let comment = comment + [' * '.line]
	endfor


	" Parameter Lines
	let comment = comment + JdocBuildTagsDescs(paramsTags, paramsDesc, longestTagLength)

	" Parameter Lines
	let comment = comment + JdocBuildTagsDescs(exceptTags, exceptDesc, longestTagLength)

	" Optionally also add the return tag...
	if addReturnTag

		" Add an empty line
		let comment = comment + [' *']

		" Add the return tag
		let comment = comment + JdocCombineTagDescription(typeTag, typeDesc, longestTagLength)
	endif


	" End the comment.
	let comment = comment + [' */']


	" ============================================================================
	" SUBSTITUTE THE TOKENS

	let comment = JdocSubstituteTokens(comment, substDict)


	" ==============
	" AND FINALLY...

	return comment

endfunc

" Generates Jdocs for a static final
"
" The function returns a list of lines, that can be added to the file with
" AddLines()
func! JdocGenConst()

	" Get data
	let line = getline('.')
	let newlinePattern = s:r_newlinePattern

	" Get the regex types
	let rStatFinal = s:r_constKeywordPattern
	let rType = s:r_type
	let rName = s:r_name

	let line = JdocRemoveKeywords(line, ['private', 'public', 'protected', 'static', 'final'])
	let line = trim(substitute(line, '\(.*\)=.*', '\1', ''))	" get rid of the actual defintion

	" Let's make a token dictionairy, shall we?

	" Get the first word of the line
	let type = substitute(line, '^\(\w\+\).*', '\1', '')

	" The type might have Generics, so get what might be surrounded by '<>'
	let generics = substitute(line, '.*\(<.*>\).*', '\1', '')
	if generics == line
		let generics = ''
	endif

	" The type might also be an array...
	" Note: the [] might be after the name of the const, but they are part
	" of the type, in my opinion
	let array = substitute(line, '.*[].*', '[]', '')
	if array == line
		let array = ''
	endif

	let type = type.generics.array

	" Get the last word of line, there might be '[]' after it
	let name = substitute(line, '.*\s\+\(\w\+\)\(\s*[]\)\=$', '\1', '')

	" Make a substitution dictionairy
	let substDict = { '%n': name, '%t': type, '%{': '{@code' }


	" Helper string, that's shorter than the whole 'private static final Integer yadda yadda yadda'
	let promptLine  = type.' '.name
	let tokenString = '   %n: '.name.', %t: '.type


	" Helping Output
	echo promptLine
	echo tokenString

	" Prompt for the description
	let desc = JdocInput('', name)

	" Possibly multiple lines...
	let desc = split(desc, newlinePattern)

	" Substitute tokens
	let desc = JdocSubstituteTokens(desc, substDict)

	" Add period if missing
	let desc[0] = JdocCapitalAndPeriod(desc[0])


	" Create the final comment

	" If the comment is a multiline...
	if len(desc) > 1

		" ... start making a comment...
		let comment = ['/**']

		" ... add all the lines...
		for line in desc
			let comment = comment + [' * '.line]
		endfor

		" ... and add a comment-closer
		let comment = comment + [' */']


	" ... Else it must be a single line...
	else
		" ... so make a single line javadoc!
		let comment = ['/** '.desc[0].' */']
	endif

	return comment

endfunc

" Makes the jdoc lines, that start with a tag.
"
" Returns a list of properly formatted jdoc lines for all the
" tags and their descriptions.
"
" Takes a list of tags like '@param name' and a list of
" corresponding descriptions. The description for a tag in the
" descs list should be at the same index as the tag is in the
" tags list.
"
" Optionally you can provide an override for the number of
" indentation spaces (eg for the indents on exceptions), otherwise
" the longest tag is used as the base for the indentation
func! JdocBuildTagsDescs(tags, descs, ...)

	" This is more convenient:
	let descs = a:descs
	let tags  = a:tags

	" If an indent length was provided, use that
	if a:0 > 0
		let indent = a:1

	" Otherwise compute one
	else
		let indent = JdocComputeIndent(tags)
	endif

	let output = []
	for i in range(len(tags))

		" Add an empty line between tags
		let output = output + [' *']

		" Add the next tag
		let output = output + JdocCombineTagDescription(tags[i], descs[i], indent)

	endfor

	return output

endfunc

" Computes the number of characters, that should come before the tab in a
" jdoc-param line:
"
" Computes the number of characters from
"   here  to     here
"     â           â
"   * @param name  	description
"   * @param name2 	description
"   * @param name33	description
"     â           â
func! JdocComputeIndent(tags)

	let tags = a:tags

	let maxLength = 0

	for tag in tags
		let len = len(tag)
		if len > maxLength
			let maxLength = len
		endif
	endfor

	return maxLength

endfunc

" Combines a single tag with its description line or lines, if there are
" multiple description lines.
func! JdocCombineTagDescription(tag, desc, indent)

	let tag    = a:tag
	let indent = a:indent

	" Split the description into lines
	let newlinePattern = s:r_newlinePattern
	let desc = split(a:desc, newlinePattern)

	" Adjust indentation length of the tag
	while len(tag) < indent
		let tag = tag.' '
	endwhile


	" Add the line with the actual tag
	let output = [' * '.tag.'	'.desc[0]]

	" Now, if there are multiple lines in the description...
	if len(desc) > 1

		" Make indentation for the lines
		let indentSpaces = ''
		while len(indentSpaces) < indent
			let indentSpaces = indentSpaces.' '
		endwhile

		" Go through the lines of the description, but skip the first
		for i in range(1, len(desc)-1)

			" Add the lines
			let output = output + [' * '.indentSpaces.'	'.desc[i]]

		endfor

	endif

	return output

endfunc

" Uppercases the first letter of a string and adds a period to the end, if
" there is none.
"
" This is used to format the first line of any javadoc to fit expectations.
func! JdocCapitalAndPeriod(str)

	let str = a:str

	" Get just the first char, uppercase it
	let firstChar = toupper(str[0])

	" Get everything but the first char
	let str = str[1:len(str)]

	" Concatenate = uppercase the first char of a string
	let str = firstChar.str

	" Possibly add a period at the end
	if str[len(str)-1] != '.'
		let str = str.'.'
	endif

	return str

endfunc

" Returns the line on which the current method ends
func! JdocFindMethodEndLine()

	" Store cursor position
	let oldPos = getpos('.')

	" Find the opening { of the method's code block and jump to the closing partner
	norm! 0f{
	norm! %

	" Save, where the } is
	let newPos = getpos('.')

	" Go back to original position
	call setpos('.', oldPos)

	return newPos[1]

endfunc

" Prompts for input
"
" Takes a prompt string and a default return value for if there's no input
func! JdocInput(prompt, default)

	let in = input(' > '.a:prompt)

	if in == ''
		let in = a:default
	endif

	return in

endfunc

" Substitute the shorthand tokens in inputs from the prompt
"
" Takes a list of lines in the comment and a dictionairy of tokens and the
" value they should be substituted for.
func! JdocSubstituteTokens(comment, dictionairy)

	let comment = a:comment

	" In each line of the comment...
	for i in range(len(comment))

		" ... run the substitution for each token in the dictionairy
		for token in keys(a:dictionairy)
			let comment[i] = substitute(comment[i], token, a:dictionairy[token], 'g')
		endfor

	endfor

	return comment

endfunc

" Function that adds a list of javadoc-lines to current buffer, above the line
" the cursor's on.
func! JdocAddComment(comment)

	let oldPos = getpos('.')

	" Add a line above the method signature
	norm O

	" Add the comment
	call AddLines(a:comment)

	" Adjust the original cursor position to match the newly added lines
	let oldPos[1] += len(a:comment)

	" Move the cursor back to where it belongs
	call setpos('.', oldPos)

endfunc


" Simple Adders
" =============

" Set the visibility to private, public
" 1 sets to private
" 2 sets to public
func! s:Visibility(mode)
	if a:mode == 1
		call AddString('private')
	elseif a:mode == 2
		call AddString('public')
	endif
endfunc

" Adds the static keyword when flag is 1
func! s:MethodStatic(flag)
	if a:flag == 1
		call AddString('static')
	endif
endfunc


" Input Functions
" ===============


" Prompts for a type
"
" Takes an optional default value, that is used in place of the std default of
" int, if this is '' int is used as well
"
" Takes a prompt as second optional argument
"
" Returns type in upper camel case (java convention), but
" doesn't change any of the java primitives.
"
" Usage:
"  s:GetType()					use default type int and default prompt
"  s:GetType('defaultType')			use defaultType instead of int, and default prompt
"  s:GetType('defaultType', 'Enter sth: ')	use defaultType and use 'Enter sth: ' instead of default prompt
"  s:GetType('', 'Enter sth: ')			use default type int and 'Enter sth: '
"
" Substitutes the following shorthands to primitives:
"   i	int
"   S	short
"   d	double
"   f	float
"   b	boolean
"   s	String (I know, this is no primitive!)
func! s:GetType(...)

	" primitives and a lookup table
	let primitives_shorthands = ['i',   'S',     'c',    'd',      'f',     'b',       'v',    's'     ]
	let primitives            = ['int', 'short', 'char', 'double', 'float', 'boolean', 'void', 'String']

	" optional default type
	if a:0 > 0
		if a:1 == ''
			let default = 'i'
		else
			let default = a:1
		endif

	else
		let default = 'i'
	endif

	" optional prompt
	if a:0 > 1
		let prompt = a:2
	else
		let prompt = 'Enter a type: '
	endif

	return s:GetTypeHelper(primitives, primitives_shorthands, default, prompt)

endfunc

" Prompts for a type that is to be placed in a generic field
"
" Takes an optional default value, that is used in place of the std default of
" int, if this is '' int is used as well
"
" Takes a prompt as second optional argument
"
" Returns type in upper camel case (java convention), and
" changes the java primitives to their wrapper class equivalents.
"
" Substitutes the following shorthands to primitive wrappers:
"   i	Integer
"   S	Short
"   d	Double
"   f	Float
"   b	Boolean
"   s	String (I know, this is no primitive!)
func! s:GetTypeGeneric(...)

	" primitives and a lookup table
	let primitives_shorthands = ['i',       'S',     'c',    'd',      'f',     'b',       's'     ]
	let primitives            = ['Integer', 'Short', 'char', 'Double', 'Float', 'Boolean', 'String']

	" note: void is no option for generics, only return types... I think.

	" optional default type
	if a:0 > 0
		if a:1 == ''
			let default = 'i'
		else
			let default = a:1
		endif

	else
		let default = 'i'
	endif

	" optional prompt
	if a:0 > 1
		let prompt = a:2
	else
		let prompt = 'Enter a type (Generic Mode): '
	endif

	return s:GetTypeHelper(primitives, primitives_shorthands, default, prompt)

endfunc

" Helper that actually does the type getting, formatting and shorthand substituting
func! s:GetTypeHelper(primitives, primitives_shorthands, default, prompt)

	let type = input(a:prompt)

	" default
	if type == ''
		let type = a:default
	endif

	" split into words
	let type = split(type)

	" if there's only one word and it's only one char long it might be a
	" primitive shorthand...
	if len(type[0]) == 1 && len(type) == 1

		" turn the list of one letter into just a letter
		let type = type[0]

		" get where in the shorthands the type is (if it is there)
		let i = index(a:primitives_shorthands, type)

		" if the type is indeed in the shorthands...
		if i >= 0
			" ... substitute it with the longhand...
			let type = a:primitives[i]
		else
			" ... else make the letter conform with upper camel
			let type = toupper(type)
		endif

	" else: if the type is longer than one word, or if it isn't in the list of valid primitives,
	" it's no primitive...
	elseif len(type) > 1 || index(a:primitives, type[0]) == -1
		" ... so make it fit upper camel case
		let type = ToUpperCamelCase(type)
	
	" else it must be a primitive spelled out in whole
	else
		" make sure type's a valid string (if you type out the primitives as
		" literals, it might not be)
		let type = join(type, '')
	endif

	return type

endfunc

" Prompts for a name
"
" mode 0 returns name in all caps snake case
" mode 1 in lower camel case
" mode 2 in upper camel case
"
" Optionally takes an alternate prompt to the default
func! s:GetName(mode, ...)

	" handle prompt
	if a:0 > 0
		let name = input(a:1)
	else
		let name = input('Enter a Name: ')
	endif


	" default
	if name == ''
		let name = 'name'
	endif

	" split into words
	let name = split(name)

	" format the words
	if a:mode == 0
		let name = ToAllCapsSnakeCase(name)
	elseif a:mode == 1
		let name = ToLowerCamelCase(name)
	elseif a:mode == 2
		let name = ToUpperCamelCase(name)
	else
		let name = join(name)
	endif

	return name

endfunc

" Prompts for arguments on method constructors
func! s:GetArgs(arg_prompt)

	let args = input(a:arg_prompt)

	" no default, cause if there are no args, then there are no args

	return args

endfunc

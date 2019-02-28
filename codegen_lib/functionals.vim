
" A tiny standard library of functional abstractions.
" These are the kinds of functions you might expect to find in a functional
" language's standard library.
" Most of these are implemented in terms of other functions in this file, the
" more basic ones are implemented imperatively. The reason for that is mostly,
" that vimscript doesn't support tail call optimization (obviously), so using
" recursion isn't really an efficient option and I tried to avoid it.
"
" I doubt these functions are particularly fast, but then I also doubt that
" that really matters. This is vimscript after all.


" takes values while the lambda returns true
" lambda(v) where v is the current element from the list
func! TakeWhile(lambda, list)
	let i = -1
	let l = len(a:list)-1

	while i < l && a:lambda(a:list[i+1])
		let i = i + 1
	endwhile

	if i < 0
		return []
	else
		return a:list[0:i]
	endif
endfunc

func! Take(n, list)
	if a:n < len(a:list)
		return a:list[0:(a:n -1)]
	else
		return a:list
	endif
endfunc

" drops values while the lambda returns true
" lambda(v) where v is the current element from the list
func! DropWhile(lambda, list)
	let i = 0
	let l = len(a:list)

	while i < l && a:lambda(a:list[i])

		let i = i + 1

	endwhile

	return a:list[i:]
endfunc

func! Drop(n, list)
	if a:n < len(a:list)
		return a:list[a:n:]
	else
		return []
	endif
endfunc

func! Head(list)
	if len(a:list) > 0
		return a:list[0]
	else
		return ''
	endif
endfunc

func! Tail(list)
	return Drop(1, a:list)
endfunc

" a and b are lists
func! Zip(list1, list2)
	let list1 = a:list1
	let list2 = a:list2

	let length = 0
	let list   = []

	" list is initialized to a copy of the shorter of the two lists,
	" so there will be enough space for all the pairs.
	" I think that's going to be more resource efficient, than building
	" up list using concatenation (cause there's no cons in vimscript)

	if len(list1) <= len(list2)
		let length = len(list1)
		let list   = list1[:]
	else
		let length = len(list2)
		let list   = list2[:]
	endif

	for i in range(length)
		let list[i] = [ list1[i], list2[i] ]
	endfor

	return list
endfunc

" a and b are lists
" lambda(m, n) where m and n are the elements of a and b at the same index
func! ZipWith(lambda, list1, list2)
	let z = Zip(a:list1, a:list2)
	return Map({pair -> a:lambda(pair[0], pair[1])}, z)
endfunc

" lambda(element) where element is an element of the list
func! Map(lambda, list)
	" the lambda takes only the value as argument

	" create a copy of list, so there's no hidden mutabiliy from the use of map()
	let list = a:list[:]

	return map(list, { i,v -> a:lambda(v) })
endfunc

" lambda(element) where element is an element of the list
func! Filter(lambda, list)
	let list = []

	for element in a:list

		if a:lambda(element)
			
			let list = list + [element]

		endif

	endfor

	return list
endfunc

func! Last(list)
	if len(a:list) <= 0
		return ''
	else
		return a:list[len(a:list)-1]
	endif
endfunc

" produces a list of length n, so start is the result of iteration 1 and func
" will be called n-1 times
"
" func to produce next value of iteration
" func  (p, n, l)
" where p = previous result of the iteration
"       n = current iteration count, the start element has count 0
"       l = the current state of the list (before computing the next element)
func! Iterate(n, func, start)

	if a:n < 1
		return []
	endif

	let list = [a:start]

	" minus 1 because the first element (start) has already been added
	for i in range(a:n-1)

		let last = Last(list)
		let list = list + [ a:func(last, i, list) ]

	endfor

	return list
endfunc

" Iterate but the start value is a list
"
" runs the iteration n times, starting with startList on iteration 0, so func
" will be called n times
"
" func to produce next value of iteration
" func  (p, n, l)
" where p = previous result of the iteration
"       n = current iteration count, the start element has count 0
"       l = the current state of the list (before computing the next element)
func! IterateList(n, func, startList)

	if a:n < 1
		return []
	endif

	let list = a:startList

	" n is the iteration count, not an index into the list (as not to
	" confuse myself, let's call it n and not i)
	for n in range(a:n)

		let last = Last(list)
		let list = list + [ a:func(last, n, list) ]

	endfor

	return list
endfunc

" while lambda returns true, this iterates
" func to produce next value of iteration
"
" lambda(p, n, l)
" func  (p, n, l)
" where p = previous result of the iteration
"       n = current iteration count, the start element has count 0
"       l = the current state of the list (before computing the next element)
func! IterateWhile(lambda, func, start)
	let list = []
	let n    = 0

	let next = a:start

	while a:lambda(next, n, list)

		let n    = n + 1
		let list = list + [ next ]
		let next = a:func(next, n, list)

	endwhile

	return list
endfunc

" lambda(acc, v)
func! Foldl(lambda, acc, list)
	let acc = a:acc

	for i in range(len(a:list))
		let acc = a:lambda(acc, a:list[i])
	endfor

	return acc
endfunc

" lambda(v, acc)
func! Foldr(lambda, acc, list)
	let acc = a:acc

	for i in range(len(a:list)-1, 0, -1)
		let acc = a:lambda(a:list[i], acc)
	endfor

	return acc
endfunc

func! Chars(string)
	" return split(a:string, '\zs')
	return Foldl({acc, c -> acc+[c]}, [], a:string)
endfunc

func! Unchars(list)
	return Foldl({acc, c -> acc.c}, "", a:list)
endfunc

func! Words(string)
	return split(a:string, " ")
endfunc

func! Unwords(list)
	return join(a:list, " ")
endfunc

func! Lines(string)
	return split(a:string, "\n")
endfunc

func! Unlines(list)
	return join(a:list, "\n")
endfunc

func! SplitAt(n, list)
	return a:n <= 0 ? [ [], a:list ] : [ a:list[0:(a:n-1)], a:list[(a:n):] ]
endfunc

" splits before element, provided element exists
func! SplitAtElement(element, list)
	return SplitAt(Find(a:element, a:list), a:list)
endfunc

func! SplitAfterElement(element, list)
	return SplitAt(IndexOf(a:element, a:list) + 1, a:list)
endfunc

" finds the index of element in the list
" if the element isn't in the list, this will return the length of the list
func! Find(element, list)
	return len( TakeWhile({i -> i != a:element}, a:list) )
endfunc

" finds the index of the element in the list
" if the element isn't in the list, this returns -1
func! IndexOf(element, list)
	let l = Find(a:element, a:list)

	if l >= len(a:list)
		return -1
	else
		return l
	endif
endfunc

func! Repeat(n, element)
	return Iterate(a:n, {i->i}, a:element)
endfunc

func! Flatten(list)
	return Foldl({v,acc->v+acc}, [], a:list)
endfunc

func! FlattenStr(list)
	return Foldl({v,acc->v.acc}, "", a:list)
endfunc

" puts element in between every element of list (but not before the first or
" after the last)
" note, that haskell's intersperse has flipped argument order
func! Intersperse(list, element)
	return Init(Flatten(Zip(a:list, Repeat(len(a:list), a:element))))
endfunc

func! Alternate(list1, list2)
	return Flatten(Zip(a:list1, a:list2))
endfunc

" Alternate but keep leftovers
func! AlternateFull(list1, list2)
	let shorter = len(a:list1) > len(a:list2) ? a:list2 : a:list1
	let longer  = len(a:list1) < len(a:list2) ? a:list2 : a:list1
	return Alternate(a:list1, a:list2) + Drop( len(shorter), longer )
endfunc

func! Elem(element, list)
	return FlattenStr(Map({v -> v == a:element ? v : ''}, a:list)) != ''
endfunc

func! Init(list)
	" last index in the list
	let l = len(a:list)-1

	" if there's nothing or just one element in the list, there's no init
	" to return
	if l <= 0
		return []
	else
		return a:list[0:len(a:list)-2]
	endif
endfunc

func! SplitStr(string, regex)
	let r = '\('.a:regex.'\)'
	let rAfter  = r.'\zs'		" start match AFTER the match of r
	let rBefore = '\ze'.r		" end match BEFORE the match of r

	" in order of application (bottom up):
	"   - split AFTER occurence of index pattern
	"   - map to split BEFORE occurence of index pattern;
	"     this isolates the index patterns and returns a list of lists of
	"     strings
	"   - flatten one level, so we get a list of strings

	return Flatten( Map({ s -> split(s, '\ze'.r) }, split(a:string, r.'\zs') ) )
endfunc

" Split list into groups of length n.
" If list can't be split evenly, those elements leftover are ignored.
func! GroupN(n, list)
	return IterateWhile( { p,i -> i < len(a:list)/a:n }, { p,i -> Take(a:n, Drop((i)*a:n, a:list)) }, Take(a:n, a:list) )
endfunc

" Split list into groups of length n.
" If list can't be split evenly, the leftover elements are appended in a list
" at the end.
func! GroupNFull(n, list)
	return GroupN(a:n, a:list) + [ Drop(len(a:list) - len(a:list) % a:n, a:list) ]
endfunc

" Lambda must be a predicate, list will be split into a list of lists of
" originally adjacent elements, all of which either fullfill or break the
" predicate
func! Groups(lambda, list)
	let list = a:list
	let Lambda = a:lambda
	let NotLambda = { v -> !Lambda(v) }

	let l = []

	while len(list) > 0

		let matchers    = TakeWhile(Lambda,    list)
		let notmatchers = TakeWhile(NotLambda, DropWhile(Lambda, list))

		let list = DropWhile(NotLambda, DropWhile(Lambda, list))

		" if the lambda doesn't match at the beginning of the list,
		" matchers may be empty
		if matchers != []
			let l = l + [ matchers ] + [ notmatchers ]
		else
			let l = [ notmatchers ]
		endif

	endwhile

	return l
endfunc

func! Max(list)
	return max(a:list)
endfunc

func! Min(list)
	return min(a:list)
endfunc

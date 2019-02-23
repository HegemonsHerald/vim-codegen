
source functionals.vim


let h = "hello {} world{}!"

func! SubstToken(string, prompts, token, altToken)

	" let t = Chars(a:token)
	" let l = Map({v->Unchars(v)}, Groups({ c -> Elem(c, t) }, Chars(a:string)))

	let l = split(a:string, a:token)
	let l = FlattenStr(Alternate(l,a:prompts) + [Last(l)])
	return substitute(l, a:altToken, a:token, 'g')

endfunc

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


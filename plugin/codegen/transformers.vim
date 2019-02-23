" If the key has a value in the dict, this returns the value,
" otherwise it returns the key
" func! MaybeLookup(key, dict)
" 	if has_key(a:dict, a:key)
" 		return a:dict[a:key]
" 	else
" 		return a:key
" 	endif
" endfunc

let b:MaybeLookup = { k, d -> has_key(k, d) == 1 ? d[k] : k }

" Type transformer TODO make this one nice and advanced and move it out to the
" java specific file
let TypeDict = {'i': 'int', 'd': 'double'}
let Type = { string -> MaybeLookup(string, TypeDict)}


" All Name Transformers take a string of whitespace separated tokens and to
" their transformation on that, assuming that each token is one word.

" These lambdas are buffer-local because it seems, that vimscript won't allow
" passing around pre-defined lambdas as arguments unless they are prefixed
" somehow. This is the only way to have these lambdas in a library file.
"
" Include this file using 'source /path/to/transformers.vim', if you wish to
" use them

" Name transformers
let b:SnakeCase      = { string -> join(    split(trim(string)                                        ), '_') }
let b:LowerSnakeCase = { string -> join(map(split(trim(string)), {i,v -> tolower(v)}                  ), '_') }
let b:UpperSnakeCase = { string -> join(map(split(trim(string)), {i,v -> toupper(v[0]).tolower(v[1:])}), '_') }
let b:UpperCase      = { string -> join(map(split(trim(string)), {i,v -> toupper(v)}                  ), '_') }
let b:CamelCase      = { string -> join(map(split(trim(string)), {i,v -> toupper(v[0]).v[1:]}         ),  '') }
let b:LowerCamelCase = { string -> trim(string)[0].CamelCase(trim(string))[1:] }

" Do nothing transformer
let b:Id = {n -> n}

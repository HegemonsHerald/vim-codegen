" Inserts the tokens into the appropriate positions in the format string.
"
" Usage: Format(format string, [ tokens ])
"
" Two types of substitution tokens are supported in the format string:
"
"   Note: If you wish to have the substitution token patterns '{}' and '{NUMBER}'
"   in your tokens, you must use the escape variants, or this will lead to
"   undefined behaviour.
"
"   '{}' will be substituted linearly against the token list
"     Example:
"       Format( "Hello {}! {{}} Honkers {} Lemon {}", [ "World", "Bonkers", "Squonkers" ] ) => "Hello World! {} Honkers Bonkers Lemon Squonkers"
"   You can see, that the first token is put in place of the first occurrence
"   of '{}', the second token in place of the second occurrence, and so on.
"
"   Providing more tokens than what there are positions for will lead to
"   undefined behaviour. Unused token positions will simply disappear.
"   The escape pattern for writing just '{}' in the final string is '{{}}'
"
"   '{INDEX}' will be substituted for the token with the index INDEX from the
"   token list:
"     Example:
"       Format( "Hello {3}! {{42}} Honkers {2}{2} Lemon {0}", [ "World", "Bonkers", "Squonkers", "Quack" ] ) => "Hello Quack! {42} Honkers SquonkersSquonkers Lemon World"
"   Indices in the token string, that are out of bounds aren't allowed and
"   will result in undefined behaviour -- probably an error. (Haven't tried)
"   You don't have to use all available tokens. The order of the occurrences
"   of indices in the token string also is irrelevant.
"
func! Format(fString, tokens)
	let tokens = a:tokens
	let format = a:fString

	" Linear substitution
	let format = SubstLinear  (format, tokens)

	" Indexed substitution
	let format = SubstIndexed (format, tokens)

	" Substitute Escape patterns
	let format = substitute(format, '{\({[^}]*}\)}', '\1', 'g')

	return format
endfunc

func! SubstLinear(fString, tokens)
	return FlattenStr(AlternateFull(split(a:fString, '{\@<!{}}\@!'), a:tokens))
endfunc

func! SubstIndexed(fString, tokens)
	let r  = '{\@<!{\d\+}}\@!'

	" in order of application (bottom up):
	"   - split the string on the index pattern
	"   - map the substrings, that match the index pattern, to their
	"     corresponding token
	"      - s[1:len(s)-2] removes the first and last
	"        character of s, leaving just the index
	"   - concatenate to a string and return

	return FlattenStr(
			\  Map({ s -> match(s, r) != -1 ? a:tokens[ s[1:len(s)-2] ] : s },
			\  SplitStr(a:fString, r)))
endfunc

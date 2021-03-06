
source ../../codegen_lib/core.vim
source ../../codegen_lib/format.vim
source ../../codegen_lib/functionals.vim
source ../../codegen_lib/transformers.vim

func Run()

   let input = "  public   static  ArrayList  < HashMap< Integer, Double> >  [  ]  complicatedThing (int honk, double stonkr , MetaBall clonkers)   throws TamperTantrum, HOnker  {"
   " let input = "  public   static  ArrayList  < HashMap< Integer, Double> >  [  ]  complicatedThing (int honk, double stonkr , MetaBall clonkers)   throws TamperTantrum, {"
   " let input = "  public   ArrayList  < HashMap< Integer, Double> >   complicatedThing (, double stonkr , MetaBall clonkers)   {"
   " let input = "  void   complicatedThing (, double stonkr , MetaBall clonkers)   {"
   " let input = "  void   complicatedThing ()   {"


   " INPUT SANITIZER PART

   " hmmmmmm
   let input = trim(input)

   " fix multi-whitespace
   let line = substitute(input, '\s\+', ' ', 'g')

   " remove spaces AROUND any of these: , [ < ( )
   let line = substitute(line, '\v\s*([,[<()])\s*', '\1', 'g')

   " remove spaces BEFORE any of these: ] >
   let line = substitute(line, '\s*\([>\]]\)', '\1', 'g')

   " remove trailing {
   let line = substitute(line, '\s*{$', '', '')

   " INSERT spaces around these: ( )
   let line = substitute(line, '\v([()])', ' \1 ', 'g')




   " METHOD DESTRUCTURING PART

   let words = Words(line)

   " remove keywords from beginning
   let words = Filter( { s -> match(s, '\v(public|private|protected|static)') == -1 }, words )

   " get type
   let type = Head(words)
   let words = Tail(words)

   " get name
   let name = Head(words)
   let words = Tail(words)

   " get parameters

   " remove '(' from the beginning
   let words = Tail(words)

   " actually get parameters
   let args = TakeWhile( { s -> s != ')' }, words )
   let words = Drop( len(args) + 1, words )

   " turn the commas in the parameters list into spaces
   let args = Words( substitute( Unwords(args), ',', ' ', 'g') )

   " get just every second word (the parameters' names)
   let args = Map( { p -> p[1] }, GroupN(2, args) )


   " get exceptions
   let excepts = Head(words) == 'throws' ? Tail(words) : []

   " remove the commas, if there are multiple exceptions specified
   let excepts = Words( substitute( Unwords(excepts), ',', ' ', 'g') )



   " create token dictionairy

   let tokenDict = { '%n': '{@code '.name.'}', '%t': '{@code '.type.'}', '%{':'{@code' }

   " can't do these for-loops as Map()s cause I need to run let-statements...
   for p in Zip(range(len(args)), args)
      let tokenDict['%p'.p[0]] = '{@code '.p[1].'}'
   endfor

   for e in Zip(range(len(excepts)), excepts)
      let tokenDict['%e'.e[0]] = '{@code '.e[1].'}'
   endfor

   let dictStr = FlattenStr( Intersperse( Map( { key -> key.': '.tokenDict[key] }, keys(tokenDict) ), ' | ' ) )


   " Output the help string
   echo input
   echo dictStr


   " Description

   let DescTrans = { s -> TagsTransformer(s, 0, tokenDict) }
   let desc = Snippet('', '{}', [ {-> Prompt('desc: ', DescTrans, 'This is %n.') } ])

   " add period after first line of description
   let period = Last(Chars(Head(Lines(desc)))) == '.' ? '' : '.'
   let desc = Unlines( [ Head(Lines(desc)).period ] + Tail(Lines(desc)) )

   " uppercase first character
   let desc = toupper(desc[0]).desc[1:]



   " Compose tags snippets

   " add the actual tags to the varying bits
   let paramTags  = Map({ s -> '@param '.s }, args)
   let exceptTags = Map({ s -> '@throws '.s }, excepts)
   let returnTags = type == 'void' ? [] : [ '@return' ] " note, that I use a list here, cause the list monad deals with the 'void' case neatly

   " find the longest @param tag, that's used for indentation
   let descIndent = Max( Map( { s -> len(s) }, paramTags ) )

   " create tags transformer for the tags' prompts
   let TagsTrans = { s -> TagsTransformer(s, descIndent, tokenDict) }

   " compose format strings for the tag snippets, complete with indentation and appended '{}'
   let paramsFormatStrs = Map({ s -> AppendDescIndent(s, descIndent).'{}' }, paramTags )
   let exceptFormatStrs = Map({ s -> AppendDescIndent(s, descIndent).'{}' }, exceptTags)
   let returnFormatStrs = Map({ s -> AppendDescIndent(s, descIndent).'{}' }, returnTags)

   " create the Prompt() calls for the tags
   let paramsPrompts = map(paramTags,  { i, tag -> {-> Prompt(tag.': ', TagsTrans, 'A value for %p'.i          ) } })
   let exceptPrompts = map(exceptTags, { i, tag -> {-> Prompt(tag.': ', TagsTrans, '%n throws %e'.i            ) } })
   let returnPrompts = map(returnTags, { i, tag -> {-> Prompt(tag.': ', TagsTrans, '%n returns sth of type %t' ) } })


   " create the Snippet() calls for the tags

   " parameters and return type
   let paramsSnippets = Zip(paramsFormatStrs, paramTags)
   let paramsSnippets = Map({ p -> {-> Snippet('', p[0], [ p[1] ]) } }, paramsSnippets)

   " exceptions
   let exceptSnippets = Zip(exceptFormatStrs, exceptTags)
   let exceptSnippets = Map({ p -> {-> Snippet('', p[0], [ p[1] ]) } }, exceptSnippets)

   " return tag
   let returnSnippets = Zip(returnFormatStrs, returnTags)
   let returnSnippets = Map({ p -> {-> Snippet('', p[0], [ p[1] ]) } }, returnSnippets)


   " actually compose the tags-list
   let tags = paramsSnippets + returnSnippets + exceptSnippets


   " Run tags
   let tags = Unlines( Map({ S -> S() }, tags) )


   " Compose full comment
   let desc = Map({ l -> ' * '.l }, Lines(desc))
   let tags = Map({ l -> ' * '.l }, Lines(tags))

   " Add an empty line separating tags from description, if there are any tags
   let desc = len(tags) != 0 ? desc + [' *'] : desc

   let comment = [ '/**' ] + desc + tags + [' */']

   return Unlines(comment)

endfunc

func! TagsTransformer(line, indent, tokenDict)
   " Separate out the newline tokens
   let lines = SplitStr(a:line, '\\n')

   " If the last thing the user entered, was \n, we want to reprompt
   if match(Last(lines), '\\n') != -1
      " prompt for more lines
      let lines2 = SnippetIterateWhile('', '{}', [ {-> Prompt('multiline mode: ', g:Id, '') } ], { s -> s }, { s -> s != '' })

      " add newlines after each of the entered lines, so the user doesn't have to
      let lines2 = Intersperse(lines2, '\n')

      " separate out the newline tokens from inside the entered lines
      let lines2 = Flatten( Map( { s -> SplitStr(s, '\\n') }, lines2 ) )

      let lines = lines + lines2
   endif

   " Append spaces and tabs for indentation in multiline descriptions
   let indentChars = a:indent > 0 ? Unchars(Repeat(a:indent, ' ')).'	' : ''
   let lines = [ Head(lines) ] + Map( { l -> l == '\n' ? l : indentChars.l }, Tail(lines) )
   " Note: I don't prepend the '\n's with indentChars, cause trailing whitespace makes me mad

   " Substitute dict-tokens and turn newline tokens into actual newlines
   let output = FlattenStr(lines)
   let output = SubstTokens(output, a:tokenDict)
   let output = substitute(output, '\\n', "\n", 'g')

   return output
endfunc

func! SubstTokens(string, dict)
   let output = a:string
   for key in keys(a:dict)
      let output = substitute(output, key, a:dict[key], 'g')
   endfor
   return output
endfunc

func! AppendDescIndent(string, indent)
   let string = a:string

   " if string is already longer than indent, just append a space
   if len(string) > a:indent
      return string.' '
   endif

   " Append indent - len(string) spaces and a tab
   let n = a:indent - len(string)
   return Unchars( Chars(string) + Repeat(n, ' ') + [ '	' ] )
endfunc

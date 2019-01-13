
in-built functions in use

 - range
 - append
 - input
 - getline
 - match
 - getpos
 - cursor
 - line
 - setpos
 - split
 - map
 - toupper
 - len
 - join
 - index
 - search
 - substitute



<SID>
You can make a function or variable script local by prepending it with s:.
That makes it invisible from outside the script file, so you can't call it from the
command line.

If you define a mapping in the script file it can be accessed from outside the script.
But if you want the mapping to call a script-local function with s:, vim will shout,
because from outside the script, where you actuate the mapping, vim won't know which script
the s: should refer to, and thus won't know, which script-local function to call.

To fix this we use <SID> instead of s: in mappings. <SID> is replaced with a
string that is guaranteed to be unique per script. With <SID> the mappings won't have
any variable bits in them, instead there's a unique identifier for all script-local values,
that are used. Now, if you actuate a mapping from outside the script, vim knows, where
to find script-local functions and everything is fine.

Note that you can't use a script-local function from the command line directly.
The whole point is, that you can access the script-local functionality only via
mapping or from within the script, so that script-local stuff doesn't have namespace
collisions with outside stuff. (This way you don't have to care about giving your
functions perfectly unique names! They can just be named sensibly, but be local instead.)



what to do:
 - jdoc
 - switch statement
 - templates
 - properly document the stuff with a markdown file AND A VIM DOC FILE
    - make rust-esque comments for all functions, their functionality,
      parameters and possibly return type -> you want to publish this
      and possibly extend it in the future, make it maintainable!
    - markdown readme on the github, that explains everything with examples
    - same file, just plaintext-ified, as vim doc

 - comment blocks
    - auto block the current scope or by visual selection
    - uncomment the current code-block-comment

 - test what happens when you change '=' formatting settings

 - jdoc
    - jdoc exists checks if jdoc exists, is called by the next 3
    - jdoc for methods
    - jdoc for classes and interfaces also generics
    - jdoc oneliners
    - jdoc meta discovers what the cursor is in
    - jdoc all goes through all things


 - in documentation make a note:
    I chose to make my functions script-local and use <SID> mappings cause there are
    quite a few of both of them. I don't want my names to collide with anything, and
    I also don't really want to use a prefix in the names either. This is the logical
    conclusion, since basically none of my functions would be particularly useful
    when called from the command line anyways.
 - in documentation make a note:
    There's a rough convention, that if some code, that's generated, contains parens,
    in which should be one or multiple expressions (eg in a for loop), that are prompted
    for, and the user doesn't enter anything, the constructor function will start insert
    mode in these parens instead of its regular position (usually in a code block).
 - in documentation make a note:
    Sidenote: If you want to make your own mappings, you've got two options. Either you
    can edit the plugin's files directly, or you can open an issue here on github, cause
    I'll happily turn the scrip-local functions into public functions, just with a prefix
    (sth like 'TTJava'), so you can map to them from anywhere. I'm not doing that right
    now, cause s: is shorter than 'TTJava'.







so now we got:
 - constants
 - constants constructors
 - literals
 - constructors
 - array constants
 - array literals
 - array constructors
 - array constants constructors
 - arrayList constructors
 - methods
 - static methods
 - and all that in private and public
 - for
 - for more configurable
 - for completely configurable
 - while
 - while completely configurable
 - do while
 - do while completely configurable
 - if
 - else if
 - else
 - if oneline
 - else if oneline
 - else oneline
 - println

 - and the get name prompt allows you to enter space separated words,
   and converts them into lowerCamelCase or UPPER_SNAKE_CASE depending
   on context
 - the get type function does the same, just for types! and it's going
   to learn to replace shorthands for primitives with the appropriate
   primitive value and wrappers in case of generics, so i don't even
   have to think about the wrapper classes, when using it!

still to come:
 - jfor
 - Jfor
 - \jfor
 - jwhile
 - Jwhile
 - \jwhile
 - jdo
 - Jdo
 - \jdo
 - jif
 - Jif
 - jel
 - Jel
 - jls
 - Jls
 - \jdoc

hypotheticals:
 - \Jdoc
 - jswitch
 - jvec


private static final int NUMBERS[] = {1, 2, 3, 0, 8};
private static final int NUMBERS2[] = new int[88];



vimscript basically just extends the set of
ex commands by a list of language statements
like :let and :if! Ex commands were there,
the parser for them was there, too, how to
easily make a language on top of that?, well
just add the language as a new set of commands!
That'll also be the reason why you have to call
let every time you change a variable: if you
wrote down the name of the var directly, vim
wouldn't know, what you're talking about, but
if you give it the :let ex command, it knows
you'd like to change a variable!
That also explains :endif reasonably well!
And why you have to use :call to call a function!

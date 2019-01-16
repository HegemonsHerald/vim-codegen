
let VSBL = '\(public'.W1.'\|private'.W1.'\|protected'.W1.'\)\?'
let STTC = '\(static'.W1.'\)\?'
let TYPE = '\(void\|short\|int\|char\|double\|float\|boolean\|long\|byte\|\u\w*\(<[^>]>\)\?\(\[\]\)\?\)'
let NAME = '\w\+'

let METHOD = VSBL.STTC.TYPE.'\s\+'.NAME.'\s*'.'('.'[^()]*'.')'

" The only thing with Type name parenthesis is the method declaration

" This lets you find ALL possible methods in the entire class file

{
open Parser

exception SyntaxError of string
}


let newline = '\r' | '\n' | "\r\n"
let white = [' ' '\t']+
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?


rule read =
  parse
  | white    { read lexbuf }
  | newline  { Lexing.new_line lexbuf; read lexbuf; EOL }
  | float    { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | eof      { EOF }
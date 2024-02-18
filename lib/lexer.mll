{
open Parser

exception SyntaxError of string
}


let newline = '\r' | '\n' | "\r\n"
let white = [' ' '\t']+
let digit = ['0'-'9']
let frac = '.' digit*
let float = digit+ frac?


rule read =
  parse
  | white    { read lexbuf }
  | newline  { EOL }
  | float    { 
    let x = Lexing.lexeme lexbuf in
    Printf.printf "we got '%s'\n" x;
    FLOAT (float_of_string x) 
  }
  | "STARTFONT" { STARTFONT }
  | "ENDFONT" { ENDFONT }
  | eof      { EOF }
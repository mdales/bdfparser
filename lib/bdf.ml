
type t = float

type token = 
| FLOAT of (float)
| EOL
| EOF
| STARTFONT
| ENDFONT

(* val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Wibble.value option) *)


let load_font (filename: string) : t option =
  let ic = In_channel.open_text filename in
  let lexbuf = Lexing.from_channel ic in
  Parser.prog Lexer.read lexbuf


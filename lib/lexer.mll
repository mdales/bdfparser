{
open Parser

exception SyntaxError of string
}


let newline = ['\r' '\n']+
let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let frac = '.' digit*
let float = digit+ frac
let name = ['a'-'z' 'A'-'Z' '-' '0'-'9' '_']+
let string = '"' ['a'-'z' 'A'-'Z' '-' '0'-'9' ' ']* '"'

rule read =
  parse
  | white             { Printf.printf "w\n"; read lexbuf }
  | newline           { Printf.printf "eol\n"; EOL }
  | float             { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | int               { Printf.printf "int\n"; INT (int_of_string (Lexing.lexeme lexbuf)) }
  (* | "BBX"             { BBX }
  | "BITMAP"          { BITMAP } *)
  | "FONTBOUNDINGBOX" { BOUNDINGBOX }
  | "CHARS"           { CHARS }
  | "COMMENT"         { Printf.printf "com\n"; COMMENT }
  (* | "CONTENTVERSION"  { CONTENTVERSION }
  | "DWIDTH"          { DWIDTH }
  | "DWIDTH1"         { DWIDTH1 }
  | "ENCODING"        { ENCODING }
  | "ENDCHAR"         { ENDCHAR } *)
  | "ENDFONT"         { Printf.printf "ef\n"; ENDFONT }
  | "ENDPROPERTIES"   { Printf.printf "ep\n"; ENDPROPERTIES }
  | "FONT"            { FONTNAME }
  (* | "METRICSET"       { METRICSET } *)
  | "SIZE"            { SIZE }
  (* | "STARTCHAR"       { STARTCHAR } *)
  | "STARTFONT"       { STARTFONT }
  | "STARTPROPERTIES" { Printf.printf "sp\n"; STARTPROPERTIES }
  (* | "SWIDTH"          { SWIDTH }
  | "SWIDTH1"         { SWIDTH1 }
  | "VVECTOR"         { VVECTOR } *)
  | eof               { EOF }
  | name              { Printf.printf "name\n"; NAME (Lexing.lexeme lexbuf) }
  | string            { Printf.printf "string\n"; STRING (Lexing.lexeme lexbuf) }


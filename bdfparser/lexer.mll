{
open Parser

exception SyntaxError of string
}

let newline = ['\r' '\n']+
let white = [' ' '\t']+
let digit = ['0'-'9']
let hexdigit = ['0'-'9' 'a'-'f' 'A'-'F']
let int = '-'? digit+
let hexint = hexdigit+
let frac = '.' digit*
let float = digit+ frac
let name = ['a'-'z' 'A'-'Z' '-' '0'-'9' '/' ':' '.' ',' '_' '+' '@' '/']+
let string = '"' ['a'-'z' 'A'-'Z' '-' '0'-'9' ' ' '/' ':' '.' ',' '_' '+' '@' '/']* '"'

rule read =
  parse
  | white             { read lexbuf }
  | newline           { EOL }
  | float             { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | int               { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | hexint            { HEXINT (int_of_string (Printf.sprintf "0x%s" (Lexing.lexeme lexbuf))) }
  | "BBX"             { BBX }
  | "BITMAP"          { BITMAP }
  | "FONTBOUNDINGBOX" { BOUNDINGBOX }
  | "CHARS"           { CHARS }
  | "COMMENT"         { COMMENT }
  | "CONTENTVERSION"  { CONTENTVERSION }
  | "DWIDTH"          { DWIDTH }
  | "DWIDTH1"         { DWIDTH1 }
  | "ENCODING"        { ENCODING } 
  | "ENDCHAR"         { ENDCHAR } 
  | "ENDFONT"         { ENDFONT }
  | "ENDPROPERTIES"   { ENDPROPERTIES }
  | "FONT"            { FONTNAME }
  | "METRICSET"       { METRICSET }
  | "SIZE"            { SIZE }
  | "STARTCHAR"       { STARTCHAR }
  | "STARTFONT"       { STARTFONT }
  | "STARTPROPERTIES" { STARTPROPERTIES }
  | "SWIDTH"          { SWIDTH }
  | "SWIDTH1"         { SWIDTH1 }
  | "VVECTOR"         { VVECTOR } 
  | eof               { EOF }
  | name              { NAME (Lexing.lexeme lexbuf) }
  | string            { STRING (Lexing.lexeme lexbuf) }


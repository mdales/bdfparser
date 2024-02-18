type t = float;;

type token = 
| FLOAT of (float)
| EOL
| EOF
| STARTFONT
| ENDFONT

val load_font: string -> t option;;

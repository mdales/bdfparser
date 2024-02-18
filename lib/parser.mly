%token <float> FLOAT
%token STARTFONT
%token ENDFONT
%token EOL
%token EOF

%start <Bdf.t option> prog

%%

prog:
  | EOF      { None }
  | v = font { Some v }
  ;

font: 
  v = start_font; ENDFONT { v };

start_font:
  STARTFONT; v = FLOAT; EOL { v } ;
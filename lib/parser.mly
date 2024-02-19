%token EOL
%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token QUOTE
// %token BBX
// %token BITMAP
%token BOUNDINGBOX
%token CHARS
%token COMMENT
// %token CONTENTVERSION
// %token DWIDTH
// %token DWIDTH1
// %token ENCODING
// %token ENDCHAR
%token ENDFONT
// %token ENDPROPERTIES
%token FONTNAME
// %token METRICSET
%token SIZE
// %token STARTCHAR
%token STARTFONT
// %token STARTPROPERTIES
// %token WIDTH
// %token SWIDTH
// %token SWIDTH1
// %token VVECTOR
%token EOF

%start <Innertypes.header list option> prog

%%

prog:
  | f = font { Some f }
  ;

font: 
  vl = separated_list(EOL, font_part); EOF { vl }

start_font:
  STARTFONT ; v = FLOAT { v } ;

font_name:
  FONTNAME ; v = STRING { v } ;

size:
  SIZE ; p = INT ; x = INT ; y = INT { (p, x, y) }

bounding_box:
  BOUNDINGBOX ; fBBx = INT ; fBBy = INT ; xoff = INT ; yoff = INT { (fBBx, fBBy, xoff, yoff) }

comment:
  COMMENT ; QUOTE ; v = STRING ; QUOTE { v }

chars:
  CHARS ; v = INT { v }

font_part:
  // | BBX             { `Noop }
  // | BITMAP          { `Noop }
  // | BOUNDINGBOX             { `Noop }
  // | CONTENTVERSION             { `Noop }
  // | DWIDTH             { `Noop }
  // | DWIDTH1             { `Noop }
  | ENDFONT         { `Noop }
  // | ENDCHAR { `Noop }
  // | ENDPROPERTIES { `Noop }
  // | METRICSET { `Noop }
  // | STARTCHAR { `Noop }
  // | SWIDTH { `Noop }
  // | SWIDTH1 { `Noop }
  // | VVECTOR { `Noop }
  // | COMMENT { `Noop }
  // | ENCODING { `Noop }
  // | STARTPROPERTIES { `Noop }
  // | WIDTH { `Noop }
  | v = bounding_box  { `BoundingBox v }
  | v = chars         { `Chars v }
  | v = comment       { `Comment v }
  | v = font_name     { `FontName v }
  | v = size          { `Size v } 
  | v = start_font    { `Version v }
  ;

  


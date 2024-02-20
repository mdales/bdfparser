%token EOL
%token <int> INT
%token <float> FLOAT
%token <string> NAME
%token <string> STRING
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
%token ENDPROPERTIES
%token FONTNAME
// %token METRICSET
%token SIZE
// %token STARTCHAR
%token STARTFONT
%token STARTPROPERTIES
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
  FONTNAME ; v = NAME { v } ;

size:
  SIZE ; p = INT ; x = INT ; y = INT { (p, x, y) }

bounding_box:
  BOUNDINGBOX ; fBBx = INT ; fBBy = INT ; xoff = INT ; yoff = INT { (fBBx, fBBy, xoff, yoff) }

comment:
  COMMENT ; v = STRING { v }

chars:
  CHARS ; v = INT { v }

// property_str:
//   k = NAME ; s = STRING { 
//     let a : (string * Innertypes.property_val) = (k, `String s) in a
//   }

property_int: 
  k = NAME ; i = INT { (k, `Int i) }

// property:
//   | v = property_int { v }
//   | v = property_str { v }

property_list:
  | pl = separated_nonempty_list(EOL, property_int)  { Printf.printf "pl"; pl }
  ;

properties:
  | STARTPROPERTIES ; i = INT ; EOL ; pl = property_list; EOL ; ENDPROPERTIES { let _ = i in pl }
  | STARTPROPERTIES ; i = INT ; EOL ; ENDPROPERTIES { let _ = i in [] }
  ;
  
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
  | v = properties    { `Properties v }
  | v = bounding_box  { `BoundingBox v }
  | v = chars         { `Chars v }
  | v = comment       { `Comment v }
  | v = font_name     { `FontName v }
  | v = size          { `Size v } 
  | v = start_font    { `Version v }
  ;

  


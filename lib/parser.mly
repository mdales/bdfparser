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
%token CONTENTVERSION
// %token DWIDTH
// %token DWIDTH1
// %token ENCODING
// %token ENDCHAR
%token ENDFONT
%token ENDPROPERTIES
%token FONTNAME
%token METRICSET
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

contentversion:
  CONTENTVERSION ; v = INT { v }

metricset:
  METRICSET ; v = INT { v }

property_str:
  k = NAME ; s = STRING ; EOL { (k, `String s) }

property_int: 
  k = NAME ; i = INT ; EOL { (k, `Int i) }

property:
  | v = property_int { v }
  | v = property_str { v }
  ;

property_list:
  | pl = list(property)  { pl }
  ;

properties:
  | STARTPROPERTIES ; i = INT ; EOL ; pl = property_list ; ENDPROPERTIES { let _ = i in pl }
  ;
  
font_part:
  // | BBX             { `Noop }
  // | BITMAP          { `Noop }
  // | DWIDTH             { `Noop }
  // | DWIDTH1             { `Noop }
  | ENDFONT         { `Noop }
  // | ENDCHAR { `Noop }
  // | STARTCHAR { `Noop }
  // | SWIDTH { `Noop }
  // | SWIDTH1 { `Noop }
  // | VVECTOR { `Noop }
  // | ENCODING { `Noop }
  // | WIDTH { `Noop }
  | v = properties      { `Properties v }
  | v = bounding_box    { `BoundingBox v }
  | v = chars           { `Chars v }
  | v = comment         { `Comment v }
  | v = contentversion  { `ContentVersion v }
  | v = font_name       { `FontName v }
  | v = metricset       { `MetricSet v }
  | v = size            { `Size v } 
  | v = start_font      { `Version v }
  ;

  


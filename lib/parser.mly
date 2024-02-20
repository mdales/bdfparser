%token EOL
%token <int> INT
%token <int> HEXINT
%token <float> FLOAT
%token <string> NAME
%token <string> STRING
%token BBX
%token BITMAP
%token BOUNDINGBOX
%token CHARS
%token COMMENT
%token CONTENTVERSION
%token DWIDTH
%token DWIDTH1
%token ENCODING
%token ENDCHAR
%token ENDFONT
%token ENDPROPERTIES
%token FONTNAME
%token METRICSET
%token SIZE
%token STARTCHAR
%token STARTFONT
%token STARTPROPERTIES
%token SWIDTH
%token SWIDTH1
%token VVECTOR
%token EOF

%start <Innertypes.header list option> prog

%%

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

// ----------------- PROPERTIES ------

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
  
// ----------------- CHARS ------------

bbx:
  BBX ; a = INT ; b = INT ; c = INT ; d = INT ; EOL { (a, b, c, d) }

encoding:
  ENCODING ; v = INT ; EOL { v }

swidth:
  SWIDTH ; x = INT ; y = INT ; EOL { (x, y) }

dwidth:
  DWIDTH ; x = INT ; y = INT ; EOL { (x, y) }

swidth1:
  SWIDTH1 ; x = INT ; y = INT ; EOL { (x, y) }

dwidth1:
  DWIDTH1 ; x = INT ; y = INT ; EOL { (x, y) }

vvector:
  VVECTOR ; x = INT ; y = INT ; EOL { (x, y) }

bytes:
  // Probably a better way if I knew how to tell the parser to backtrack?
  | v = INT ; EOL { int_of_string (Printf.sprintf "0x%d" v) }
  | v = HEXINT ; EOL { v }
  ;

bitmap:
  BITMAP ; EOL ; b = list(bytes) { b }

char_part:
  | v = bbx       { `BBox v }
  | v = encoding  { `Encoding v }
  | v = swidth    { `SWidth v }
  | v = dwidth    { `DWidth v }
  | v = swidth1   { `SWidth1 v }
  | v = dwidth1   { `DWidth1 v }
  | v = vvector   { `VVector v }
  | v = bitmap    { `Bitmap v }
  ;

startchar:
  // Again, there has to be a better way to do this, as we lose the 
  // difference between a char A and char a, due to bouncing via int.
  | STARTCHAR ; v = NAME { v }
  | STARTCHAR ; v = INT { Printf.sprintf "%d" v }
  | STARTCHAR ; v = HEXINT { Printf.sprintf "%x" v }
  ;

char:
  n = startchar ; EOL ; parts = list(char_part) ; ENDCHAR { List.cons (`CharName n) parts }

// ----------------- TOP LEVEL --------

prog:
  | f = font { Some f }
  ;

font: 
  | vl = separated_list(EOL, font_part); EOF { vl }

font_part:
  | ENDFONT             { `Noop }
  | ENDFONT ; EOL       { `Noop }
  | v = char            { `Char v }
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

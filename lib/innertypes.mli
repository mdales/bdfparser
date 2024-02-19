type header =
  [ `Version of float
  | `FontName of string
  | `Size of int * int * int 
  | `BoundingBox of int * int * int * int
  | `Comment of string
  | `Chars of int
  | `Noop
  ]
type property_val = 
  [ `Int of int
  | `String of string
  ]
  
type header =
  [ `Version of float
  | `FontName of string
  | `Size of int * int * int 
  | `BoundingBox of int * int * int * int
  | `Comment of string
  | `Chars of int
  | `MetricSet of int
  | `ContentVersion of int
  | `Properties of (string * property_val) list
  | `Noop
  ]

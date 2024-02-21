
type c = {
  name : string;
  encoding : int;
  swidth : int;
  swidth1 : int;
  dwidth : int;
  dwidth1 : int * int ;
  vvector : int * int ;
}

type t = {
  version : float ;
  name : string ;
  size : string ;
  bounding_box : int * int * int * int ;
  content_version : int ;
  metric_set : int ;
  properties : (string * Innertypes.property_val) list;
  characters : c list;
}

let default_t = {
  version : 0. ;
  name : "" ;
  size : 0 ;
  bounding_box : (0, 0, 0, 0) ;
  content_version : 0 ;
  metric_set : 0 ;
  properties : [] ;
  characters : [] ;
}

let create (filename : string) -> t result =
  let ast = In_channel.with_open_text (fun ic =
    let lexbuf = Lexing.from_channel ic in
    Parser.prog Lexer.read lexbuf
  ) filename in
  List.fold_left (fun acc item =
  match
  ) default_t ast
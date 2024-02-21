
type c = {
  name : string;
  encoding : int;
  swidth : int * int;
  swidth1 : int * int;
  dwidth : int * int;
  dwidth1 : int * int ;
  vvector : int * int ;
  bounding_box : int * int * int * int ;
}

let default_c = {
  name = "" ;
  encoding = 0 ;
  swidth = (0, 0) ;
  swidth1 = (0, 0) ;
  dwidth = (0, 0) ;
  dwidth1 = (0, 0) ;
  vvector = (0, 0) ;
  bounding_box = (0, 0, 0, 0) ;
}

type t = {
  version : float ;
  name : string ;
  size : int * int * int ;
  bounding_box : int * int * int * int ;
  content_version : int ;
  metric_set : int ;
  properties : (string * Innertypes.property_val) list;
  characters : c list;
}

let default_t = {
  version = 0. ;
  name = "" ;
  size = (0, 0, 0) ;
  bounding_box = (0, 0, 0, 0) ;
  content_version = 0 ;
  metric_set = 0 ;
  properties = [] ;
  characters = [] ;
}

let innerchar_to_char (ic : Innertypes.char_property_val list) : c =
  List.fold_left (fun (acc : c) (item : Innertypes.char_property_val) : c ->
    match item with
    | `CharName n -> { acc with name=n }
    | `Encoding e -> { acc with encoding=e }
    | `SWidth s -> { acc with swidth=s }
    | `DWidth s -> { acc with dwidth=s }
    | `SWidth1 s -> { acc with swidth1=s }
    | `DWidth1 s -> { acc with dwidth1=s }
    | `VVector v -> { acc with vvector=v }
    | `BBox b -> { acc with bounding_box=b }
    | `Bitmap _ -> acc
  ) default_c ic


let create (filename : string) : (t, string) result =
  let ast = In_channel.with_open_text filename (fun ic ->
    let lexbuf = Lexing.from_channel ic in
    Parser.prog Lexer.read lexbuf
  ) in
  match ast with
  | None -> (Error "No file")
  | Some ast -> (
    Ok (List.fold_left (fun (acc : t) (item : Innertypes.header) : t ->
    match item with
    | `Version v -> { acc with version=v }
    | `Size s -> { acc with size=s }
    | `FontName n -> { acc with name=n }
    | `BoundingBox b -> { acc with bounding_box=b }
    | `Comment _ -> acc
    | `Chars _ -> acc
    | `MetricSet s -> { acc with metric_set=s }
    | `ContentVersion c -> { acc with content_version=c }
    | `Properties p -> { acc with properties=(List.concat [acc.properties ; p]) }
    | `Char c -> { acc with characters=((innerchar_to_char c) :: acc.characters)}
    | `Noop -> acc
    ) default_t ast)
  )

let name t =
  t.name

let bdf_version t =
  t.version

let version t =
  t.content_version

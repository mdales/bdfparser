open Bdfparser

let usage_msg = "info -f <bdf file> -s <test string>"
let args = ref []
let bdf_filename = ref ""
let test_str = ref ""
let anon_fun arg = args := !args @ [arg]
let speclist = [
  ("-f", Arg.Set_string bdf_filename, "BDF font file path");
  ("-s", Arg.Set_string test_str, "Test string");
]

let display_font_info (f : Bdf.t) (_example : string) =
  let name = Bdf.name f in
  let count = Bdf.glyph_count f in
  Printf.printf "Name: %s\nGlyph count: %d\n" name count

let () =
  Arg.parse speclist anon_fun usage_msg;

  match !bdf_filename with
  | "" -> Printf.printf "No font filename provided\n"
  | filename -> (
    match Bdf.create filename with
    | Error desc -> Printf.printf "Error loading font: %s\n" desc
    | Ok f -> display_font_info f !test_str
  )

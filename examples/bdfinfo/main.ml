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

let () =
  Arg.parse speclist anon_fun usage_msg;
  match Load.load_font !bdf_filename with
  | None -> Printf.printf "nothing\n"
  | Some h -> Printf.printf "Header count %d\n" (List.length h)

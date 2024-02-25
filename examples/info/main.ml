open Bdfparser

let () =
  match Load.load_font "minimal.bdf" with
  | None -> Printf.printf "nothing\n"
  | Some h -> Printf.printf "Header count %d\n" (List.length h)

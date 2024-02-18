open Bdfparser

let () =
  match Bdf.load_font "minimal.bdf" with
  | None -> Printf.printf "nothing\n"
  | Some v -> Printf.printf "Versin %f\n" v

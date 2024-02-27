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

let draw_char (data : bytes) (bits_per_row : int) : unit =
  let bytes_per_row = (bits_per_row / 8) + (if (bits_per_row mod 8) == 0 then 0 else 1) in
  for h = 0 to (((Bytes.length data) / bytes_per_row) - 1) do
    Printf.printf "%02d: " h;
    for w = (bytes_per_row - 1) downto 0 do
      let bit = int_of_char (Bytes.get data ((h * bytes_per_row) + w)) in
      let bits_offset = ((bytes_per_row - 1) - w) * 8 in
      let remaining = if (bits_offset + 8) < bits_per_row then 7 else ((bits_per_row - bits_offset) - 1) in
      for s = 0 to remaining do
        let isbit = (bit lsl s) land 0x80 in
        Printf.printf "%c" (if isbit != 0 then '*' else '.')
      done
    done;
    Printf.printf "\n"
  done

let display_char_info (f : Bdf.t) (c : char) : unit =
  match Bdf.glyph_of_char f (Uchar.of_char c) with
  | None -> Printf.printf "\nCharacter: %c\nNot found\n" c
  | Some g -> (
    let name = Bdf.glyph_name g in
    Printf.printf "\nCharacter: %c\nName: %s\n" c name;
    let x, y = Bdf.glyph_dimensions g in
    Printf.printf "Dimensions: %d x %d\n" x y;
    let bitmap = Bdf.glyph_bitmap g in
    Printf.printf "Bitmap bytes: %d\n" (Bytes.length bitmap);
    draw_char bitmap x;
  )

let display_font_info (f : Bdf.t) (example : string) : unit =
  let name = Bdf.name f in
  let count = Bdf.glyph_count f in
  Printf.printf "Name: %s\nGlyph count: %d\n" name count;
  let sl = List.init (String.length example) (String.get example) in
  let rec loop remaining = (
    match remaining with
    | [] -> ()
    | c :: remainin -> (
      display_char_info f c;
      loop remainin
    )
  )
  in loop sl

let () =
  Arg.parse speclist anon_fun usage_msg;

  match !bdf_filename with
  | "" -> Printf.printf "No font filename provided\n"
  | filename -> (
    match Bdf.create filename with
    | Error desc -> Printf.printf "Error loading font: %s\n" desc
    | Ok f -> display_font_info f !test_str
  )

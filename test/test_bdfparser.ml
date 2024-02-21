open OUnit2
open Bdfparser

let test_empty_parsing _ = 
  let lexbuf = Lexing.from_string "" in
  let ast = Parser.prog Lexer.read lexbuf in
  match ast with
  | None -> assert_failure "Got nothing"
  | Some l -> assert_equal l [] 

let test_basic_parsing _ = 
  let prose = 
{|STARTFONT 2.1
ENDFONT|} in
  let lexbuf = Lexing.from_string prose in
  let ast = Parser.prog Lexer.read lexbuf in
  let expected = [(`Version 2.1) ; (`Noop)] in
  match ast with
  | None -> assert_failure "Got nothing"
  | Some l -> assert_equal l expected
  
let suite =
  "BasicParsingTests" >::: [
    "test_empty_parsing" >:: test_empty_parsing;
    "test_basic_parsing" >:: test_basic_parsing
  ]

let () =
  run_test_tt_main suite
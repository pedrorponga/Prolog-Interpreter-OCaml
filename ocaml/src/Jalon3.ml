(*
#require "ounit2";;
#load "interpret.cmo"
#load_rec "tests.cmo";;
#use "Jalon3.ml";;
*)

open Interpret
open Tests

(* interprete3 tests *)
let _ =
  List.iter
    (fun file -> test_interprete interprete3 file)
    [ "/exemples/classification.pro"
    ; "/exemples/genealogie.pro"
    ; "/exemples/listes.pro"
    ; "/exemples/backtracking.pro"
    ]
;;

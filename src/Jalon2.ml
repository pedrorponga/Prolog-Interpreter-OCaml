(*
#require "ounit2";;
#load "interpret.cmo"
#load_rec "tests.cmo";;
#use "Jalon2.ml";;
*)

open Interpret
open Tests

(* interprete2 tests *)
let _ =
  List.iter
    (fun file -> test_interprete interprete2 file)
    [ "/tests/interprete2_test1.pro"
    ; "/tests/interprete2_test2.pro"
    ; "/tests/interprete2_test3.pro"
    ; "/tests/interprete2_test4.pro"
    ; "/tests/interprete2_test5.pro"
    ]
;;

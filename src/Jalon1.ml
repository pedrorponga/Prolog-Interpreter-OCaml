(*
#require "ounit2";;
#load "interpret.cmo"
#load_rec "tests.cmo";;
#use "Jalon1.ml";;
*)

open Interpret
open Tests

(* interprete0 tests *)
let _ =
  List.iter
    (fun file -> test_interprete interprete0 file)
    [ "/tests/interprete0_test1.pro"; "/tests/interprete0_test2.pro" ]
;;

(* interprete1 tests *)
let _ =
  List.iter
    (fun file -> test_interprete interprete1 file)
    [ "/tests/interprete1_test1.pro"
    ; "/tests/interprete1_test2.pro"
    ; "/tests/interprete1_test3.pro"
    ]
;;

(*
#require "ounit2";;
#load_rec "tests.cmo";;
#use "tests.ml";;
*)

open Ast
open Unify
open Main
open Interpret
open Solve
open OUnit2

let t1 = parse_to_term "p(Z, h(Z, W), f(W))."
let t2 = parse_to_term "p(f(Y), h(f(Y), Y), f(Y))."

(* replace tests *)
let env = [ "W", Var "Y"; "Z", Func ("f", [ Var "W" ]) ]
let _ = assert (t2 = replace env t1)
let env = []

(* occurs tests *)
let _ = assert (occurs "Z" t1)

(* unify tests *)
let t3 = parse_to_term "p(f(X), h(Y, f(a)), Y)."
let t4 = parse_to_term "p(a, X, f(g(Y)))."
let t5 = parse_to_term "p(Z, f(Z), f(U))."
let t6 = parse_to_term "q(f(a), g(X))."
let t7 = parse_to_term "q(Y, Y)."
let t8 = parse_to_term "p(X, f(X), f(f(X)))."
let t9 = parse_to_term "p(f(f(Y)), Y, f(Y))."

(* check unification *)
let unif_1 = unify [] t1 t2
let _ = assert (replace unif_1 t1 = replace unif_1 t2)
let unif_2 = unify [] t1 t3
let _ = assert (replace unif_2 t1 = replace unif_2 t3)
let unif_3 = unify [] t4 t5
let _ = assert (replace unif_3 t4 = replace unif_3 t5)

(* check not unifiability *)
let _ =
  let f () = unify [] t6 t7 in
  OUnit2.assert_raises Not_unifiable f
;;

let _ =
  let f () = unify [] t8 t9 in
  OUnit2.assert_raises Not_unifiable f
;;

(* interpreters *)

let test_interprete interpreter f =
  let ast = parse_file (path ^ f) in
  let substitutions = interpreter ast in
  Printf.printf "AST:\n%s\n" (Ast.string_of_dec_list ast);
  List.iter
    (fun subst -> Printf.printf "Substitution:\n%s\n" (Ast.string_of_env subst))
    substitutions;
  Printf.printf "\n"
;;

(* rename tests *)
let _ =
  let ast = parse_file (path ^ "/tests/rename_test.pro") in
  assert (
    string_of_dec (rename 1 (List.hd ast))
    = "p(Z1, h(Z1, W1), f(W1)) :- r(X1, XX1), q(XX1).")
;;

(* step tests *)
let _ =
  let ast_rev = List.rev (parse_file (path ^ "/tests/step_test.pro")) in
  let result = step 1 [] (List.hd ast_rev) (List.tl ast_rev) in
  match result with
  | Some (body', _, env') ->
    assert (string_of_env env' = "{Z1 -> f(X); Y -> f(X); W1 -> a; X -> a}");
    assert (List.map string_of_term body' = [ "r(X1, XX1)"; "q(XX1)" ])
  | None -> raise Not_solvable
;;

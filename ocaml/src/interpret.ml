(*
#load_rec "interpret.cmo";;
#use "interpret.ml";;
*)

open Ast
open Unify

(** split (ast : dec list) separates a AST into rules and goals. *)
let split (ast : dec list) : dec list * dec list =
  let rec aux rules ast =
    match ast with
    | [] -> List.rev rules, []
    | (Assert (head, body) as rule) :: rest -> aux (rule :: rules) rest
    | Goal g :: rest as goals -> List.rev rules, goals
  in
  aux [] ast
;;

(** interprete0 (ast : dec list) takes as argument the AST of a Prolog
    program with only one fact and one goal. It returns an environnement
    with the unification necessary to solve the program.
*)
let interprete0 (ast : dec list) : environnement list =
  match split ast with
  | [ Assert (t1, []) ], [ Goal [ t2 ] ] -> [ unify [] t1 t2 ]
  | _ -> raise (Invalid_argument "check function description")
;;

(** interprete1 (ast : dec list) takes as argument the AST of a Prolog
    program with only one fact per functor and one goal. It returns an
    environnement with the unification necessary to solve the program.
*)
let rec interprete1 (ast : dec list) : environnement list =
  let rec interprete1_aux (rules : dec list) (goals : dec list) : environnement =
    match rules, goals with
    | Assert (t1, []) :: rest, [ Goal [ t2 ] ] ->
      (try unify [] t1 t2 with
      | Not_unifiable -> interprete1_aux rest [ Goal [ t2 ] ])
    | [], [ Goal [ t2 ] ] -> raise Not_unifiable
    | _ -> raise (Invalid_argument "check function description")
  in
  match split ast with
  | rules, goals -> [ interprete1_aux rules goals ]
;;

(** interprete2 (ast : dec list) takes as argument the AST of a Prolog
    program with only one rule per functor and one or several goals.
    It returns a list of environnements with the unification necessary
    to solve the program.
*)
let interprete2 (ast : dec list) : environnement list =
  match split ast with
  | rules, goals -> List.map (fun g -> Solve.solve g rules) goals
;;

(** interprete3 (ast : dec list) takes as argument the AST of a Prolog
    program with one or several goals. It returns a list of environnements
    with the unification necessary to solve the program.
*)
let interprete3 (ast : dec list) : environnement list =
  match split ast with
  | rules, goals ->
    List.map
      (fun g ->
        Backtracker.assertions := rules;
        match Backtracker.solve [ g, !Backtracker.assertions, [], 1 ] with
        | ch, env -> env)
      goals
;;

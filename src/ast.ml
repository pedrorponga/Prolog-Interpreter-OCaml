(* Project Path *)
let path = "."

(* Termes *)
type term =
  | Var of string (* variables *)
  | Func of string * term list
(* functor (arg1, arg2, ...) *)

(* Declarations *)
type dec =
  | Assert of term * term list (* assertion  head :- body. *)
  | Goal of term list
(* requete       ?- body.      *)

(* environnement *)
type environnement = (string * term) list

(* choice is a data structure that encodes a choice context. *)
type choice = dec * dec list * environnement * int

(* printing functions *)
let rec string_of_term = function
  | Var v -> v
  | Func (f, ls) ->
    f
    ^ if ls <> [] then "(" ^ String.concat ", " (List.map string_of_term ls) ^ ")" else ""
;;

let string_of_dec = function
  | Assert (t, []) -> string_of_term t ^ "."
  | Assert (t, tl) ->
    string_of_term t ^ " :- " ^ String.concat ", " (List.map string_of_term tl) ^ "."
  | Goal tl -> "?- " ^ String.concat ", " (List.map string_of_term tl) ^ "."
;;

let string_of_dec_list l = String.concat "\n" (List.map string_of_dec l)

let string_of_env env =
  "{"
  ^ List.fold_right
      (fun (k, v) acc ->
        acc ^ (if acc = "" then "" else "; ") ^ k ^ " -> " ^ string_of_term v)
      env
      ""
  ^ "}"
;;

let string_of_choice (choice : choice) =
  match choice with
  | goals, rules, env, n ->
    "Goals:\n"
    ^ string_of_dec goals
    ^ "\nRules:\n"
    ^ string_of_dec_list rules
    ^ "\nEnv:\n"
    ^ string_of_env env
    ^ "\nCounter:\n"
    ^ string_of_int n
    ^ "\n"
;;

let string_of_choice_list (l : choice list) =
  String.concat "\n" (List.map string_of_choice l)
;;

open Ast
open Unify

(** Not_solvable is raised when there is no solution. *)
exception Not_solvable

(** rename (n : int) (rule : dec) takes as argument a rule and counter n
    and renames all variables adding the number n after the original
    name.
*)
let rec rename (n : int) (rule : dec) : dec =
  let rec rename_term (t : term) =
    match t with
    | Var x -> Var (x ^ string_of_int n)
    | Func (f, args) -> Func (f, List.map rename_term args)
  in
  match rule with
  | Assert (head, body) -> Assert (rename_term head, List.map rename_term body)
  | _ -> raise (Invalid_argument "rule is not a rule")
;;

(** step (n: int) (env: environnement) (goal: dec) (rules: dec list)
    finds the rule whose head can be unified with goal. Then this rule
    is renamed with n and the unification of the new head with goal is
    performed. An exception is raised if the unification cannot be done
    with any rule. The resulting env' is returned as well as the renamed
    body of the rule (as well as the non visited rules).
*)
let rec step (n : int) (env : environnement) (goal : dec) (rules : dec list) =
  match rules, goal with
  | rule :: rules, Goal [ g ] ->
    (match rename n rule with
    | Assert (head', body') ->
      (try
         let env' = unify env head' g in
         Some (body', rules, env')
       with
      | Not_unifiable -> step n env goal rules)
    | _ -> raise (Invalid_argument "not a rule"))
  | _ -> None
;;

(** solve (goals : dec) (rules : dec list) starts with an empty
    environnement and proves every goal using the step function.
    In every step the environnement and the list of goals are updated.
    The algorithm stops when there are no more goals to prove. In that
    case, it returns an environnement that allows to verify all goals.
*)
let solve (goals : dec) (rules : dec list) : environnement =
  let rec solve_aux (n : int) (env : environnement) (goals : term list) (rules : dec list)
    =
    match goals with
    (* there are no more goals to prove *)
    | [] -> env
    | g :: gs ->
      (match step n env (Goal [ g ]) rules with
      | Some (body', rules', env') -> solve_aux (n + 1) env' (body' @ gs) rules
      | None -> raise Not_solvable)
  in
  match goals with
  | Goal terms -> solve_aux 1 [] terms rules
  | _ -> raise (Invalid_argument "check function description")
;;

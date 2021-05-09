open Ast
open Unify

let assertions = ref []

(** solve (ch : choice list) starts with a list containing a choice
    with the goals, the list of rules, and an empty environnement.
    It then proves every goal using the step function. If the goal is
    verified, then the environnement, the list of goals, and the list of
    choices are updated. In the case that the the step function cannot
    verify the goal, the function backtracks and continues from a previous
    choice. The algorithm stops when there are no more goals to prove. In
    that case, it returns an environnement that allows to verify all goals.
*)
let solve (ch : choice list) : choice list * environnement =
  let rec solve_aux
      (ch : choice list)
      (goals : term list)
      (rules : dec list)
      (env : environnement)
      (n : int)
    =
    let backtrack (ch : choice list) =
      match ch with
      | (Goal goals, rules, env, n) :: choices -> solve_aux choices goals rules env n
      (*problem non-satisfiable*)
      | _ -> raise Solve.Not_solvable
    in
    match goals with
    | [] -> ch, env
    | g :: gs ->
      (match Solve.step n env (Goal [ g ]) rules with
      (* if there is a solution, we update the environnement and
      start again with the next goal. *)
      | Some (body', rules', env') ->
        let ch' = (Goal goals, rules', env, n) :: ch in
        solve_aux ch' (body' @ gs) !assertions env' (n + 1)
      (* if there is no solution we backtrack and look elsewhere. *)
      | None -> backtrack ch)
  in
  match ch with
  | (Goal goals, rules, env, n) :: chs -> solve_aux chs goals rules env n
  | _ -> raise (Invalid_argument "check function description")
;;

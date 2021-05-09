(*
#load "ast.cmo";;
#use "unify.ml";;
*)

open Ast

(** find (env: environnement) (x:string) returns the current binding
    of x in env, or returns Var x if no such binding exists.
*)
let find (env : environnement) (x : string) : term =
  try List.assoc x env with
  | Not_found -> Var x
;;

(** replace (env: environnement) (t: term) replaces in term t the
    substitutions specified in the environment env repeatedly until
    there are no more possible changes.

    Example:
      replace {Z -> f(W); W -> Y} p(Z, h(Z, W), f(W)) ->
      p(f(Y), h(f(Y), Y), f(Y))
*)
let rec replace (env : environnement) (t : term) : term =
  match t with
  | Var x ->
    let e = find env x in
    if Var x = e then e else replace env e
  | Func (f, args) -> Func (f, List.map (replace env) args)
;;

(** occurs (v: string) (t: term) returns true if variable v appears
    in term t, and false otherwise.
*)
let rec occurs (v : string) (t : term) : bool =
  match t with
  | Var x -> x = v
  | Func (_, args) -> List.exists (occurs v) args
;;

(** Not_unifiable is raised when the unification is not possible. *)
exception Not_unifiable

(** unify (env : environnement) (t1 : term) (t2 : term) finds an
    environnement env' such that (replace env' t1) = (replace env' t2).
    If the terms are not unfiable it raises the exception Not_unifiable.

    Example:
      unify [] p(Z, h(Z, Y), f(Y))  p(f(Y), h(f(Y), W), f(W))->
      {Z -> f(Y); Y -> W;}
*)
let rec unify (env : environnement) (t1 : term) (t2 : term) : environnement =
  match replace env t1, replace env t2 with
  | t1, t2 when t1 = t2 -> env
  | Func (f, args1), Func (g, args2) ->
    if f = g
    then (
      (* List.fold_left2 raises Invalid_argument if args1 and args2 have different lengths. *)
      try List.fold_left2 (fun env t1 t2 -> unify env t1 t2) env args1 args2 with
      | Invalid_argument _ -> raise Not_unifiable)
    else raise Not_unifiable (* Two functions with different names are not unifiable. *)
  | Var x, t | t, Var x ->
    (* A variable and a term that contains it are not unifiable. *)
    if occurs x t
    then raise Not_unifiable
    else (
      let env = List.remove_assoc x env in
      (x, t) :: env)
;;

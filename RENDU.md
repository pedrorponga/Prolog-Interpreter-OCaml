# Prolog Interpreter in OCaml

## Introduction

In this project a **Prolog** Interpreter has been built using the **OCaml** programming language. The interpreter includes **unification**, **backtracking**, and a simple toplevel which tries to mimic **SWI-Prolog**, the prolog REPL.

With regards to the **extension** done in Jalon 4, I have chosen to **find all solutions**.

## Structure

### ast.ml

This file includes the structure of the AST given as well as some printing methods. Also, the type `environnement` and the type `choice` are defined here:

```ocaml
(* environnement *)
type environnement = (string * term) list
```

```ocaml
(* choice is a data structure that encodes a choice context. *)
type choice = dec * dec list * environnement * int
```

Most remarkable is the appearance of an `int` in the `choice` type. It is there in order to avoid global variables and to reduce the magnitude of the numbers used in the renaming of rules.

### backtracker.ml

This file has the most general solver which, in case the first possible solution does not work, it can look further, backtracking into past states of the program.

The further search or continuation is performed in this line:

```ocaml
| None -> backtrack ch)
```

### interpret.ml

Here is where the different required interpreters can be found, i.e., `interprete0`, `interprete1`, `interprete2`, and `interprete3`.

### main.ml

Main contains the parsers to load a program from a file or from a string.

### solve.ml

This file contains the methods requested in Jalon2, specifically, `rename`, `step`, and `solve` without backtracking.

### unify.ml

In this file the methods for Jalon1: `replace`, `occurs`, and `unify` are implemented.

## How to use?

First of all, inside the folder `ocaml` it is possible to build the different executable files. These are `Jalon1.ml`, `Jalon2.ml`, `Jalon3.ml`, and `Interpreter.ml`. Also, make sure that **OUnit2** is installed. If it isn't, run `$ opam install ounit2`. Finally, change the path to the project in `ast.ml` by modifying `path`:

```ocaml
(* Project Path *)
let path =
  "your_path/pcomp-2021-projet-prolog/ocaml/"
;;
```

### Jalons

Below is an example of how to run one of the Jalons:

```console
$ make Jalon1
$ ./Jalon1
AST:
p(Z, h(Z, W), f(W)).
?- p(f(X), h(Y, f(a)), Y).
Substitution:
{Z -> f(X); Y -> f(X); W -> f(a); X -> f(a)}

AST:
p(a, X, f(g(Y))).
?- p(Z, f(Z), f(U)).
Substitution:
{Z -> a; X -> f(a); U -> g(Y)}

AST:
r(X, Y, h(Z)).
q(Z).
p(Z, h(Z, W), f(W)).
?- p(f(X), h(Y, f(a)), Y).
Substitution:
{Z -> f(X); Y -> f(X); W -> f(a); X -> f(a)}

AST:
r(X, Y, h(Z)).
q(Z).
p(Z, h(Z, W), f(W)).
?- r(f(a), g(b, f(a)), h(X)).
Substitution:
{X -> f(a); Y -> g(b, f(a)); Z -> f(a)}

AST:
r(X, Y, h(Z)).
q(Z).
p(Z, h(Z, W), f(W)).
?- q(f(a)).
Substitution:
{Z -> f(a)}
```

Notice that instead of doing `$ make Jalon1`, it is possible to just do `$ make`. This will build everything at once.
### Interpreter

The simplest way to use the interpreter is to start the toplevel with a file. However, it is also possible to load it in the toplevel once it is running by doing `?- [filename].`. A way to exit the toplevel is by running `?- halt.`. The user can ask for more solutions by writing `;` and, if there are any, the next will be printed. To stop looking for solutions, one must write `.`.

```console
$ make Interpreter
$ ./Interpreter "path_to_project/exemples/genealogie.pro"
Welcome to PRP-Prolog (version 0.0.1)
PRP-Prolog comes with ABSOLUTELY NO WARRANTY.
Please run ?- halt. or Ctrl-D to exit.

?- supervisor(church, X).
{X -> kleene};
{X -> turing};
{X -> scott};

?- [path_to_project/exemples/classification.pro].
File was loaded correctly.

?- animal(X).
{X1 -> X; X -> fourmi};
{X1 -> X; X2 -> X; X -> chat};

?- halt.
```

## Testing

In order to test the project, some simple tests have been created in `tests.ml` which check that intermediate functions behave as expected. For example, in order to check the unification of two terms, one needs to assert that replacing both terms with the substitution gives equality:

```ocaml
let t1 = parse_to_term "p(Z, h(Z, W), f(W))."
let t2 = parse_to_term "p(f(Y), h(f(Y), Y), f(Y))."
let unif_1 = unify [] t1 t2
let _ = assert (replace unif_1 t1 = replace unif_1 t2)
```

The external library **OUnit2** has also been used as it includes the method `OUnit2.assert_raises` which can be useful to check that two terms do not unify:

```ocaml
let t8 = parse_to_term "p(X, f(X), f(f(X)))."
let t9 = parse_to_term "p(f(f(Y)), Y, f(Y))."
let _ =
  let f () = unify [] t8 t9 in
  OUnit2.assert_raises Not_unifiable f
;;
```

Finally, to check the correct behaviour of Jalons one, two, and three, the method `test_interprete` is used:

```ocaml
let test_interprete interpreter f =
  let ast = parse_file (path ^ f) in
  let substitutions = interpreter ast in
  Printf.printf "AST:\n%s\n" (Ast.string_of_dec_list ast);
  List.iter
    (fun subst -> Printf.printf "Substitution:\n%s\n" (Ast.string_of_env subst))
    substitutions;
  Printf.printf "\n"
;;
```

Notice the use of the variable `path`. Hence, in order for this to function correctly, it needs to be modified as explained before.

In order to run these tests it is suggested doing so through `utop`. Just write these commands inside of `utop`:

```console
#require "ounit2";;
#load_rec "tests.cmo";;
#use "tests.ml";;
```

and all tests will be loaded. Note that other tests can be loaded into `tests.ml`.

To do more testing, it might be useful to create prolog files and add them in `Jalon1.ml`/`Jalon2.ml`/`Jalon3.ml`.

To test the toplevel, that is, Jalon 4; loading the programs directly into the terminal and running the tests interactively is recommended.

## Limitations

The main limitation is that this project doesn't include a way to run the `trace` command of **swipl**.
Also, even if files can be loaded with queries, these cannot be found anywhere in the file as they should be after all rules and facts.

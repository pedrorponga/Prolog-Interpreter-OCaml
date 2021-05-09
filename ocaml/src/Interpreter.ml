(* toplevel *)

open Main

(* get_rules_argv () gets rules from a file given as an argument of the program. *)
let get_rules_argv () =
  try
    let filename = Sys.argv.(1) in
    match Interpret.split (parse_file filename) with
    | rules, goals -> rules
  with
  | _ -> []
;;

(* get_rules_input filename gets rules from the file filename. *)
let get_rules_input filename =
  try
    match Interpret.split (parse_file filename) with
    | rules, goals -> rules
  with
  | _ -> raise Not_found
;;

let r = Str.regexp "^\\[.*\\]\\.$"
let ch = ref []

let interprete =
  Backtracker.assertions := !Backtracker.assertions @ get_rules_argv ();
  try
    print_string "Welcome to PRP-Prolog (version 0.0.1)\n";
    print_string "PRP-Prolog comes with ABSOLUTELY NO WARRANTY.\n";
    print_string "Please run ?- halt. or Ctrl-D to exit.\n\n";
    print_string "?- ";
    while true do
      let input = read_line () in
      if Str.string_match r input 0
      then (
        (try
           Backtracker.assertions
             := !Backtracker.assertions
                @ get_rules_input (String.sub input 1 (String.length input - 3));
           print_string "File was loaded correctly.\n"
         with
        | Not_found -> print_string "ERROR: file could not be loaded.\n");
        print_string "\n?- ")
      else (
        let goals = parse_string ("?-" ^ input) in
        match goals with
        (*?- halt. exits the toplevel *)
        | [ Goal [ Func ("halt", []) ] ] -> exit 0
        | [ goals ] ->
          (try
             let aux, solution =
               Backtracker.solve [ goals, !Backtracker.assertions, [], 1 ]
             in
             ch := aux;
             print_string (Ast.string_of_env solution);
             (try
                while !ch <> [] do
                  match read_line () with
                  | ";" ->
                    (try
                       let aux, solution = Backtracker.solve !ch in
                       ch := aux;
                       print_string (Ast.string_of_env solution)
                     with
                    | Solve.Not_solvable -> raise Exit)
                  | "." -> raise Exit
                  | c ->
                    print_string ("Unknown action: " ^ c ^ "\n");
                    raise Exit
                done
              with
             | Exit -> ());
             print_string "\n?- "
           with
          | Solve.Not_solvable -> print_string "\n?- ")
        | _ -> print_string "ERROR\n?- ")
    done
  with
  | End_of_file -> ()
;;

%{
  open Ast
%}

/* Terms */
%token <string> VAR
%token <string> ATOM

/* Symbols */

%token RULE            /* :- */
%token COMMA           /* , */
%token PERIOD          /* . */
%token LPAREN          /* ( */
%token RPAREN          /* ) */
%token GOAL            /* ?- */

%token EOF

/* Start  symbols */
%start<Ast.dec list> program

%%
program:
  p = list(clause); EOF                               { p }
  
clause:
  | p = predicate; PERIOD                             { Assert (p, []) }
  | p = predicate; RULE; pl = predicate_list; PERIOD  { Assert (p, pl) }
  | GOAL; pl = predicate_list; PERIOD                 { Goal pl }

predicate_list:
  | p = predicate                                     { [p] }
  | p = predicate; COMMA; pl = predicate_list         { p :: pl }

predicate:
  | a = ATOM                                          { Func (a, []) }
  | s = structure                                     { s }

structure:
  | a = ATOM; LPAREN; RPAREN                          { Func (a, []) }
  | a = ATOM; LPAREN; tl = term_list; RPAREN          { Func (a, tl) }

term_list:
  | t = term                                          { [t] }
  | t = term; COMMA; tl = term_list                   { t :: tl }

term:
  | a = ATOM                                          { Func (a, []) }
  | v = VAR                                           { Var v }
  | s = structure                                     { s }

%%

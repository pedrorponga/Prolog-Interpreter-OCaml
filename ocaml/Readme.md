# Instructions

## Introduction

Ce répertoire contient la version Ocaml de l'analyseur syntaxique (parseur)
Prolog pour bien démarrer le projet.

## Contenu

- `src` contient les sources Ocaml. Il s'agit d'un package `pcomp.prolog`.
- `src/ast.ml` contient la structure d'AST (arbre syntaxique abstrait). Un programme Prolog est de type `dec list`. C'est une liste de déclarations de type `dec` (les buts sont introduits par le constructeur `Goal` et les assertions par le constructeur `Assert`), contenant des terles de type `term` (les variables sont introduites par le constructeur `Var` et les prédicats par le constructeur `Func`). Chacun des types vient avec une fonction `string_of_...` que vous utiliserez pour l'affichage.
- `src/lexer.mll` contient la description d'un lexeur (qui permet de transformer la chaîne de caractères contenue dans un fichier en une suite de token qui sera passée au parsuer). Lorsque l'on fait `make`, le lexeur `src/lexer.ml` est généré automatiquement par l'outil `ocamllex` à partir du fichier `src/lexer.mll`.
- `src/parser.mly` contient la grammaire d'un parseur. Lorsque l'on fait `make`, l'outil `menhir` est utilisé pour générer automatiquement le parseur `src/parser.mll`.
- `src/main.ml` est une programme qui appelle le parseur pour lire les sources Prolog, les convertit en programmes de type `dec list`, et réaffiche le programme à l'écran.  Vous pourrez utiliser directement cette classe pour répondre aux différentes étapes du projet.programme et les afficher.
- `./projet` est un programme exécutable compilé à partir de `src/main.ml`
- `exemples` contient des exemples de programmes Prolog.

## Compilation

Lorsque vous taper `make` dans un `shell`, le  lexeur et le parseur sont générés automatiquement par l'outil `menhir` (qu'il vous faut installer via `opam install menhir`), puis le programme `./projet` est compilé à partir du fichier `src/main.ml` et de ses dépendances.

Ensuite `./projet` devrait fonctionner.

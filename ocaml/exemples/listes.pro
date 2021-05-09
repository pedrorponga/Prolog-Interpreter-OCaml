% Prolog a un type de données listes, similaire au type liste de Caml
% [X, Y, Z] désigne la liste à trois éléments
% [X | Y] désigne une liste dont l'élément de tête est X et la liste queue est Y
% Ici on se propose de définir les opérations de bases sur les listes
% Une liste est soit vide, soit la concaténation d'une tête et d'une liste.

list(empty).
list(concat(X, Xs)) :- list(Xs).


% element/2 element(X,Y) verifie si X est un element de la liste Y
element(X, concat(X,Xs)).
element(X, concat(Y,Ys)) :- element(X, Ys).

% prefix/2 prefix(X, Y) vérifie si X est une liste prefixe de la liste Y
prefix(empty, Ys).
prefix(concat(X,Xs), concat(X,Ys)) :- prefix(Xs,Ys).

% substitute/4 substitute(X, Y, L1, L2) si L2 est le résultat de la substitution dans L1 de toutes les occurences de X par Y
substitute(X, Y, empty, empty).
substitute(X, Y, concat(X,Xs), concat(Y,Ys)) :- substitute(X, Y, Xs, Ys).
substitute(X, Y, concat(Z,Xs), concat(Z,Ys)) :- substitute(X, Y, Xs, Ys).

% suffix/2 prefix(X, Y) vérifie si X est une liste suffixe de la liste Y
suffix(Xs, Xs).
suffix(Xs, concat(X,Ys)) :- suffix(Xs, Ys).

% append/3 append(X, Y, Z) vérifie si Z est la concaténation de X et Y
append(empty, Ys, Ys).
append(concat(X, Xs), Ys, concat(X, Zs)) :- append(Xs, Ys, Zs).

% reverse/3 reverse(X, Y) vérifie si Y est la liste "miroir" de X
reverse(empty, empty).
reverse(concat(X, Xs), Zs) :- reverse(Xs, Ys), append(Ys, concat(X, empty), Zs).

?- element(b, concat(a,concat(b,concat(c,empty)))). % true
?- element(X, concat(a,concat(b,concat(c, empty)))). % X = a; X = b; X = c
?- element(b, X). % X = concat(b, ?); X = concat(?, concat(b, ?)); ...
?- prefix(X, concat(a,concat(b,concat(c,empty)))).
% X = empty; X = concat(a, empty); X = concat(a,  concat(b, empty)); X = concat(a,  concat(b, concat(c, empty)))
?- substitute(a, x, concat(a, concat(b, concat(a, empty))), X).
% X = concat(x, concat(b, concat(x, empty))) ;
% X = concat(x, concat(b, concat(a, empty))) ;
% X = concat(a, concat(b, concat(x, empty))) ;
% X = concat(a, concat(b, concat(a, empty))) ;
?- suffix(X, concat(a, concat(b, concat(c, empty)))).
% X = concat(a, concat(b, concat(c, empty))) ;
% X = concat(b, concat(c, empty)) ;
% X = concat(c, empty) ;
% X = empty ;
?- append(concat(a, concat(b, concat(c, empty))), concat(d, concat(e, empty)), Z).
% Z = concat(a, concat(b, concat(c, concat(d, concat(e, empty))))).
?- reverse(concat(a, concat(b, concat(c, empty))), X).
% X = concat(c, concat(b, concat(a, empty))).

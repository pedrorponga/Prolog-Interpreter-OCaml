% Règles
%% Tous les insectes sont des animaux
animal(X) :-
    insecte(X).
%% Tous les mammifères sont des animaux
animal(X) :-
    mammifere(X).

%% Tous les félins sont des mammifères
mammifere(X) :-
    felin(X).


% Faits
%% Fourmi est un insecte
insecte(fourmi).

%% Chat est un félin
felin(chat).

location(felin(chat), france).
location(felin(tigre), laos).

location(X, europe) :-
    location(X, france).
location(X, europe) :-
    location(X, espagne).

?-insecte(fourmi).
?-animal(fourmi).
?-animal(chat).
?-location(felin(chat), france).
?-animal(X).

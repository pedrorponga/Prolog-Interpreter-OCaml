p(Z, h(Z, W), f(W)) :- r(X, XX), q(XX).
r(a, f(a)).
q(X).
?- p(f(X), h(Y, a), Y).
p(Z, h(Z, W), f(W)) :- r(X, XX), q(XX).
r(a, a).
q(a).
?- p(f(X), h(Y, a), Y), q(X).

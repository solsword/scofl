order(B, sentence(B, Clause)) :- beginning(B), sentence(B, Clause).
order(N+1, motive(S, Motive)) :-
  order(N, sentence(S, Clause)),
  motive(S, Motive).
order(N+2, sentence(r(S), Response)) :-
  order(N, sentence(S, Clause)),
  sentence(r(S), Response).
order(N+10, sentence(F, Follows)) :-
  order(N, sentence(S, Clause)),
  sentence(F, Follows),
  base_situation(S),
  next(S, F).

order(0, preamble(O, Sentence)) :- preamble(O, Sentence).
order(B, sentence(B, Clause)) :- beginning(B), sentence(B, Clause).
order(N+1, motive(S, Motive)) :-
  order(N, sentence(S, Clause)),
  motive(S, Motive).
order(N+2, motive(r(S), Motive)) :-
  order(N, sentence(S, Clause)),
  motive(r(S), Motive).
order(N+10, sentence(F, Follows)) :-
  order(N, sentence(S, Clause)),
  sentence(F, Follows),
  base_situation(S),
  next(S, F).

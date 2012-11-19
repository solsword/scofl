% Extra constraints:

% There should be at least two reactions:
:- 0 { some_reaction(S) } 1.

% Keep loves simple for now:
% TODO: Make love into a valid motivation.
:- situation(S, holds(loves, A, B)), not allied(A, B).

% Starting situation limits:

:- beginning(B), 3 { situation(B, holds(injured, C)) : character(C) }.
:- beginning(B), 2 { situation(B, holds(broken, I)) : item(I) }.
:-
  beginning(B),
  3 {
    situation(B, holds(loves, Lover, Loved))
    : character(Lover)
    : character(Loved)
  }.
:-
  beginning(B),
  2 {
    situation(B, holds(captured_by, Victim, Captor))
    : character(Victim)
    : character(Captor)
  }.

% Don't use any one action too much (travel, attack, and defend are the
% exceptions):
:-
  atype(Type),
  Type != travel, Type != attack, Type != defend,
  3 { action(S, Type) }.

% Don't repeat things:
:-
  situation(S),
  next(S,N),
  action(S, Act),
  action(N, Act),
  param(S, actor, Actor),
  param(N, actor, Actor),
  param(S, target, Target),
  param(N, target, Target),
  result(S, Result),
  result(N, Result).

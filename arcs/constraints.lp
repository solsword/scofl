% Extra constraints:

% There should be at least two reactions:
:- 0 { some_reaction(S) } 1.

% Limit the number of characters who start out injured:
:- beginning(B), 3 { situation(B, holds(injured, C)) : character(C) }.

% Likewise for captured_by:
%:-
%  beginning(B),
%  2 {
%    situation(B, holds(captured_by, Victim, Captor))
%    : character(Victim)
%    : character(Captor)
%  }.

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

% Action:
atype(capture).

% Parameters:
parameter(capture, 1, actor, character).
parameter(capture, 2, target, character).

% Valorization:
harmful(A, Victim) :- action(A, capture), param(A, target, Victim).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, capture).
precondition(A, competent(fight, Actor)) :-
  action(A, capture),
  param(A, actor, Actor).
precondition(A, incompetent(fight, Target)) :-
  action(A, capture),
  param(A, target, Target).
precondition(A, impossible) :-
  action(A, capture),
  param(A, target, Target),
  situation(A, holds(captured_by, Target, Anyone)).

% Reactions:
% <none>

% Effects:
_effect(A, causes(captured_by, Target, Actor)) :-
  action(A, capture),
  param(A, actor, Actor),
  param(A, target, Target).
_accident(A, causes(injured, Actor)) :-
  action(A, capture),
  param(A, actor, Actor).

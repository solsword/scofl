% Action:
atype(heal).

% Parameters:
parameter(heal, 1, actor, character).
parameter(heal, 2, target, character).

% Valorization:
helpful(A, Target) :- action(A, heal), param(A, target, Target).

% Preconditions:
reflexive_allowed(heal).
special_precondition(A, actor_colocated_with_target) :- action(A, heal).
precondition(A, competent(use_item, Actor)) :-
  action(A, heal),
  param(A, actor, Actor).
precondition(A, holds(injured, Target)) :-
  action(A, heal),
  param(A, target, Target).

% Reactions:
% <none>

% Effects:
_effect(A, causes(healthy, Target)) :-
  action(A, heal),
  param(A, target, Target).

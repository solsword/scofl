% Action:
atype(kill).

% Parameters:
parameter(kill, 1, actor, character).
parameter(kill, 2, target, character).

% Valorization:
harmful(A, Victim) :- action(A, kill), param(A, target, Victim).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, kill).
precondition(A, competent(fight, Actor)) :-
  action(A, kill),
  param(A, actor, Actor).
precondition(A, incompetent(fight, Target)) :-
  action(A, kill),
  param(A, target, Target).

% Reactions:
% <none>

% Effects:
_effect(A, causes(dead, Target)) :-
  action(A, kill),
  param(A, target, Target).
_accident(A, causes(injured, Actor)) :-
  action(A, kill),
  param(A, actor, Actor).

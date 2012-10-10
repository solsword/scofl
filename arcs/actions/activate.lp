% Action:
atype(activate).

% Parameters:
parameter(activate, 1, actor, character).
parameter(activate, 2, target, item).

% Valorization:
% <none>

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, activate).
special_precondition(A, actor_controls_target_item) :- action(A, activate).
precondition(A, competent(use_item, Actor)) :-
  action(A, activate),
  param(A, actor, Actor).
precondition(A, possible(activate, Target)) :-
  action(A, activate),
  param(A, target, Target).

% Reactions:
% <none>

% Effects:
_accident(A, causes(injured, Actor)) :-
  action(A, activate),
  param(A, actor, Actor).

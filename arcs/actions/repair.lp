% Action:
atype(repair).

% Parameters:
parameter(repair, 1, actor, character).
parameter(repair, 2, target, item).

% Valorization:
helpful(A, Owner) :-
  action(A, repair),
  param(A, target, Item),
  situation(A, holds(owned_by, Item, Owner)).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, repair).
special_precondition(A, actor_controls_target_item) :- action(A, repair).
precondition(A, competent(use_item, Actor)) :-
  action(A, repair),
  param(A, actor, Actor).
precondition(A, possible(repair, Target)) :-
  action(A, repair),
  param(A, target, Target).

% Reactions:
% <none>

% Effects:
_effect(A, causes(whole, Target)) :-
  action(A, repair),
  param(A, target, Target).
_accident(A, causes(destroyed, Target)) :-
  action(A, repair),
  param(A, target, Target).
_accident(A,
  both(
    causes(uncontrolled, Target),
    causes(not_carried, Target)
  )
) :-
  action(A, repair),
  param(A, target, Target).

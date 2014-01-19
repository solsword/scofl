% Action:
atype(obtain).

% Parameters:
parameter(obtain, 1, actor, character).
parameter(obtain, 2, target, item).

% Valorization:
helpful(S, Actor) :-
  action(S, obtain),
  param(S, actor, Actor).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, obtain).
precondition(A, competent(use_item, Actor)) :-
  action(A, obtain),
  param(A, actor, Actor).
precondition(A, holds(unowned, Target)) :-
  action(A, obtain),
  param(A, target, Target).

% Reactions:
_reaction(R, active, rxn(obtain, Other, Target)) :-
  action(R, obtain),
  param(R, target, Target),
  character(Other).

% Effects:
_effect(
  A,
  both(
    causes(owned_by, Target, Actor),
    causes(controlled_by, Target, Actor)
  )
) :-
  action(A, obtain),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, impossible(carry, Target)).
_effect(
  A,
  both(
    causes(owned_by, Target, Actor),
    both(
      causes(controlled_by, Target, Actor),
      causes(carried_by, Target, Actor)
    )
  )
) :-
  action(A, obtain),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, possible(carry, Target)).
_accident(A, causes(broken, Target)) :-
  action(A, obtain),
  param(A, target, Target).

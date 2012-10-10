% Action:
atype(steal).

% Parameters:
parameter(steal, 1, actor, character).
parameter(steal, 2, target, item).

% Valorization:
harmful(A, Victim) :-
  action(A, steal),
  param(A, target, Target),
  situation(A, holds(controlled_by, Target, Victim)).
harmful(A, Owner) :-
  action(A, steal),
  param(A, target, Target),
  situation(A, holds(owned_by, Target, Owner)).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, steal).
precondition(A, competent(use_item, Actor)) :-
  action(A, steal),
  param(A, actor, Actor).
precondition(A, competent(fight, Actor)) :-
  action(A, steal),
  param(A, actor, Actor),
  situation(A, impossible(carry, Target)),
  situation(A, holds(controlled_by, Target, Someone)).
precondition(A, possible(steal, Target)) :-
  action(A, steal),
  param(A, target, Target).
precondition(A, impossible) :-
  action(A, steal),
  param(A, target, Target),
  situation(A, holds(uncontrolled, Target)).
precondition(A, impossible) :-
  action(A, steal),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, holds(controlled_by, Target, Actor)).

% Reactions:
_reaction(R, active, rxn(steal, Other, Target)) :-
  action(R, activate),
  param(R, target, Target),
  character(Other).
_reaction(R, active, rxn(steal, Other, Target)) :-
  action(R, break),
  param(R, target, Target),
  character(Other).
_reaction(R, active, rxn(steal, Other, Target)) :-
  action(R, destroy),
  param(R, target, Target),
  character(Other).
_reaction(R, active, rxn(steal, Other, Item)) :-
  action(R, give),
  param(R, item, Item),
  character(Other).

% Effects:
_effect(A, causes(controlled_by, Target, Actor)) :-
  action(A, steal),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, impossible(carry, Target)).
_effect(
  A,
  both(
    causes(controlled_by, Target, Actor),
    causes(carried_by, Target, Actor)
  )
) :-
  action(A, steal),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, possible(carry, Target)).
_accident(A, causes(injured, Actor)) :-
  action(A, steal),
  param(A, actor, Actor),
  param(A, actor, Actor).
_accident(A, causes(broken, Target)) :-
  action(A, steal),
  param(A, target, Target).
_accident(A,
  both(
    causes(uncontrolled, Target),
    causes(not_carried, Target)
  )
) :-
  action(A, steal),
  param(A, target, Target).

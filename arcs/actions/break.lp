% Action:
atype(break).

% Parameters:
parameter(break, 1, actor, character).
parameter(break, 2, target, item).

% Valorization:
harmful(A, Victim) :-
  action(A, break),
  param(A, target, Target),
  situation(A, holds(controlled_by, Target, Victim)),
  situation(A, holds(owned_by, Target, Owner)),
  allied(Victim, Owner).
harmful(A, Owner) :-
  action(A, break),
  param(A, target, Target),
  situation(A, holds(owned_by, Target, Owner)).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, break).
% (even something someone else controls can be broken)
precondition(A, competent(use_item, Actor)) :-
  action(A, break),
  param(A, actor, Actor).
precondition(A, possible(break, Target)) :-
  action(A, break),
  param(A, target, Target).

% Reactions:
_reaction(R, active, rxn(break, Other, Target)) :-
  action(R, activate),
  param(R, target, Target),
  character(Other).
_reaction(R, passive, rxn(break, Other, Target)) :-
  action(R, obtain),
  param(R, target, Target),
  character(Other).
_reaction(R, passive, rxn(break, Victim, Target)) :-
  action(R, steal),
  param(R, target, Target),
  situation(R, holds(carried_by, Target, Victim)).
_reaction(R, passive, rxn(break, Other, Item)) :-
  action(R, give),
  param(R, item, Item),
  character(Other).

% Effects:
_effect(A, causes(broken, Target)) :-
  action(A, break),
  param(A, target, Target).
_accident(A, causes(injured, Actor)) :-
  action(A, break),
  param(A, actor, Actor).
_accident(A,
  both(
    causes(uncontrolled, Target),
    causes(not_carried, Target)
  )
) :-
  action(A, break),
  param(A, target, Target),
  param(A, actor, Actor),
  situation(A, holds(controlled_by, Target, Actor)).

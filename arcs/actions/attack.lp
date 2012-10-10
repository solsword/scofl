% Action:
atype(attack).

% Parameters:
parameter(attack, 1, actor, character).
parameter(attack, 2, target, character).

% Valorization:
harmful(A, Victim) :- action(A, attack), param(A, target, Victim).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, attack).
precondition(A, competent(fight, Actor)) :-
  action(A, attack),
  param(A, actor, Actor).
precondition(A, competent(fight, Target)) :-
  base_situation(A),
  action(A, attack),
  param(A, target, Target).

% Reactions:
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, activate),
  param(R, actor, Actor),
  character(Other).
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, break),
  param(R, actor, Actor),
  character(Other).
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, destroy),
  param(R, actor, Actor),
  character(Other).
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, repair),
  param(R, actor, Actor),
  character(Other).
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, obtain),
  param(R, actor, Actor),
  character(Other).
_reaction(R, active, rxn(attack, Other, Actor)) :-
  action(R, heal),
  param(R, actor, Actor),
  param(R, target, Target),
  character(Other),
  Other != Target.

% Effects:
_effect(A, causes(injured, Target)) :-
  action(A, attack),
  param(A, target, Target).
_accident(A, causes(injured, Actor)) :-
  action(A, attack),
  param(A, actor, Actor).

% Action:
atype(defend).

% Parameters:
parameter(defend, 1, actor, character).
parameter(defend, 2, opponent, character).
parameter(defend, 3, target, character).

% Valorization:
helpful(A, Beneficiary) :- action(A, defend), param(A, target, Beneficiary).
harmful(A, Opponent) :- action(A, defend), param(A, opponent, Opponent).

% Preconditions:
reflexive_allowed(defend).
special_precondition(A, actor_near_target) :- action(A, defend).
precondition(A, competent(fight, Actor)) :-
  action(A, defend),
  param(A, actor, Actor).

% Reactions:
reaction_only(defend).
_reaction(R, active, rxn(defend, Other, Opponent, Victim)) :-
  action(R, attack),
  param(R, actor, Opponent),
  param(R, target, Victim),
  character(Other).
_reaction(R, active, rxn(defend, Other, Opponent, Victim)) :-
  action(R, capture),
  param(R, actor, Opponent),
  param(R, target, Victim),
  character(Other).
_reaction(R, active, rxn(defend, Other, Opponent, Victim)) :-
  action(R, kill),
  param(R, actor, Opponent),
  param(R, target, Victim),
  character(Other).

% Effects:
_permitted(A, causes(injured, Opponent)) :-
  action(A, defend),
  param(A, opponent, Opponent).
_accident(A, causes(injured, Actor)) :-
  action(A, defend),
  param(A, actor, Actor).

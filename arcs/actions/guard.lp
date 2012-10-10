% Action:
atype(guard).

% Parameters:
parameter(guard, 1, actor, character).
parameter(guard, 2, opponent, character).
parameter(guard, 3, target, item).

% Valorization:
harmful(A, Opponent) :- action(A, guard), param(A, opponent, Opponent).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, guard).
precondition(A, competent(fight, Actor)) :-
  action(A, guard),
  param(A, actor, Actor).

% Reactions:
reaction_only(guard).
_reaction(R, active, rxn(guard, Other, Opponent, Target)) :-
  action(R, obtain),
  param(R, actor, Opponent),
  param(R, target, Target),
  character(Other).
_reaction(R, active, rxn(guard, Other, Opponent, Target)) :-
  action(R, break),
  param(R, actor, Opponent),
  param(R, target, Target),
  character(Other).
_reaction(R, active, rxn(guard, Other, Opponent, Target)) :-
  action(R, steal),
  param(R, actor, Opponent),
  param(R, target, Target),
  character(Other).

% Effects:
_permitted(A, causes(injured, Opponent)) :-
  action(A, guard),
  param(A, opponent, Opponent).
_accident(A, causes(injured, Actor)) :-
  action(A, guard),
  param(A, actor, Actor).

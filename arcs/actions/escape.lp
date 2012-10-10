% Action:
atype(escape).

% TODO: How to prevent escape?

% Parameters:
parameter(escape, 1, actor, character).
parameter(escape, 2, opponent, character).
parameter(escape, 3, destination, location).

% Valorization:
helpful(A, Actor) :- action(A, escape), param(A, actor, Actor).
harmful(A, Opponent) :- action(A, escape), param(A, opponent, Opponent).

% Preconditions:
precondition(A, holds(accessible_from, Start, Destination)) :-
  action(A, escape),
  param(A, actor, Actor),
  param(A, destination, Destination),
  situation(A, holds(at, Actor, Start)).
precondition(A, holds(captured_by, Actor, Opponent)) :-
  action(A, escape),
  param(A, actor, Actor),
  param(A, opponent, Opponent).
precondition(A, impossible) :-
  action(A, escape),
  param(A, actor, Actor),
  param(A, destination, Destination),
  situation(A, holds(at, Actor, Destination)).

% Reactions:
_reaction(
  R,
  active,
  rxn(escape, Victim, Opponent, Destination)
) :-
  action(R, attack),
  param(R, actor, Opponent),
  param(R, target, Victim),
  location(Destination).
_reaction(
  R,
  active,
  rxn(escape, Victim, Opponent, Destination)
) :-
  action(R, kill),
  param(R, actor, Opponent),
  param(R, target, Victim),
  location(Destination).
_reaction(
  R,
  active,
  rxn(escape, Victim, Opponent, Destination)
) :-
  action(R, steal),
  param(R, actor, Opponent),
  param(R, target, Item),
  situation(R, holds(carried_by, Item, Victim)),
  location(Destination).

% Effects:
_effect(
  A,
  both(
    causes(at, Actor, Destination),
    causes(free, Actor)
  )
) :-
  action(A, escape),
  param(A, actor, Actor),
  param(A, destination, Destination).
_accident(
  A,
  causes(injured, Actor)
) :-
  action(A, escape),
  param(A, actor, Actor).

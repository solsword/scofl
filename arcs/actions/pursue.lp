% Action:
atype(pursue).

% Parameters:
parameter(pursue, 1, actor, character).
parameter(pursue, 2, target, character).
parameter(pursue, 3, destination, location).
parameter(pursue, 4, lost, location).

% Valorization:
harmful(A, Target) :- action(A, pursue), param(A, target, Target).

% Preconditions:
special_precondition(A, actor_near_target) :- action(A, pursue).
precondition(A, competent(fight, Actor)) :- % more strenuous than travelling
  action(A, pursue),
  param(A, actor, Actor).

% Reactions:
reaction_only(pursue).
_reaction(
  R,
  passive,
  rxn(pursue, Actor, Target, Destination, Lost)
) :-
  action(R, travel),
  param(R, actor, Target),
  situation(R, holds(at, Target, Start)),
  param(R, destination, Destination),
  character(Actor),
  location(Lost),
  Lost != Start, Lost != Destination.
_reaction(
  R,
  passive,
  rxn(pursue, Actor, Target, Destination, Lost)
) :-
  action(R, escape),
  param(R, actor, Target),
  situation(R, holds(at, Target, Start)),
  param(R, destination, Destination),
  character(Actor),
  location(Lost),
  Lost != Start, Lost != Destination.

% Effects:
_effect(A, causes(at, Actor, Destination)) :-
  action(A, pursue),
  param(A, actor, Actor),
  param(A, destination, Destination).
_accident(A, causes(at, Actor, Lost)) :-
  action(A, pursue),
  param(A, actor, Actor),
  param(A, lost, Lost).

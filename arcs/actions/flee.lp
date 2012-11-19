% Action:
atype(flee).

% Parameters:
parameter(flee, 1, actor, character).
parameter(flee, 2, destination, location).
parameter(flee, 3, lost, location).

params_must_differ(flee, destination, lost).

% Valorization:
% <none>

% Preconditions:
precondition(A, competent(travel, Actor)) :-
  action(A, flee),
  param(A, actor, Actor).
precondition(A, holds(accessible_from, Start, Destination)) :-
  action(A, flee),
  param(A, actor, Actor),
  situation(A, holds(at, Actor, Start)),
  param(A, destination, Destination).

% Reactions:
reaction_only(flee).
_reaction(R, active, rxn(flee, Target, Elsewhere, Random)) :-
  action(R, attack),
  param(R, target, Target),
  situation(R, holds(at, Target, Start)),
  location(Elsewhere),
  location(Random),
  Elsewhere != Start, Elsewhere != Random, Random != Start.
_reaction(R, active, rxn(flee, Target, Elsewhere, Random)) :-
  action(R, capture),
  param(R, target, Target),
  situation(R, holds(at, Target, Start)),
  location(Elsewhere),
  location(Random),
  Elsewhere != Start, Elsewhere != Random, Random != Start.
_reaction(R, active, rxn(flee, Target, Elsewhere, Random)) :-
  action(R, kill),
  param(R, target, Target),
  situation(R, holds(at, Target, Start)),
  location(Elsewhere),
  location(Random),
  Elsewhere != Start, Elsewhere != Random, Random != Start.
_reaction(R, active, rxn(flee, Victim, Elsewhere, Random)) :-
  action(R, break),
  param(R, target, Target),
  situation(R, holds(carried_by, Target, Victim)),
  situation(R, holds(at, Victim, Start)),
  location(Elsewhere),
  location(Random),
  Elsewhere != Start, Elsewhere != Random, Random != Start.
_reaction(R, active, rxn(flee, Victim, Elsewhere, Random)) :-
  action(R, steal),
  param(R, target, Target),
  situation(R, holds(carried_by, Target, Victim)),
  situation(R, holds(at, Victim, Start)),
  location(Elsewhere),
  location(Random),
  Elsewhere != Start, Elsewhere != Random, Random != Start.

% Effects:
_effect(A, causes(at, Actor, Destination)) :-
  action(A, flee),
  param(A, actor, Actor),
  param(A, destination, Destination).
_accident(A, causes(at, Actor, Lost)) :-
  action(A, flee),
  param(A, actor, Actor),
  param(A, lost, Lost).

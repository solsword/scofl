% Action:
atype(travel).

% Parameters:
parameter(travel, 1, actor, character).
parameter(travel, 2, destination, location).
parameter(travel, 3, lost, location).

% Valorization:
% <none>

% Preconditions:
precondition(A, competent(travel, Actor)) :-
  action(A, travel),
  param(A, actor, Actor).
precondition(A, holds(accessible_from, Start, Destination)) :-
  action(A, travel),
  param(A, actor, Actor),
  situation(A, holds(at, Actor, Start)),
  param(A, destination, Destination).

% Reactions:
% <none>

% Effects:
_effect(A, causes(at, Actor, Destination)) :-
  action(A, travel),
  param(A, actor, Actor),
  param(A, destination, Destination).
_accident(A, causes(at, Actor, Lost)) :-
  action(A, travel),
  param(A, actor, Actor),
  param(A, lost, Lost).

% Choose action types and parameters:

1 { action(S, Type) : atype(Type) } 1 :- base_situation(S), active_situation(S).

some_action(S) :- action(S, Any).

1 { param(S, Name, C) : character(C) } 1 :-
  action(S, Type), parameter(Type, N, Name, character).

1 { param(S, Name, I) : item(I) } 1 :-
  action(S, Type), parameter(Type, N, Name, item).

1 { param(S, Name, L) : location(L) } 1 :-
  action(S, Type), parameter(Type, N, Name, location).

% Reflexivity restriction:
:-
  action(S, Type),
  param(S, actor, chr(C)),
  param(S, target, chr(C)),
  not reflexive_allowed(Type).

% Reaction-only restriction:
:-
  action(S, Type),
  reaction_only(Type),
  not reaction_situation(S).

% No reflexive reactions:
:-
  param(S, actor, chr(C)),
  param(r(S), actor, chr(C)).

% Optionally choose a reaction:

:- situation(S), 2 { reaction(S, Type, Rxn) }.

{ reaction(S, Type, Rxn) } :-
  _reaction(S, Type, Rxn),
  base_situation(S).

some_reaction(S) :- reaction(S, Type, Any).

% Reactions share state with normal actions:

situation(r(S), Cond) :- situation(S, Cond), situation(r(S)).

% Support for up to five specified parameters:

action(r(S), Act) :- reaction(S, Type, rxn(Act, P1)).
param(r(S), Name, P1) :-
  parameter(Act, 1, Name, X),
  reaction(S, Type, rxn(Act, P1)).
action(r(S), Act) :- reaction(S, Type, rxn(Act, P1, P2)).
param(r(S), Name, P1) :-
  parameter(Act, 1, Name, X),
  reaction(S, Type, rxn(Act, P1, P2)).
param(r(S), Name, P2) :-
  parameter(Act, 2, Name, X),
  reaction(S, Type, rxn(Act, P1, P2)).
action(r(S), Act) :- reaction(S, Type, rxn(Act, P1, P2, P3)).
param(r(S), Name, P1) :-
  parameter(Act, 1, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3)).
param(r(S), Name, P2) :-
  parameter(Act, 2, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3)).
param(r(S), Name, P3) :-
  parameter(Act, 3, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3)).
action(r(S), Act) :- reaction(S, Type, rxn(Act, P1, P2, P3, P4)).
param(r(S), Name, P1) :-
  parameter(Act, 1, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4)).
param(r(S), Name, P2) :-
  parameter(Act, 2, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4)).
param(r(S), Name, P3) :-
  parameter(Act, 3, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4)).
param(r(S), Name, P4) :-
  parameter(Act, 4, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4)).
action(r(S), Act) :- reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).
param(r(S), Name, P1) :-
  parameter(Act, 1, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).
param(r(S), Name, P2) :-
  parameter(Act, 2, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).
param(r(S), Name, P3) :-
  parameter(Act, 3, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).
param(r(S), Name, P4) :-
  parameter(Act, 4, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).
param(r(S), Name, P5) :-
  parameter(Act, 5, Name, X),
  reaction(S, Type, rxn(Act, P1, P2, P3, P4, P5)).

% An error if we can't convert the reaction into an action:

internal_error("Unsupported reaction (more than 5 parameters?).", S, Rxn) :-
  reaction(S, Type, Rxn), not some_action(r(S)).

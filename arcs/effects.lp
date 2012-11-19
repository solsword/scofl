% Three types of effect possibilities:
% _effect, _permitted, and _accident

% TODO: Add things like moving defenders/rescuers even on failed attempts.

has_effect(S) :- _effect(S, E).
has_accident(S) :- _accident(S, A).

:- has_effect(S), 0 { chosen(_effect(S, Effect)) } 0.
:- has_effect(S), 2 { chosen(_effect(S, Effect)) }.

:- situation(S), 2 { chosen(_permitted(S, Effect)) }.

:- has_accident(S), 0 { chosen(_accident(S, Effect)) } 0.
:- has_accident(S), 2 { chosen(_accident(S, Effect)) }.

% Choose an effect from the effects pool:
{ chosen(_effect(S, Effect)) } :-
  _effect(S, Effect).

% Likewise for accidents:
{ chosen(_accident(S, Effect)) } :-
  _accident(S, Effect).

% Permitted results may or may not occur (but only one will occur if one does):
{ chosen(_permitted(S, Effect)) } :-
  _permitted(S, Effect).

% Chosen things become effects if the result is appropriate:
effect(S, Effect, intentional) :-
  chosen(_effect(S, Effect)),
  result(S, success).

effect(S, Effect, intentional) :-
  chosen(_permitted(S, Effect)),
  result(S, success).

effect(S, Effect, accidental) :-
  chosen(_accident(S, Effect)),
  result(S, accident).

% Break down paired effects into their individual components (which might
% themselves be pairs, and so on, of course).
effect(S, E1, Intent) :- effect(S, both(E1, E2), Intent).
effect(S, E2, Intent) :- effect(S, both(E1, E2), Intent).

% Label as compound all (achievable) compound effects (obivously there are
% infinite theoretical compound effects):
compound(both(X, Y)) :- effect(S, both(X, Y), Intent).

% Effects influence state:
% (inertia is handled in states.lp)

situation(N, State) :-
  effect(S, Effect, Intent),
  result_of(Effect, State),
  next(S, N).

result_of(causes(Predicate, Subject), holds(Predicate, Subject)) :-
  state(State, Subject),
  _value(State, Predicate).

result_of(causes(Predicate, Subject), holds(Predicate, Subject)) :-
  relation(Rel, Subject),
  absence(Rel, Subject, Predicate).

result_of(
  causes(Predicate, Subject, Object),
  holds(Predicate, Subject, Object)
) :-
  relation(Predicate, Subject),
  _object(Predicate, Subject, Object).

internal_error("Invalid effect.", S, Effect) :-
  effect(S, Effect, Intent),
  not compound(Effect),
  0 { result_of(Effect, Anything) } 0.

% TODO: Add support for wider causes (would need wider states as well)?

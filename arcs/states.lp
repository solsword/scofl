% Inertia:

{ situation(N, holds(Predicate, Subject)) } :-
  situation(S, holds(Predicate, Subject)),
  next(S, N).

{ situation(N, holds(Predicate, Subject, Object)) } :-
  situation(S, holds(Predicate, Subject, Object)),
  next(S, N).

% TODO: Add support for wider states (would need wider causes as well)?
internal_error("State too wide.", S, Predicate, Subject) :-
  situation(S, holds(Predicate, Subject, Object, IndirectObject)).

% States:

stype(Type) :- _value(State, Type).

:-
  situation(S),
  state(State, Subject),
  0 {
    situation(S, holds(Val, Subject)) : _value(State, Val)
  } 0.

:-
  situation(S),
  state(State, Subject),
  2 {
    situation(S, holds(Val, Subject)) : _value(State, Val)
  }.

1 {
  situation(B, holds(Val, Subject)) : _initial(State, Val)
} 1 :- beginning(B), state(State, Subject).

% Relations:

rtype(Type) :- relation(Type, Subject).

has_absence(Rel, Subject) :- absence(Rel, Subject, Anything).

internal_error(
  "Required relationship defines absence.",
  Rel,
  Subject
) :-
  relation(Rel, Subject),
  required(Rel, Subject),
  has_absence(Rel, Subject).

internal_error(
  "Non-required relationship with no absence defined.",
  Rel,
  Subject
) :-
  relation(Rel, Subject),
  not required(Rel, Subject),
  not has_absence(Rel, Subject).

:-
  situation(S),
  relation(Rel, Subject),
  absence(Rel, Subject, Absence),
  0 {
    situation(S, holds(Absence, Subject)),
    situation(S, holds(Rel, Subject, Object)) : _object(Rel, Subject, Object)
  } 0.

:-
  situation(S),
  relation(Rel, Subject),
  absence(Rel, Subject, Absence),
  situation(S, holds(Absence, Subject)),
  1 {
    situation(S, holds(Rel, Subject, Object)) : _object(Rel, Subject, Object)
  }.

:-
  situation(S),
  relation(Rel, Subject),
  required(Rel, Subject),
  0 {
    situation(S, holds(Rel, Subject, Object)) : _object(Rel, Subject, Object)
  } 0.

:-
  situation(S),
  relation(Rel, Subject),
  singular(Rel, Subject),
  2 {
    situation(S, holds(Rel, Subject, Object)) : _object(Rel, Subject, Object)
  }.

1 {
  situation(B, holds(Absence, Subject)),
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} 1 :-
  beginning(B),
  relation(Rel, Subject),
  not required(Rel, Subject),
  absence(Rel, Subject, Absence),
  _initially_absent(Rel, Subject),
  singular(Rel, Subject).

1 {
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} 1 :-
  beginning(B),
  relation(Rel, Subject),
  not required(Rel, Subject),
  absence(Rel, Subject, Absence),
  not _initially_absent(Rel, Subject),
  singular(Rel, Subject).

1 {
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} 1 :-
  beginning(B),
  relation(Rel, Subject),
  required(Rel, Subject),
  singular(Rel, Subject).

1 {
  situation(B, holds(Absence, Subject)),
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} :-
  beginning(B),
  relation(Rel, Subject),
  absence(Rel, Subject, Absence),
  _initially_absent(Rel, Subject),
  not required(Rel, Subject),
  not singular(Rel, Subject).

1 {
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} :-
  beginning(B),
  relation(Rel, Subject),
  absence(Rel, Subject, Absence),
  not _initially_absent(Rel, Subject),
  not required(Rel, Subject),
  not singular(Rel, Subject).


1 {
  situation(B, holds(Rel, Subject, Object)) : _initial(Rel, Subject, Object)
} :-
  beginning(B),
  relation(Rel, Subject),
  required(Rel, Subject),
  not singular(Rel, Subject).

% Dependence:

:-
  0 { situation(S, holds(Other, Subject)) } 0,
  situation(S, holds(State, Subject)),
  state_depends(State, Other).

% TODO: Test this! (might not work)
:-
  state_depends_any(State, Some),
  0 {
    situation(S, holds(Other, Subject)) : state_depends_any(State, Other)
  } 0,
  situation(S, holds(State, Subject)).

:-
  0 { situation(S, holds(Other, Subject, Any)) } 0,
  situation(S, holds(Rel, Subject, Object)),
  rel_depends_any(Rel, Other, Subject).

:-
  0 { situation(S, holds(Other, Subject, Any)) } 0,
  situation(S, holds(Rel, Subject, Any)),
  rel_depends_same(Rel, Other, Subject).

:-
  rel_depends_state(Rel, State, Subject),
  0 { situation(S, holds(State, Subject)) } 0,
  situation(S, holds(Rel, Subject, Object)).

:-
  rel_depends_any_state(Rel, Some, Subject),
  0 {
    situation(S, holds(State, Subject))
    : rel_depends_any_state(Rel, State, Subject)
  } 0,
  situation(S, holds(Rel, Subject, Object)).

:-
  special_depends(colocated, Rel, Subject, Object),
  situation(S, holds(Rel, Subject, Object)),
  situation(S, holds(at, Subject, Location)),
  situation(S, holds(at, Object, Elsewhere)),
  Location != Elsewhere.

% TODO: More graceful dependencies?
% TODO: More dependency types (e.g. state_depends_rel etc.)?

% Possibilities:

situation(S, impossible(Affordance, Target)) :-
  situation(S),
  affordance(Affordance, Target),
  1 { requires_any(Affordance, Target, Cond) },
  0 { situation(S, Cond) : requires_any(Affordance, Target, Cond) } 0.

situation(S, impossible(Affordance, Target)) :-
  situation(S),
  affordance(Affordance, Target),
  requires_all(Affordance, Target, Cond),
  not situation(S, Cond).

situation(S, possible(Affordance, Target)) :-
  situation(S),
  affordance(Affordance, Target),
  not situation(S, impossible(Affordance, Target)).

% Competencies:
% TODO: allow for multiple requirement pools?

situation(S, incompetent(Competence, Target)) :-
  situation(S),
  competence(Competence, Target),
  1 { requires_any(Competence, Target, Cond) },
  0 { situation(S, Cond) : requires_any(Competence, Target, Cond) } 0.

situation(S, incompetent(Competence, Target)) :-
  situation(S),
  competence(Competence, Target),
  requires_all(Competence, Target, Cond),
  not situation(S, Cond).

situation(S, competent(Competence, Target)) :-
  situation(S),
  competence(Competence, Target),
  not situation(S, incompetent(Competence, Target)).

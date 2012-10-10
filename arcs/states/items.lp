% States:
%  [condition]
%    whole broken destroyed
%  [posession]
%    owned_by controlled_by carried_by
%    unowned uncontrolled not_carried

state(condition, I) :- item(I).
_value(condition, whole; broken; destroyed).
_initial(condition, whole; broken).

relation(owned_by, I) :- item(I).
singular(owned_by, I) :- item(I).
absence(owned_by, I, unowned) :- item(I).
_object(owned_by, I, C) :- item(I), character(C).
_initial(owned_by, I, C) :- item(I), character(C).
_initially_absent(owned_by, I) :- item(I).

relation(controlled_by, I) :- item(I).
singular(controlled_by, I) :- item(I).
absence(controlled_by, I, uncontrolled) :- item(I).
_object(controlled_by, I, C) :- item(I), character(C).
_initial(controlled_by, I, C) :- item(I), character(C).
_initially_absent(controlled_by, I) :- item(I).
rel_depends_any(controlled_by, owned_by, I) :- item(I).
rel_depends_any_state(controlled_by, whole, I) :- item(I).
rel_depends_any_state(controlled_by, broken, I) :- item(I).
special_depends(colocated, controlled_by, Subject, Object) :-
  _object(controlled_by, Subject, Object).

relation(carried_by, I) :- item(I).
singular(carried_by, I) :- item(I).
absence(carried_by, I, not_carried) :- item(I).
_object(carried_by, I, C) :- item(I), character(C).
_initial(carried_by, I, C) :- item(I), character(C).
_initially_absent(carried_by, I) :- item(I).
rel_depends_same(carried_by, controlled_by, I) :- item(I).
rel_depends_any_state(carried_by, whole, I) :- item(I).
rel_depends_any_state(carried_by, broken, I) :- item(I).
special_depends(colocated, carried_by, Subject, Object) :-
  _object(carried_by, Subject, Object).

% Being carried causes movement:
effect(S, causes(at, Item, Destination), Intent) :-
  situation(S, holds(carried_by, Item, Character)),
  situation(N, holds(carried_by, Item, Character)),
  next(S, N),
  effect(S, causes(at, Character, Destination), Intent).

% Affordances:
%  activate break repair carry destroy steal

affordance(activate, I) :- item(I).
requires_all(activate, I, holds(whole, I)) :- item(I).

affordance(break, I) :- item(I).
requires_all(break, I, holds(whole, I)) :- item(I).

affordance(repair, I) :- item(I).
requires_all(repair, I, holds(broken, I)) :- item(I).

affordance(carry, I) :- item(I).
requires_any(carry, I, holds(whole, I)) :- item(I).
requires_any(carry, I, holds(broken, I)) :- item(I).

affordance(destroy, I) :- item(I).
requires_any(destroy, I, holds(whole, I)) :- item(I).
requires_any(destroy, I, holds(broken, I)) :- item(I).

affordance(steal, I) :- item(I).
requires_any(steal, I, holds(whole, I)) :- item(I).
requires_any(steal, I, holds(broken, I)) :- item(I).

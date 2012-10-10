% Enforce preconditions:
:-
  precondition(A, Cond),
  not situation(A, Cond).

% Short-circuit for impossibility:
:- precondition(A, impossible).

% Special precondition expansions:

%  actor_colocated_with_target
precondition(A, holds(at, Actor, Location)) :-
  special_precondition(A, actor_colocated_with_target),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, holds(at, Target, Location)).

%  actor_near_target
precondition(A, holds(accessible_from, ALoc, TLoc)) :-
  special_precondition(A, actor_near_target),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, holds(at, Actor, ALoc)),
  situation(A, holds(at, Target, TLoc)).

%  actor_controls_target_item
precondition(A, holds(controlled_by, Target, Actor)) :-
  special_precondition(A, actor_controls_target_item),
  param(A, actor, Actor),
  param(A, target, Target).
precondition(A, holds(carried_by, Target, Actor)) :-
  special_precondition(A, actor_controls_target_item),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, possible(carry, Target)).

%  actor_controls_item
precondition(A, holds(controlled_by, Item, Actor)) :-
  special_precondition(A, actor_controls_item),
  param(A, actor, Actor),
  param(A, item, Item).
precondition(A, holds(carried_by, Item, Actor)) :-
  special_precondition(A, actor_controls_item),
  param(A, actor, Actor),
  param(A, item, Item),
  situation(A, possible(carry, Item)).

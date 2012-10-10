% Action:
atype(destroy).

% Parameters:
parameter(destroy, 1, actor, character).
parameter(destroy, 2, target, item).

% Valorization:
harmful(A, Owner) :-
  action(A, destroy),
  param(A, target, Item),
  situation(A, holds(owned_by, Item, Owner)).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, destroy).
special_precondition(A, actor_controls_target_item) :- action(A, destroy).
precondition(A, competent(fight, Actor)) :- % More strenuous than breaking...
  action(A, destroy),
  param(A, actor, Actor).
precondition(A, possible(destroy, Target)) :-
  action(A, destroy),
  param(A, target, Target).

% Reactions:
% <none>

% Effects:
_effect(A,
  both(
    causes(destroyed, Target),
    both(
      causes(uncontrolled, Target),
      causes(not_carried, Target)
    )
  )
) :-
  action(A, destroy),
  param(A, target, Target).
_accident(A, causes(injured, Actor)) :-
  action(A, destroy),
  param(A, actor, Actor).
_accident(A,
  both(
    causes(uncontrolled, Target),
    causes(not_carried, Target)
  )
) :-
  action(A, destroy),
  param(A, target, Target).

% Action:
atype(give).

% Parameters:
parameter(give, 1, actor, character).
parameter(give, 2, item, item).
parameter(give, 3, target, character).

% Valorization:
helpful(A, Target) :- action(A, give), param(A, target, Target).

% Preconditions:
special_precondition(A, actor_colocated_with_target) :- action(A, give).
special_precondition(A, actor_controls_item) :- action(A, give).
precondition(A, impossible) :-
  action(A, give),
  param(A, item, Item),
  situation(A, holds(unowned, Item)).
precondition(A, competent(use_item, Actor)) :-
  action(A, give),
  param(A, actor, Actor).

% Reactions:
_reaction(R, active, rxn(give, Victim, Target, Ally)) :-
  action(R, break),
  param(R, actor, Actor),
  param(R, target, Target),
  situation(R, holds(carried_by, Target, Victim)),
  allied(Victim, Ally),
  Ally != Actor.
_reaction(R, active, rxn(give, Victim, Target, Ally)) :-
  action(R, steal),
  param(R, actor, Actor),
  param(R, target, Target),
  situation(R, holds(carried_by, Target, Victim)),
  allied(Victim, Ally),
  Ally != Actor.
% Trading:
_reaction(R, passive, rxn(give, Beneficiary, OtherItem, Benefactor)) :-
  action(R, give),
  param(R, actor, Benefactor),
  param(R, target, Beneficiary),
  situation(R, holds(carried_by, OtherItem, Beneficiary)),
  situation(R, holds(owned_by, OtherItem, Beneficiary)).

% Effects:
_effect(A, causes(controlled_by, Item, Target)) :-
  action(A, give),
  param(A, actor, Actor),
  param(A, target, Target),
  param(A, item, Item),
  situation(A, impossible(carry, Item)),
  situation(A, holds(owned_by, Item, Another)),
  Another != Actor.
_effect(
  A,
  both(
    causes(owned_by, Item, Target),
    causes(controlled_by, Item, Target)
  )
) :-
  action(A, give),
  param(A, actor, Actor),
  param(A, target, Target),
  param(A, item, Item),
  situation(A, impossible(carry, Item)),
  situation(A, holds(owned_by, Item, Actor)).
_effect(
  A,
  both(
    causes(controlled_by, Item, Target),
    causes(carried_by, Item, Target)
  )
) :-
  action(A, give),
  param(A, actor, Actor),
  param(A, target, Target),
  param(A, item, Item),
  situation(A, possible(carry, Item)),
  situation(A, holds(owned_by, Item, Another)),
  Another != Actor.
_effect(
  A,
  both(
    causes(owned_by, Item, Target),
    both(
      causes(controlled_by, Item, Target),
      causes(carried_by, Item, Target)
    )
  )
) :-
  action(A, give),
  param(A, actor, Actor),
  param(A, target, Target),
  param(A, item, Item),
  situation(A, possible(carry, Item)),
  situation(A, holds(owned_by, Item, Actor)).
_accident(A,
  both(
    causes(at, Item, Elsewhere),
    both(
      causes(uncontrolled, Item),
      causes(not_carried, Item)
    )
  )
) :-
  action(A, give),
  param(A, item, Item),
  situation(A, holds(at, Item, Start)),
  location(Elsewhere),
  Elsewhere != Start.
_accident(A,
  both(
    causes(uncontrolled, Item),
    causes(not_carried, Item)
  )
) :-
  action(A, give),
  param(A, item, Item).

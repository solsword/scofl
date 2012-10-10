% Action:
atype(rescue).

% Parameters:
parameter(rescue, 1, actor, character).
parameter(rescue, 2, opponent, character).
parameter(rescue, 3, target, character).
parameter(rescue, 4, destination, location).

% Valorization:
helpful(A, Beneficiary) :- action(A, rescue), param(A, target, Beneficiary).
harmful(A, Opponent) :- action(A, rescue), param(A, opponent, Opponent).

% Preconditions:
special_precondition(A, actor_near_target) :- action(A, rescue).
precondition(A, competent(fight, Actor)) :-
  action(A, rescue),
  param(A, actor, Actor).

% Reactions:
reaction_only(rescue).
_reaction(
  R,
  active,
  rxn(rescue, Other, Opponent, Victim, Destination)
) :-
  action(R, attack),
  param(R, actor, Opponent),
  param(R, target, Victim),
  location(Destination),
  situation(R, holds(at, Victim, Start)),
  situation(R, holds(accessible_from, Start, Destination)),
  character(Other),
  situation(R, incompetent(fight, Victim)).
_reaction(
  R,
  active,
  rxn(rescue, Other, Opponent, Victim, Destination)
) :-
  action(R, capture),
  param(R, actor, Opponent),
  param(R, target, Victim),
  location(Destination),
  situation(R, holds(at, Victim, Start)),
  situation(R, holds(accessible_from, Start, Destination)),
  character(Other).
_reaction(
  R,
  active,
  rxn(rescue, Other, Opponent, Victim, Destination)
) :-
  action(R, kill),
  param(R, actor, Opponent),
  param(R, target, Victim),
  location(Destination),
  situation(R, holds(at, Victim, Start)),
  situation(R, holds(accessible_from, Start, Destination)),
  character(Other).

% Effects:
_effect(
  A,
  both(
    causes(at, Actor, Destination),
    both(
      causes(at, Target, Destination),
      causes(free, Target)
    )
  )
) :-
  action(A, rescue),
  param(A, actor, Actor),
  param(A, target, Target),
  param(A, destination, Destination).
_accident(
  A,
  both(
    causes(at, Actor, Nearby),
    causes(injured, Actor)
  )
) :-
  action(A, rescue),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, holds(at, Target, Nearby)).
_accident(
  A,
  both(
    causes(at, Actor, Nearby),
    causes(captured_by, Actor, Captor)
  )
) :-
  action(A, rescue),
  param(A, actor, Actor),
  param(A, target, Target),
  situation(A, holds(at, Target, Nearby)),
  situation(A, holds(captured_by, Target, Captor)).

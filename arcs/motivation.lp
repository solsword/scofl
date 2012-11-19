% Filter out non-sequiturs based on active characters:

% TODO: once you've been helpful, don't go back to being harmful?
% TODO: feuds with non-involved characters?
% TODO: FIX (or remove?) required_for!

involved(S, chr(C)) :- param(S, P, chr(C)).

% Characters that are present in the beginning are established:
established(B, C) :- beginning(B), character(C).
%% All characters are established during reactions:
%established(r(S), C) :- base_situation(S), character(C).
% Established and involved characters are established during reactions:
established(r(S), C) :- base_situation(S), established(S, C).
established(r(S), C) :- base_situation(S), involved(S, C).
% Characters involved in an action are established for the next two:
established(S, chr(C)) :- next(O, S), involved(O, chr(C)).
established(S, chr(C)) :- next(O, N), next(N, S), involved(O, chr(C)).

:- involved(S, chr(C)), not established(S, chr(C)).

% Track some surprising (but not necessarily impossible) events:
harmful_to_ally(S) :-
  param(S, actor, Actor),
  harmful(S, Victim),
  allied(Actor, Victim).

has_helped(A, Helper, Beneficiary) :-
  param(S, actor, Helper),
  helpful(S, Beneficiary),
  after(S, A).

has_harmed(A, Aggressor, Victim) :-
  param(S, actor, Aggressor),
  harmful(S, Victim),
  after(S, A).

surprising(S) :-
  harmful_to_ally(S).

surprising(S) :-
  param(S, actor, Actor),
  harmful(S, Victim),
  has_helped(S, Victim, Actor).

surprising(S) :-
  param(S, actor, Actor),
  harmful(S, Victim),
  has_helped(S, Actor, Victim).

surprising(S) :-
  param(S, actor, Actor),
  helpful(S, Enemy),
  has_harmed(S, Enemy, Actor).

surprising(S) :-
  param(S, actor, Actor),
  helpful(S, Enemy),
  has_harmed(S, Actor, Enemy).

% Limit surprising events:
:- 3 { surprising(S) }.

% Motivation:

% Helping achieve preconditions for your allies (which includes yourself) is
% motivated:

% TODO: Annotate important preconditions?
% TODO: Or change things so that plausible alternatives can be computed? (<-
% might be way too expensive).
motivated_by_future_intent(S, required_for(A)) :-
  after(S, A),
  effect(S, Effect, intentional),
  precondition(A, State),
  result_of(Effect, State),
  not situation(S, State),
  not harmful_to_ally(S),
  param(S, actor, Actor),
  param(A, actor, Ally),
  allied(Actor, Ally).

% Don't chain future intent motivaitons (as this can lead to "motivated"
% dithering):
:-
  motivated_by_future_intent(Before, required_for(Later)),
  motivated_by_future_intent(Later, required_for(Ultimate)).

% Relationships might exist at the start of the arc:
{ motivated_by_history(S, feud(Aggressor, Victim)) } :-
  harmful(S, Victim),
  param(S, actor, Aggressor),
  established(S, Victim),
  feud(Aggressor, Victim).

{ motivated_by_history(S, friendship(Benefactor, Beneficiary)) } :-
  helpful(S, Beneficiary),
  param(S, actor, Benefactor),
  established(S, Victim),
  friendship(Benefactor, Beneficiary).

% Don't rescue or defend your enemies just to spite your other enemies:
:-
  motivated_by_history(S, feud(Aggressor, Victim)),
  action(S, rescue; defend),
  helpful(S, Other),
  enemies(Aggressor, Other).

% Reciprocation is one possible motivation:
motivated_by_reciprocation(S, revenge(H)) :-
  param(S, actor, Vengeful),
  harmful(S, Enemy),
  situation(H),
  after_not_reaction(H, S),
  param(H, actor, Enemy),
  harmful(H, Vengeful),
  Vengeful != Enemy.

motivated_by_reciprocation(r(S), revenge(H)) :-
  param(r(S), actor, Vengeful),
  helpful(S, Enemy),
  situation(H),
  after_not_reaction(H, S),
  param(H, actor, Enemy),
  harmful(H, Vengeful),
  Vengeful != Enemy.

motivated_by_reciprocation(S, gratitude(H)) :-
  param(S, actor, Grateful),
  helpful(S, Benefactor),
  situation(H),
  after(H, S),
  param(H, actor, Benefactor),
  helpful(H, Grateful),
  Benefactor != Grateful.

motivated_by_reciprocation(r(S), gratitude(H)) :-
  param(r(S), actor, Grateful),
  harmful(S, Benefactor),
  situation(H),
  after_not_reaction(H, S),
  param(H, actor, Benefactor),
  helpful(H, Grateful),
  Benefactor != Grateful.

% Self-interest is of course a motivation:
motivated_by_self_interest(S) :-
  param(S, actor, Self),
  helpful(S, Self).

% Reaction to harm is motivated:
motivated_by_defense(r(S), defend_against(S)) :-
  param(r(S), actor, Victim),
  harmful(S, Victim).

motivated_by_defense(r(S), defend_against(S)) :-
  param(r(S), actor, Ally),
  harmful(S, Victim),
  allied(Victim, Ally).

% Sometimes people just do certain things by nature (but not surprising things):
{ motivated_by_nature(S, cruelty) } :-
  param(S, actor, Cruel),
  nature(Cruel, cruel),
  harmful(S, Victim),
  not friendship(Cruel, Victim),
  Victim != Cruel,
  not surprising(S).

{ motivated_by_nature(S, kindness) } :-
  param(S, actor, Kind),
  nature(Kind, kind),
  helpful(S, Beneficiary),
  not feud(Kind, Beneficiary),
  not feud(Beneficiary, Kind),
  Kind != Beneficiary,
  not surprising(S).

{ motivated_by_nature(S, wanderlust) } :-
  param(S, actor, Restless),
  nature(Restless, restless),
  action(S, travel),
  not surprising(S),
  beginning(B),
  base_situation(S, BS),
  BS - B < 2.
% ^ Wanderlust travel should only happen towards the beginning of the story.

{ motivated_by_dislike(S, dislike_of(Enemy)) } :-
  param(S, actor, Fearful),
  action(S, travel),
  situation(S, holds(at, Fearful, Place)),
  situation(S, holds(at, Enemy, Place)),
  situation(S, competent(fight, Enemy)),
  established(S, Enemy),
  1 { enemies(Fearful, Enemy), has_harmed(S, Enemy, Fearful) }.

% All types of motivation count:
motivated(S, Intent) :- motivated_by_future_intent(S, Intent).
motivated(S, History) :- motivated_by_history(S, History).
motivated(S, Action) :- motivated_by_reciprocation(S, Action).
motivated(S, self_interest) :- motivated_by_self_interest(S).
motivated(S, Defense) :- motivated_by_defense(S, Defense).
motivated(S, Nature) :- motivated_by_nature(S, Nature).
motivated(S, Fear) :- motivated_by_dislike(S, Fear).

% All actions must be motivated:
:- some_action(S), 0 { motivated(S, Any) } 0, beginning(B), S != B.

% But no one motivation should be used too much:
:- 4 { motivated_by_future_intent(S, Any) }.
:- 3 { motivated_by_history(S, Any) }.
:- 5 { motivated_by_reciprocation(S, Any) }.
:- 4 { motivated_by_self_interest(S) }.
:- 3 { motivated_by_defense(S, Any) }.
:- 3 { motivated_by_nature(S, Any) }.
:- 3 { motivated_by_dislike(S, Any) }.

:- 2 { motivated_by_nature(S, cruelty) }.
:- 2 { motivated_by_nature(S, wanderlust) }.
:- 2 { motivated_by_nature(S, kindness) }.

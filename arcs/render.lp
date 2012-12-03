% ------------------
% Paragraph Assembly
% ------------------

paragraph(Start, Start, S) :-
  base_situation(Start),
  sentence(Start, S).

paragraph(Start, End, @join(Head, Tail)) :-
  End - Start > 0,
  paragraph(Start, Start, Head),
  paragraph(Start+1, End, Tail).

text(@join(@join("At the", Loc, ":"), T)) :-
  beginning(B),
  ending(E),
  paragraph(B, E-1, T),
  param(B, actor, Actor),
  situation(B, holds(at, Actor, Location)),
  determined(noun(Location), Loc).

% -----------
% Punctuation
% -----------

punctuation(S, "!") :- surprising(S).
punctuation(S, "!") :- surprising(r(S)).
punctuation(S, ".") :- situation(S), not surprising(S), not surprising(r(S)).

% ------------------
% Sentence Templates
% ------------------

sentence(S, @join(Subject, Clause, Punct)) :-
  result(S, success),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, past, Clause),
  punctuation(S, Punct).

sentence(S, @join(Subject, "tried to", Clause, "but failed", Punct)) :-
  result(S, failure),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    "tried to",
    Clause,
    "but accidentally caused",
    Accidentresult,
    Punct
  )
) :-
  result(S, accident),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  1 { effect(S, X, accidental) } 1,
  effect(S, Effect, accidental),
  result_of(Effect, Result),
  state_phrase(Accidentresult, infinitive, Result),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    "tried to",
    Clause,
    "but accidentally caused",
    Accidentaggregate,
    Punct
  )
) :-
  result(S, accident),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  2 { effect(S, X, accidental) } 2,
  effect(S, E1, accidental),
  effect(S, E2, accidental),
  E1 != E2,
  result_of(E1, R1),
  state_phrase(A1, infinitive, R1),
  result_of(E2, R2),
  state_phrase(A2, infinitive, R2),
  Accidentaggregate := @join(A1, "and", A2),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    "tried to",
    Clause,
    "but there was a complicated accident",
    Punct
  )
) :-
  result(S, accident),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  3 { effect(S, X, accidental) },
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    "tried to",
    Clause,
    "but failed due to an accident",
    Punct
  )
) :-
  result(S, accident),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  { effect(S, Effect, accidental) } 0,
  punctuation(S, Punct).

sentence(
  S,
  @join(Subject, "tried to", Clause, ",", "but", Reactor, RClause, Punct)
) :-
  result(S, failure),
  reaction(S, active, Rxn),
  result(r(S), success),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, present, Clause),
  verb_clause(r(S), past, RClause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    "Although",
    Reactor,
    "tried to",
    RClause,
    ",",
    Subject,
    "managed to",
    Clause,
    Punct
  )
) :-
  result(S, success),
  reaction(S, active, Rxn),
  result(r(S), failure),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, present, Clause),
  verb_clause(r(S), present, RClause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    "Although",
    Reactor,
    "tried to",
    RClause,
    ",",
    Subject,
    "managed to",
    Clause,
    Punct
  )
) :-
  result(S, success),
  reaction(S, active, Rxn),
  result(r(S), accident),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, present, Clause),
  verb_clause(r(S), present, RClause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    Clause,
    ",",
    "but",
    Reactor,
    "managed to",
    RClause,
    Punct
  )
) :-
  result(S, success),
  reaction(S, passive, Rxn),
  result(r(S), success),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, past, Clause),
  verb_clause(r(S), present, RClause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    Clause,
    ";",
    Reactor,
    "tried to",
    RClause,
    "but failed",
    Punct
  )
) :-
  result(S, success),
  reaction(S, passive, Rxn),
  result(r(S), failure),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, past, Clause),
  verb_clause(r(S), present, RClause),
  punctuation(S, Punct).

sentence(
  S,
  @join(
    Subject,
    Clause,
    ";",
    Reactor,
    "tried to",
    RClause,
    "but there was an accident",
    Punct
  )
) :-
  result(S, success),
  reaction(S, passive, Rxn),
  result(r(S), accident),
  param(S, actor, Actor),
  param(r(S), actor, RActor),
  determined(noun(Actor), Subject),
  determined(noun(RActor), Reactor),
  verb_clause(S, past, Clause),
  verb_clause(r(S), present, RClause),
  punctuation(S, Punct).

% ------------------------
% Verb Clause Construction
% ------------------------

:- some_action(S), tense(Tense), { verb_clause(S, Tense, Clause) } 0.
:- some_action(S), tense(Tense), 2 { verb_clause(S, Tense, Clause) }.

{ verb_clause(S, Tense, Clause) } :- % Default for actions with a 'target'.
  param(S, target, Target),
  action(S, Act),
  verb_phrase(Clause, Tense, verb(Act), noun(Target)).

{ verb_clause(S, Tense, Clause) } :- % Default for actions with a 'destination'.
  param(S, destination, Destination),
  action(S, Act),
  tense(Tense, verb(Act), V),
  determined(noun(Destination), D),
  Clause := @join(V, "to", D).

% Specific cases:

verb_clause(S, Tense, Clause) :-
  action(S, defend),
  param(S, opponent, Opponent),
  param(S, target, Target),
  tense(Tense, verb(defend), V),
  determined(noun(Opponent), O),
  determined(noun(Target), T),
  Clause := @join(V, T, "from", O).

verb_clause(S, Tense, Clause) :-
  action(S, escape),
  param(S, opponent, Opponent),
  param(S, destination, Destination),
  tense(Tense, verb(escape), V),
  determined(noun(Opponent), O),
  determined(noun(Destination), D),
  Clause := @join(V, "from", O, "to", D).

verb_clause(S, Tense, Clause) :-
  action(S, give),
  param(S, item, Item),
  param(S, target, Target),
  tense(Tense, verb(give), V),
  determined(noun(Item), I),
  determined(noun(Target), T),
  Clause := @join(V, I, "to", T).

verb_clause(S, Tense, Clause) :-
  action(S, guard),
  param(S, opponent, Opponent),
  param(S, target, Target),
  tense(Tense, verb(guard), V),
  determined(noun(Opponent), O),
  determined(noun(Target), T),
  Clause := @join(V, T, "from", O).

verb_clause(S, Tense, Clause) :-
  action(S, escape),
  param(S, target, Target),
  param(S, destination, Destination),
  tense(Tense, verb(escape), V),
  determined(noun(Target), T),
  determined(noun(Destination), D),
  Clause := @join(V, T, "to", D).

verb_clause(S, Tense, Clause) :-
  action(S, rescue),
  param(S, opponent, Opponent),
  param(S, target, Target),
  param(S, destination, Destination),
  tense(Tense, verb(rescue), V),
  tense(Tense, verb(flee), F),
  determined(noun(Opponent), O),
  determined(noun(Target), T),
  determined(noun(Destination), D),
  Clause := @join(V, T, "from", O, "and", F, "to", D).

verb_clause(S, Tense, Clause) :-
  action(S, steal),
  param(S, target, Target),
  situation(S, holds(controlled_by, Target, Victim)),
  tense(Tense, verb(steal), V),
  determined(noun(Victim), Vct),
  determined(noun(Target), T),
  Clause := @join(V, T, "from", Vct).

% -------------------------
% State Phrase Construction
% -------------------------

state_phrase(Phrase, Tense, holds(Nullary)) :-
  state_phrase_nullary(Phrase, Tense, Nullary).

state_phrase(Phrase, Tense, holds(Unary, Subject)) :-
  state_phrase_unary(Phrase, Tense, Unary, Subject).

state_phrase(Phrase, Tense, holds(Binary, Subject, Object)) :-
  state_phrase_binary(Phrase, Tense, Binary, Subject, Object).

% TODO: wider states?

% There aren't any nullary states currently...
state_phrase_nullary(Phrase, Tense, State) :-
  tense(Tense, verb(is), Is),
  situation(S, holds(State)),
  Phrase := @join("it", Is, State). % e.g. "It is raining."

state_phrase_unary(Phrase, Tense, State, Subject) :-
  tense(Tense, verb(is), Is),
  situation(S, holds(State, Subject)),
  determined(noun(Subject), Subj),
  Phrase := @join(Subj, Is, State).

state_phrase_binary(Phrase, Tense, Rel, Subj, Obj) :-
  preposition_relation(Rel),
  tense(Tense, verb(is), Is),
  situation(S, holds(Rel, Subj, Obj)),
  determined(noun(Subj), Subject),
  determined(noun(Obj), Object),
  Phrase := @join(Subject, Is, Rel, Object).

state_phrase_binary(Phrase, Tense, Rel, Subj, Obj) :-
  verb_relation(Rel),
  tense(Tense, verb(Rel), Verb),
  situation(S, holds(Rel, Subj, Obj)),
  determined(noun(Subj), Subject),
  determined(noun(Obj), Object),
  Phrase := @join(Subject, Verb, Object).

% -------
% Motives
% -------

motive(S, required_for(F)) :- motivated(S, required_for(F)).
motive(S, revenge(F)) :- motivated(S, revenge(F)).
motive(S, gratitude(F)) :- motivated(S, gratitude(F)).
motive(S, self_interest) :- motivated(S, self_interest).
motive(S, defend_against(R)) :- motivated(S, defend_against(R)).
motive(S, cruelty) :- motivated(S, cruelty).
motive(S, kindness) :- motivated(S, kindness).
motive(S, wanderlust) :- motivated(S, wanderlust).

motive(S, feud(Angry, Hated)) :-
  motivated(S, feud(A, H)),
  name(noun(A), Angry),
  name(noun(H), Hated).

motive(S, friendship(Friendly, Friend)) :-
  motivated(S, friendship(A, H)),
  name(noun(A), Friendly),
  name(noun(H), Friend).

motive(S, fear_of(Enemy)) :-
  motivated(S, fear_of(E)),
  name(noun(E), Enemy).

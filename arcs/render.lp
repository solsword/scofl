% ------------------
% Paragraph Assembly
% ------------------

preamble(Ordering, @sentence(Phrase)) :- preamble_phrase(Ordering, Phrase).

preamble_phrase(0, Phrase) :- cast(Phrase).
preamble_phrase(1, Phrase) :- positions(Phrase).
preamble_phrase(2, Phrase) :- item_intro(Phrase).
preamble_phrase(3, Phrase) :- psych_intro(Phrase).
preamble_phrase(4, Phrase) :- state_intro(Phrase).

%paragraph(Start, Start, S) :-
%  base_situation(Start),
%  sentence(Start, S).

%paragraph(Start, End, @join(Head, Tail)) :-
%  End - Start > 0,
%  paragraph(Start, Start, Head),
%  paragraph(Start+1, End, Tail).

%text(@join(@join("At", Loc, ":"), T)) :-
%  beginning(B),
%  ending(E),
%  paragraph(B, E-1, T),
%  setting(Location),
%  determined(noun(Location), Loc).

% -----------------------
% Character Introductions
% -----------------------

cast(@join("once upon a time, there lived", C)) :- _cast(C).

{ chrintr(Chr, @join("a", Name)) } :-
  character(Chr),
  name(noun(Chr), Name).

chrintr(Chr, @join("a cruel", Name)) :-
  character(Chr),
  nature(Chr, cruel),
  name(noun(Chr), Name).

chrintr(Chr, @join("a kind", Name)) :-
  character(Chr),
  nature(Chr, kind),
  name(noun(Chr), Name).

:- character(Chr), [ chrintr(Chr, Intr) ] 0.
:- character(Chr), 2 [ chrintr(Chr, Intr) ].

_cast(@list(I1)) :-
  1 [ appears(chr(C)) ] 1,
  appears(chr(C1)), chrintr(chr(C1), I1).
_cast(@list(I1, I2)) :-
  2 [ appears(chr(C)) ] 2,
  appears(chr(C1)), chrintr(chr(C1), I1),
  appears(chr(C2)), chrintr(chr(C2), I2),
  C1 < C2.
_cast(@list(I1, I2, I3)) :-
  3 [ appears(chr(C)) ] 3,
  appears(chr(C1)), chrintr(chr(C1), I1),
  appears(chr(C2)), chrintr(chr(C2), I2),
  appears(chr(C3)), chrintr(chr(C3), I3),
  C1 < C2, C2 < C3.
_cast(@list(I1, I2, I3, I4)) :-
  4 [ appears(chr(C)) ] 4,
  appears(chr(C1)), chrintr(chr(C1), I1),
  appears(chr(C2)), chrintr(chr(C2), I2),
  appears(chr(C3)), chrintr(chr(C3), I3),
  appears(chr(C4)), chrintr(chr(C4), I4),
  C1 < C2, C2 < C3, C3 < C4.

% -------
% Setting
% -------

setting(Loc) :-
  beginning(B),
  param(B, actor, Actor),
  situation(B, holds(at, Actor, Loc)).

positions(@join("all of them were at", TheSetting)) :-
  phrase_at_setting(AtSetting),
  setting(Setting),
  determined(noun(Setting), TheSetting),
  chars_at_setting(Chars, N), N > 1,
  0 [ phrase_at_alt(_, AnyAtAlt) ] 0.

positions(@join(AtSetting, "while", AtAlt1)) :-
  phrase_at_setting(AtSetting),
  1 [ phrase_at_alt(N, AnyAtAlt) ] 1,
  phrase_at_alt(1, AtAlt1).

positions(@join(AtSetting, "while", AtAlt1, "and", AtAlt2)) :-
  phrase_at_setting(AtSetting),
  2 [ phrase_at_alt(N, AnyAtAlt) ] 2,
  phrase_at_alt(1, AtAlt1),
  phrase_at_alt(2, AtAlt2).

positions(@join(AtSetting, "while", AtAlt1, ",", AtAlt2, "and", AtAlt3)) :-
  phrase_at_setting(AtSetting),
  3 [ phrase_at_alt(N, AnyAtAlt) ] 3,
  phrase_at_alt(1, AtAlt1),
  phrase_at_alt(2, AtAlt2),
  phrase_at_alt(3, AtAlt3).

phrase_at_setting(@join(AtSetting, "was at", TheSetting)) :-
  chars_at_setting(AtSetting, 1),
  setting(Setting),
  determined(noun(Setting), TheSetting).

phrase_at_setting(@join(AtSetting, "were at", TheSetting)) :-
  chars_at_setting(AtSetting, N), N > 1,
  setting(Setting),
  determined(noun(Setting), TheSetting).

phrase_at_alt(Alt, @join(AtAlt, "was at", TheAlt)) :-
  chars_at_alt(Alt, AtAlt, 1),
  altloc(Alt, Loc),
  determined(noun(Loc), TheAlt).

phrase_at_alt(Alt, @join(AtAlt, "were at", TheAlt)) :-
  chars_at_alt(Alt, AtAlt, N), N > 1,
  altloc(Alt, Loc),
  determined(noun(Loc), TheAlt).

chars_at_setting(@list(The1), 1) :-
  beginning(B),
  setting(Setting),
  1 [ situation(B, holds(at, Actor, Setting)) : character(Actor) ] 1,
  situation(B, holds(at, C1, Setting)), determined(noun(C1), The1).

chars_at_setting(@list(The1, The2), 2) :-
  beginning(B),
  setting(Setting),
  2 [ situation(B, holds(at, Actor, Setting)) : character(Actor) ] 2,
  situation(B, holds(at, chr(C1), Setting)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Setting)), determined(noun(chr(C2)), The2),
  C1 < C2.

chars_at_setting(@list(The1, The2, The3), 3) :-
  beginning(B),
  setting(Setting),
  3 [ situation(B, holds(at, Actor, Setting)) : character(Actor) ] 3,
  situation(B, holds(at, chr(C1), Setting)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Setting)), determined(noun(chr(C2)), The2),
  situation(B, holds(at, chr(C3), Setting)), determined(noun(chr(C3)), The3),
  C1 < C2, C2 < C3.

chars_at_setting(@list(The1, The2, The3, The4), 4) :-
  beginning(B),
  setting(Setting),
  4 [ situation(B, holds(at, Actor, Setting)) : character(Actor) ] 4,
  situation(B, holds(at, chr(C1), Setting)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Setting)), determined(noun(chr(C2)), The2),
  situation(B, holds(at, chr(C3), Setting)), determined(noun(chr(C3)), The3),
  situation(B, holds(at, chr(C4), Setting)), determined(noun(chr(C4)), The4),
  C1 < C2, C2 < C3, C3 < C4.

charalt(1, chr(C)) :-
  beginning(B),
  setting(Setting),
  location(Elsewhere),
  Elsewhere != Setting,
  appears(chr(C)),
  situation(B, holds(at, chr(C), Elsewhere)),
  [ situation(B, holds(at, chr(O), Elsewhere)) : O < C ] 0.

altloc(1, Loc) :-
  beginning(B),
  charalt(1, Chr),
  situation(B, holds(at, Chr, Loc)).

charalt(2, chr(C)) :-
  beginning(B),
  setting(Setting),
  location(Elsewhere),
  altloc(1, Al1),
  Elsewhere != Setting, Elsewhere != Al1,
  appears(chr(C)),
  situation(B, holds(at, chr(C), Elsewhere)),
  [ situation(B, holds(at, chr(O), Elsewhere)) : O < C ] 0.

altloc(2, Loc) :-
  beginning(B),
  charalt(2, Chr),
  situation(B, holds(at, Chr, Loc)).

charalt(3, chr(C)) :-
  beginning(B),
  setting(Setting),
  location(Elsewhere),
  altloc(1, Al1),
  altloc(2, Al2),
  Elsewhere != Setting, Elsewhere != Al1, Elsewhere != Al2,
  appears(chr(C)),
  situation(B, holds(at, chr(C), Elsewhere)),
  [ situation(B, holds(at, chr(O), Elsewhere)) : O < C ] 0.

altloc(3, Loc) :-
  beginning(B),
  charalt(3, Chr),
  situation(B, holds(at, Chr, Loc)).

chars_at_alt(1, @list(The1), 1) :-
  beginning(B),
  altloc(1, Loc),
  1 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 1,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1).

chars_at_alt(1, @list(The1, The2), 2) :-
  beginning(B),
  altloc(1, Loc),
  2 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 2,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Loc)), determined(noun(chr(C2)), The2),
  C1 < C2.

chars_at_alt(1, @list(The1, The2, The3), 3) :-
  beginning(B),
  altloc(1, Loc),
  3 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 3,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Loc)), determined(noun(chr(C2)), The2),
  situation(B, holds(at, chr(C3), Loc)), determined(noun(chr(C3)), The3),
  C1 < C2, C2 < C3.

chars_at_alt(2, @list(The1), 1) :-
  beginning(B),
  altloc(2, Loc),
  1 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 1,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1).

chars_at_alt(2, @list(The1, The2), 2) :-
  beginning(B),
  altloc(2, Loc),
  2 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 2,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1),
  situation(B, holds(at, chr(C2), Loc)), determined(noun(chr(C2)), The2),
  C1 < C2.

chars_at_alt(3, @list(The1), 1) :-
  beginning(B),
  altloc(3, Loc),
  1 [ situation(B, holds(at, Actor, Loc)) : character(Actor) ] 1,
  situation(B, holds(at, chr(C1), Loc)), determined(noun(chr(C1)), The1).

% ------------------
% Item Introductions
% ------------------

item_intro(@join("an ancient", Name, "was hidden at", Location)) :-
  item(Itm),
  name(noun(Itm), Name),
  appears(Itm),
  beginning(B),
  situation(B, holds(unowned, Itm)),
  situation(B, holds(at, Itm, Loc)),
  determined(noun(Loc), Location).

item_intro(@join(TheOwner, "owned a", Name)) :-
  item(Itm),
  name(noun(Itm), Name),
  appears(Itm),
  beginning(B),
  situation(B, holds(owned_by, Itm, Owner)),
  situation(B, holds(controlled_by, Itm, Owner)),
  determined(noun(Owner), TheOwner).

item_intro(@join(TheOwner, "owned a", Name, ", which was at", Location)) :-
  item(Itm),
  name(noun(Itm), Name),
  appears(Itm),
  beginning(B),
  situation(B, holds(owned_by, Itm, Owner)),
  determined(noun(Owner), TheOwner),
  situation(B, holds(uncontrolled, Itm)),
  situation(B, holds(at, Itm, Loc)),
  determined(noun(Loc), Location).

item_intro(
  @join(
    TheController,
    "was carrying",
    @plus_s(TheOwner),
    Name
  )
) :-
  item(Itm),
  name(noun(Itm), Name),
  appears(Itm),
  beginning(B),
  situation(B, holds(owned_by, Itm, Owner)),
  situation(B, holds(controlled_by, Itm, Another)),
  Another != Owner,
  determined(noun(Owner), TheOwner),
  determined(noun(Another), TheController).

% ---------------------------
% Starting State Descriptions
% ---------------------------

hide_rel(at; accessible_from; owned_by; controlled_by; carried_by).
hide_state(unowned; uncontrolled; not_carried).
hide_state(Val) :- _default(State, Val).

state_intro(Phrase) :-
  stype(State),
  beginning(B),
  situation(B, holds(State, Subject)),
  not hide_state(State),
  appears(Subject),
  state_phrase(Phrase, past, holds(State, Subject)).

state_intro(Phrase) :-
  beginning(B),
  situation(B, holds(Rel, Subj, Obj)),
  appears(Subj),
  appears(Obj),
  not hide_rel(Rel),
  state_phrase(Phrase, past, holds(Rel, Subj, Obj)).

state_intro(Phrase) :-
  beginning(B),
  _initially_absent(Rel, Subj),
  absence(Rel, Subj, Absence),
  situation(B, holds(Absence, Subj)),
  appears(Subj),
  not hide_state(Absence),
  Rel != unowned, Rel != uncontrolled, Rel != not_carried,
  not _default_absent(Rel),
  state_phrase(Phrase, past, holds(Absence, Subject)).

psych_intro(
  @join(
    TheFirst,
    "and",
    TheSecond,
    "hated each other"
  )
) :-
  feud(chr(C1), chr(C2)),
  feud(chr(C2), chr(C1)),
  appears(chr(C1)),
  appears(chr(C2)),
  C1 < C2,
  determined(noun(chr(C1)), TheFirst),
  determined(noun(chr(C2)), TheSecond).

psych_intro(
  @join(
    TheFirst,
    "hated",
    TheSecond
  )
) :-
  feud(C1, C2),
  not feud(C2, C1),
  appears(C1),
  appears(C2),
  determined(noun(C1), TheFirst),
  determined(noun(C2), TheSecond).

psych_intro(
  @join(
    TheFirst,
    "and",
    TheSecond,
    "were friends"
  )
) :-
  friendship(chr(C1), chr(C2)),
  friendship(chr(C2), chr(C1)),
  appears(chr(C1)),
  appears(chr(C2)),
  C1 < C2,
  determined(noun(chr(C1)), TheFirst),
  determined(noun(chr(C2)), TheSecond).

psych_intro(
  @join(
    TheFirst,
    "liked",
    TheSecond
  )
) :-
  friendship(C1, C2),
  not friendship(C2, C1),
  appears(chr(C1)),
  appears(chr(C2)),
  determined(noun(C1), TheFirst),
  determined(noun(C2), TheSecond).

% -----------
% Punctuation
% -----------

punctuation(S, "!") :- surprising(S).
punctuation(S, "!") :- surprising(r(S)).
punctuation(S, ".") :- situation(S), not surprising(S), not surprising(r(S)).

% ------------------
% Sentence Templates
% ------------------

sentence(S, @capitalized(Phrase)) :-
  _sentence(S, Phrase).

_sentence(S, @join(Subject, Clause, Punct)) :-
  result(S, success),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, past, Clause),
  punctuation(S, Punct).

_sentence(S, @join(Subject, "tried to", Clause, "but failed", Punct)) :-
  result(S, failure),
  not some_reaction(S),
  param(S, actor, Actor),
  determined(noun(Actor), Subject),
  verb_clause(S, present, Clause),
  punctuation(S, Punct).

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

_sentence(
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

state_phrase(@sub_(Phrase), Tense, holds(Nullary)) :-
  state_phrase_nullary(Phrase, Tense, Nullary).

state_phrase(@sub_(Phrase), Tense, holds(Unary, Subject)) :-
  state_phrase_unary(Phrase, Tense, Unary, Subject).

state_phrase(@sub_(Phrase), Tense, holds(Binary, Subject, Object)) :-
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

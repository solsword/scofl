% ----- %
% Nouns %
% ----- %

noun(C) :- character(C).
noun(I) :- item(I).
noun(L) :- location(L).

number(noun(N), singular) :- character(N).
number(noun(N), singular) :- item(N).
number(noun(N), numberless) :- location(N).

determined(noun(N)) :- item(N).
determined(noun(N)) :- character(N).
determined(noun(N)) :- location(N).

definite(noun(N)) :- character(N).
definite(noun(N)) :- item(N).
definite(noun(N)) :- location(N).

gender(noun(chr(1)), female).
gender(noun(chr(2)), female).
gender(noun(chr(3)), male).
gender(noun(chr(4)), female).

gender(noun(N), neuter) :- item(N).

gender(noun(N), location) :- location(N).

name(noun(chr(1)), "knight").
name(noun(chr(2)), "princess").
name(noun(chr(3)), "merchant").
name(noun(chr(4)), "witch").
                 
name(noun(itm(1)), "sword").
name(noun(itm(2)), "chest").
name(noun(itm(3)), "crown").
                 
name(noun(loc(1)), "castle").
name(noun(loc(2)), "courtyard").
name(noun(loc(3)), "forest").
name(noun(loc(4)), "lake").

% Determination:

determined(Noun, Name) :- name(Noun, Name), undetermined(Noun).
determined(Noun, @the(Name)) :-
  name(Noun, Name),
  definite(Noun),
  determined(Noun).
determined(Noun, @an(Name)) :-
  name(Noun, Name),
  indefinite(Noun),
  determined(Noun).

% ----- %
% Verbs %
% ----- %

% Note: everything's singular for now, so handling number agreement isn't
% implemented... If you use present tense it'll be wrong though.
% TODO: handle number agreement.

verb(A) :- atype(A).
verb(give).
verb(is).

% Not the full English spectrum:
tense(present; past; infinitive).

% Each verb has exactly one form in each tense:
%rs(Tense, V) :- tense(Tense), verb(V).
%:- rs(T, V), { tense(T, verb(V), X) } 0.
%:- rs(T, V), 2 { tense(T, verb(V), X) }.
:- tense(Tense), verb(V), { tense(Tense, verb(V), X) } 0.
:- tense(Tense), verb(V), 2 { tense(Tense, verb(V), X) }.

% Present
% Verbs must be defined in their present tense:
tense(present, verb(V), V) :- verb(V).

% Past
{ tense(past, verb(V), Ved) } :- verb(V), Ved := @plus_ed(V). % Default.

tense(past, verb(break), broke).
tense(past, verb(flee), fled).
tense(past, verb(give), gave).
tense(past, verb(steal), stole).
tense(past, verb(is), was).

% Infinitive
% (Needed for state phrases...)
{ tense(infinitive, verb(V), @join("to", V)) } :- verb(V). % Default.

tense(infinitive, verb(is), "to be").

% ------------------------ %
% Verb Phrase Construction %
% ------------------------ %

verb_phrase(Phrase, Tense, Verb, Object) :-
  tense(Tense, Verb, V),
  determined(Object, O),
  Phrase := @join(V, O).

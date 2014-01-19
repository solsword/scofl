% States:
%  [status]
%    healthy injured dead

state(status, C) :- character(C).
_value(status, healthy; injured; dead).
_initial(status, healthy; injured).
_default(status, healthy).

% Dead people don't get involved any more:
:-
  param(S, Param, Corpse),
  situation(S, holds(dead, Corpse)).

% Relations:
%  [imprisonment]
%    captured_by free
%  [love]
%    love aloof

relation(captured_by, C) :- character(C).
singular(captured_by, C) :- character(C).
absence(captured_by, C, free) :- character(C).
_object(captured_by, C, O) :- character(C), character(O), C != O.
_initial(captured_by, C, O) :- character(C), character(O), C != O.
_initially_absent(captured_by, C) :- character(C).
_default_absent(captured_by).

relation(love, C) :- character(C).
verb_relation(love).
singular(love, C) :- character(C). % Yay biases!
absence(love, C, aloof) :- character(C).
_object(love, C, O) :- character(C), character(O), C != O.
% TODO: reenable love after making it do something!
%_initial(love, C, O) :- character(C), character(O), C != O.
_initially_absent(love, C) :- character(C).
_default_absent(love).

% Competencies:
%  fight travel use_item

competence(fight, C) :- character(C).
requires_all(fight, C, holds(healthy, C)) :- character(C).
requires_all(fight, C, holds(free, C)) :- character(C).

competence(travel, C) :- character(C).
requires_any(travel, C, holds(healthy, C)) :- character(C).
requires_any(travel, C, holds(injured, C)) :- character(C).
requires_all(travel, C, holds(free, C)) :- character(C).

competence(use_item, C) :- character(C).
requires_any(use_item, C, holds(healthy, C)) :- character(C).
requires_any(use_item, C, holds(injured, C)) :- character(C).

% States:
%  [location]
%    at
%  [connectedness]
%    accessible_from

relation(at, C) :- character(C).
required(at, C) :- character(C).
singular(at, C) :- character(C).

relation(at, I) :- item(I).
required(at, I) :- item(I).
singular(at, I) :- item(I).

_object(at, C, L) :- character(C), location(L).
_initial(at, C, L) :- character(C), location(L).

_object(at, I, L) :- item(I), location(L).
_initial(at, I, L) :- item(I), location(L).

relation(accessible_from, L) :- location(L).
absence(accessible_from, L, inaccessible) :- location(L).
_object(accessible_from, L, O) :- location(L), location(O), L != O.
_initial(accessible_from, L, O) :- location(L), location(O), L != O.

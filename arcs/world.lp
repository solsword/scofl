character(chr(1..N)) :- n_characters(N).

1 {
  protagonist(C),
  support(C),
  antagonist(C)
} 1 :-
  character(C).

:- 3 { support(C) : character(C) }.

{ nature(Villain, cruel) } :- antagonist(Villain).

:- 2 { nature(Villain, cruel) }.

{ nature(Hero, kind) } :- protagonist(Hero).

:- 2 { nature(Hero, kind) }.

{ nature(Wanderer, restless) } :- protagonist(Wanderer).

:- 2 { nature(Hero, restless) }.

allied(C, A) :- protagonist(C), protagonist(A).
allied(C, A) :- antagonist(C), antagonist(A).

{ allied(S, C) : character(C) } 3 :- support(S).

allied(S, S) :- support(S).

allied(A, B) :- allied(B, A).

:- allied(S, P), allied(S, A), support(S), protagonist(P), antagonist(A).

enemies(P, A) :- protagonist(P), antagonist(A).
enemies(B, A) :- enemies(A, B).

{ enemies(S, C) : character(C) } 3 :- support(S).

:- allied(A, B), enemies(A, B).

{ feud(Angry, Enemy) } :-
  character(Angry),
  character(Enemy),
  not allied(Angry, Enemy),
  Angry != Enemy.

{ friendship(Friendly, Friend) } :-
  allied(Friendly, Friend),
  Friendly != Friend.

item(itm(1..N)) :- n_items(N).

location(loc(1..N)) :- n_locations(N).

beginning(1).
%ending(@randm(Min, Max)) :- min_situations(Min), max_situations(Max).
ending(5).

n_actions(N-1) :- ending(N).

last_active(E-1) :- ending(E).

% Situations and corresponding reaction situations:
situation(B..E) :- beginning(B), ending(E).
situation(r(B..E)) :- beginning(B), ending(E).
active_situation(B..E-1) :- beginning(B), ending(E).
active_situation(r(B..E-1)) :- beginning(B), ending(E).

reaction_situation(r(S)) :- situation(r(S)).
base_situation(S) :- situation(S), not reaction_situation(S).

base_situation(S, S) :- base_situation(S).
base_situation(r(S), S) :- reaction_situation(r(S)).

next(N, N+1) :- base_situation(N), base_situation(N+1).
% Reactions are linked back in:
next(r(N), N+1) :- reaction_situation(r(N)), base_situation(N+1).

after(Before, After) :- next(Before, After).
after(Before, After) :- after(Before, Intermediate), after(Intermediate, After).
after(S, r(S)) :- base_situation(S).

after_not_reaction(Before, After) :- after(Before, After), After != r(Before).

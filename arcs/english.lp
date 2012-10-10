named(chr(1), "Ardhiel").
named(chr(2), "Balkon").
named(chr(3), "Camwyn").
named(chr(4), "Devlin").

named(itm(1), "Air Rod").
named(itm(2), "Blue Mushroom").
named(itm(3), "Captain's Sword").

named(loc(1), "Ambela").
named(loc(2), "Bannerlith").
named(loc(3), "Cortes Andres").
named(loc(4), "Dwarfwatch").

sentence(S, c(SubjectName, VerbClause, ResultClause, ReactClause)) :-
  param(S, actor, Actor),
  named(Actor, SubjectName),
  verbclause(S, VerbClause),
  resultclause(S, ResultClause),
  reactclause(S, ReactClause).

resultclause(S, c) :- result(S, success).
resultclause(S, c("but an accident occurred.")) :- result(S, accident).
resultclause(S, c("but ey failed.")) :- result(S, failure).

reactclause(S, c) :- situation(S), not some_reaction(S).
reactclause(S, c("and someone reacted")) :- some_reaction(S).

reactclause(r(S), c) :- situation(r(S)).

%resultclause(S, c) :-
%  result(S, success),
%  not reaction(S).
%
%resultclause(S, c("but an accident occurred.")) :-
%  result(S, accident),
%  not reaction(S).
%
%resultclause(S, c("but ey failed.")) :-
%  result(S, failure),
%  not reaction(S).

%resultclause(S, c("but", Sentence)) :-
%  result(S, success),
%  reaction(S),
%  result(r(S), success),
%  sentence(r(S), Sentence).
%
%resultclause(S, c("but ey failed because", Sentence)) :-
%  result(S, failure),
%  reaction(S),
%  result(r(S), success),
%  sentence(r(S), Sentence).
%
%resultclause(S, c("and ey succeeded, since", Sentence)) :-
%  result(S, success),
%  reaction(S),
%  result(r(S), failure),
%  sentence(r(S), Sentence).
%
%resultclause(S, c("while", Sentence)) :-
%  result(S, success),
%  reaction(S),
%  result(r(S), accident),
%  sentence(r(S), Sentence).

altverbclause(defend; guard; give; flee; travel; pursue; rescue; escape; steal).

verbclause(S, c(Verb, Object)) :-
  action(S, Verb),
  param(S, target, Target),
  named(Target, Object),
  not altverbclause(Verb).

verbclause(S, c(defend, Object, "from", Opponent)) :-
  action(S, defend),
  param(S, target, Target),
  param(S, opponent, Opp),
  named(Target, Object),
  named(Opp, Opponent).

verbclause(S, c(guard, Object, "from", Opponent)) :-
  action(S, guard),
  param(S, target, Target),
  param(S, opponent, Opp),
  named(Target, Object),
  named(Opp, Opponent).

verbclause(S, c(give, Item, "to", Object)) :-
  action(S, give),
  param(S, target, Target),
  param(S, item, It),
  named(Target, Object),
  named(It, Item).

verbclause(S, c(travel, "from", From, "to", To)) :-
  action(S, travel),
  action(S, Verb),
  param(S, destination, Destination),
  param(S, actor, Actor),
  situation(S, holds(at, Actor, Start)),
  named(Start, From),
  named(Destination, To).

verbclause(S, c(flee, "to", To)) :-
  action(S, flee),
  action(S, Verb),
  param(S, destination, Destination),
  named(Destination, To).

verbclause(S, c(pursue, Object, "to", To)) :-
  action(S, pursue),
  param(S, target, Target),
  param(S, destination, Destination),
  named(Target, Object),
  named(Destination, To).

verbclause(S, c(rescue, Object, "from", Aggressor, "and flee to", To)) :-
  action(S, rescue),
  param(S, target, Target),
  param(S, opponent, Opponent),
  param(S, destination, Destination),
  named(Target, Object),
  named(Opponent, Aggressor),
  named(Destination, To).

verbclause(S, c(escape, "from", Aggressor, "and flee to", To)) :-
  action(S, escape),
  param(S, actor, Actor),
  param(S, opponent, Opponent),
  param(S, destination, Destination),
  named(Opponent, Aggressor),
  named(Destination, To).

verbclause(S, c(steal, Object, from, Owner)) :-
  action(S, steal),
  param(S, target, Target),
  situation(S, holds(controlled_by, Target, Victim)),
  named(Target, Object),
  named(Victim, Owner).

% Motives:

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
  named(A, Angry),
  named(H, Hated).

motive(S, friendship(Friendly, Friend)) :-
  motivated(S, friendship(A, H)),
  named(A, Friendly),
  named(H, Friend).

motive(S, friendship(Friendly, Friend)) :-
  motivated(S, friendship(A, H)),
  named(A, Friendly),
  named(H, Friend).

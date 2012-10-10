% There's always exactly one result from a situation:
:- active_situation(S), 0 { result(S, success; failure; accident) } 0.
:- active_situation(S), 2 { result(S, success; failure; accident) }.

% Accidents can happen:
{ accident(S) } :- active_situation(S).
:- accident_limit(L), L { accident(S) }.

% Accidents can't happen alongside a reaction:
:- accident(S), some_reaction(S).

% Success will happen if nothing else is specified:
{ result(S, success) } :- situation(S).

% Accidents cause failure or an accidental result:
1 { result(S, accident), result(S, failure) } 1 :- accident(S).

% Normal reactions cause failure:
result(S, failure) :- result(r(S), success), reaction(S, active, Rxn).

% Passive reactions let the action succeed:
result(S, success) :- result(r(S), success), reaction(S, passive, Rxn).

% If a reaction fails, the initial action will succeed:
result(S, success) :- result(r(S), failure).
result(S, success) :- result(r(S), accident).

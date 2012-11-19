% --------- %
% Plot type %
% --------- %
ptype(revenge).

% ---------- %
% Parameters %
% ---------- %
plot_parameter(revenge, actor, character).
plot_parameter(revenge, subject, character).
plot_parameter(revenge, injury, situation).
plot_parameter(revenge, vengeance, base_situation).

plot_param_different(revenge, actor, subject).
plot_param_situation_follows(revenge, injury, vengeance, 2).
% ^ Require some action in between the attack and the vengeance.

% ----------- %
% Constraints %
% ----------- %
% Injury action involves the harmed party being harmed by the aggressor:
:-
  plot(revenge),
  plot_param(revenge, actor, Actor),
  plot_param(revenge, subject, Subject),
  plot_param(revenge, injury, S),
  { param(S, actor, Subject), harmful(S, Actor) } 1. % Both must hold.

% Vengeance action involves the harmed party taking revenge on the aggressor:
:-
  plot(revenge),
  plot_param(revenge, actor, Actor),
  plot_param(revenge, subject, Subject),
  plot_param(revenge, vengeance, S),
  { param(S, actor, Actor), harmful(S, Subject) } 1. % Both must hold.

% Fix the motive:
:-
  plot(revenge),
  plot_param(revenge, injury, I),
  plot_param(revenge, vengeance, V),
  { motivated_by_reciprocation(V, revenge(I)) } 0. % Must hold.

% -------------------------- %
% Success/failure conditions %
% -------------------------- %
plot_success(revenge) :-
  plot(revenge),
  plot_param(revenge, vengeance, S),
  result(S, success).
plot_failure(revenge) :- plot(revenge), not plot_success(revenge).

% ------------ %
% Valorization %
% ------------ %
plot_harmful(revenge, Subject) :-
  plot(revenge),
  plot_param(revenge, subject, Subject).

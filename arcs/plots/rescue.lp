% --------- %
% Plot type %
% --------- %
ptype(rescue).

% ---------- %
% Parameters %
% ---------- %
plot_parameter(rescue, actor, character).
plot_parameter(rescue, subject, character).
plot_parameter(rescue, antagonist, character).
plot_parameter(rescue, conflict, situation).
plot_parameter(rescue, escape, reaction_situation).

plot_param_different(rescue, actor, subject).
plot_param_different(rescue, actor, antagonist).
plot_param_different(rescue, subject, antagonist).
plot_param_different(rescue, conflict, escape).

% ----------- %
% Constraints %
% ----------- %
% Conflict action involves either the antagonist or the rescuer harming the
% other in some way (note that it may occur either before or after the escape):
:-
  plot(rescue),
  plot_param(rescue, actor, Actor),
  plot_param(rescue, antagonist, Antagonist),
  plot_param(rescue, conflict, S),
  {
    param(S, actor, Actor),
    harmful(S, Actor),
    param(S, actor, Antagonist),
    harmful(S, Antagonist)
  } 1. % At least two must hold.

:-
  plot(rescue),
  plot_param(rescue, conflict, S),
  param(S, actor, Actor),
  harmful(S, Actor).

% Escape action involves the rescuer rescuing the victim:
:-
  plot(rescue),
  plot_param(rescue, actor, Actor),
  plot_param(rescue, antagonist, Antagonist),
  plot_param(rescue, subject, Subject),
  plot_param(rescue, escape, S),
  {
    action(S, rescue),
    param(S, actor, Actor),
    param(S, opponent, Antagonist),
    param(S, target, Subject)
  } 3. % All four must hold.

% -------------------------- %
% Success/failure conditions %
% -------------------------- %
plot_success(rescue) :-
  plot(rescue),
  plot_param(rescue, escape, S),
  result(S, success).
plot_failure(rescue) :- plot(rescue), not plot_success(rescue).

% ------------ %
% Valorization %
% ------------ %
plot_harmful(rescue, Antagonist) :-
  plot(rescue),
  plot_param(rescue, antagonist, Antagonist).
plot_helpful(rescue, Subject) :-
  plot(rescue),
  plot_param(rescue, subject, Subject).

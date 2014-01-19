% Optionally choose one or more plots:
%{ plot(P) : ptype(P) }.
% DEBUG: ALL THE PLOTS!
%plot(P) :- ptype(P).
%plot(rescue).
plot(revenge).

% Bind parameters for chosen plots:
1 { plot_param(Plot, Name, C) : character(C) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, character).

1 { plot_param(Plot, Name, I) : item(I) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, item).

1 { plot_param(Plot, Name, L) : location(L) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, location).

1 { plot_param(Plot, Name, S) : situation(S) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, situation).

1 { plot_param(Plot, Name, S) : base_situation(S) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, base_situation).

1 { plot_param(Plot, Name, S) : reaction_situation(S) } 1 :-
  plot(Plot), plot_parameter(Plot, Name, reaction_situation).

:-
  plot(Plot),
  plot_param_different(Plot, First, Second),
  plot_param(Plot, First, X),
  plot_param(Plot, Second, X).

:-
  plot(Plot),
  plot_param_situation_follows(Plot, First, Second, MinElapsed),
  plot_param(Plot, First, X),
  plot_param(Plot, Second, Y),
  base_situation(X, BX),
  base_situation(Y, BY),
  BY - BX < MinElapsed + 1.

plot_param_situation_follows(Plot, First, Second, 0) :-
  plot_param_situation_follows(Plot, First, Second).

internal_error(
  "First plot parameter for situation_follows isn't a situation.",
  Plot,
  First
) :-
  plot(Plot),
  plot_param_situation_follows(Plot, First, Second, MinElapsed),
  plot_parameter(Plot, First, Type),
  { Type == situation, Type == base_situation } 0.

internal_error(
  "Second plot parameter for situation_follows isn't a situation.",
  Plot,
  Second
) :-
  plot(Plot),
  plot_param_situation_follows(Plot, First, Second, MinElapsed),
  plot_parameter(Plot, Second, Type),
  { Type == situation, Type == base_situation } 0.

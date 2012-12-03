schema(goal; act; state; belief).

%%%%%%%%
% GOAL %
%%%%%%%%

slot(goal, type, string).
required(slot(goal, type)).
value(
  goal,
  type,
  "C-Health"; "C-Hunger"; "C-Wealth"; "C-Location"; "C-Possess"; "C-Affect";
  "M-Health"; "Favor"; "Anti-Favor"; "Retract"; "Revenge"
).

slot(goal, actor, noun).
required(slot(goal, actor)).

slot(goal, object, noun).
required_when(
  slot(goal, object),
  slot(goal, type),
  "C-Health"; "C-Hunger"; "C-Location"; "C-Possess"; "C-Affect"; "M-Health";
  "Retract"
).

slot(goal, value, string).
required_when(
  slot(goal, value),
  slot(goal, type),
  "C-Health"; "C-Hunger"; "C-Wealth"; "C-Affect"
).
value_when(
  slot(goal, value),
  slot(goal, type),
  "C-Health",
  "Healthy"; "Injured"; "Dead"
).
value_when(
  slot(goal, value),
  slot(goal, type),
  "C-Hunger",
  "Hungry"; "Full"
).
value_when(
  slot(goal, value),
  slot(goal, type),
  "C-Wealth",
  "Wealthy"; "Average"; "Poor"
).
value_when(
  slot(goal, value),
  slot(goal, type),
  "C-Affect",
  "Positive"; "Negative"
).

slot(goal, scale, string).
required_when(
  slot(goal, scale),
  slot(goal, type),
  "C-Affect"
).
value_when(
  slot(goal, scale),
  slot(goal, type),
  "C-Affect",
  "Weak"; "Normal"; "Strong"
).

slot(goal, to, noun).
required_when(
  slot(goal, to),
  slot(goal, type),
  "C-Location"; "C-Possess"; "C-Affect"; "Anti-Favor"; "Revenge"
).

%%%%%%%
% ACT %
%%%%%%%

slot(act, type, string).
required(slot(act, type)).
value(
  act,
  type,
  "Fight"; "Kiss"; "Ingest"; "Move"; "PGive"; "AGive"; "PGet"; "AGet"; "MTrans";
  "Buy"; "Use"; "Transform"
).

slot(act, actor, noun).
required(slot(act, actor)).

slot(act, object, noun).
required_when(
  slot(act, object),
  slot(act, type),
  "Kiss"; "Ingest"; "Move"; "PGive"; "AGive"; "PGet"; "AGet"; "MTrans"; "Buy";
  "Use"; "Transform"
).

slot(act, to, noun).
required_when(
  slot(act, to),
  slot(act, type),
  "Fight"; "Ingest"; "Move"; "PGive"; "AGive"; "MTrans"; "Buy"; "Use";
  "Transform"
).

slot(act, from, noun).
required_when(
  slot(act, from),
  slot(act, type),
  "PGive"; "AGive"; "Buy"; "Transform"
).

%%%%%%%%%
% STATE %
%%%%%%%%%

slot(state, type, string).
required(slot(state, type)).
value(
  state,
  type,
  "Condition"; "Health"; "Hunger"; "Wealth"; "Location"; "Know"; "Possess";
  "Affect"; "Relation"; "Trait"
).

slot(state, actor, noun).
required(slot(state, actor)).

slot(state, object, noun).
required_when(
  slot(state, object),
  slot(state, type),
  "Location"; "Know"; "Possess"; "Relation"
).

slot(state, value, string).
required_when(
  slot(state, value),
  slot(state, type),
  "Condition"; "Health"; "Hunger"; "Wealth"; "Affect"; "Relation"; "Trait"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Condition",
  "Normal"; "Damaged"; "Broken"; "Spent"; "Asleep"; "Gone"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Health",
  "Healthy"; "Injured"; "Dead"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Hunger",
  "Hungry"; "Full"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Wealth",
  "Wealthy"; "Average"; "Poor"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Affect",
  "Positive"; "Negative"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Relation",
  "Sibling"; "Cousin"; "Parent"; "Child"; "Grandparent"; "Grandchild";
  "Aunt/Uncle"; "Nephew/Niece"
).
value_when(
  slot(state, value),
  slot(state, type),
  "Trait",
  "Quick-Tempered"; "Kind"; "Cruel"
).

%%%%%%%%%%
% BELIEF %
%%%%%%%%%%

slot(belief, type, string).
required(slot(belief, type)).
value(
  belief,
  type,
  "Predictive"; "Deductive"
).

slot(belief, actor, noun).
required(slot(belief, actor)).

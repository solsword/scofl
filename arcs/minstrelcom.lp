%----------------%
% Noun commands: %
%----------------%

noun_command(@join("new noun:", Name, ", Actor", ", true")) :-
  character(C), name(noun(C), Name).
noun_command(@join("new noun:", Name, ", Inanimate", ", true")) :-
  item(I), name(noun(I), Name).
noun_command(@join("new noun:", Name, ", Location", ", true")) :-
  location(L), name(noun(L), Name).

%----------------%
% Node commands: %
%----------------%

node_command(
  @join(
    "new node:",
    @id_join("step", S, "goal"),
    ", goal"
  )
) :-
  action(S, Any).

node_command(@join("new node:", @id_join("step", S, "act"), ", act")) :-
  an(S, Type).

node_command(
  @join(
    "new node:",
    @id_join("step", S, "state", State, Subj),
    ", state"
  )
) :-
  effect(S, causes(State, Subj), Intent).

node_command(
  @join(
    "new node:",
    @id_join("step", S, "state", Rel, Subj, Obj),
    ", state"
  )
) :-
  effect(S, causes(Rel, Subj, Obj), Intent).

%----------------%
% Edge commands: %
%----------------%

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "goal"), ",",
    @id_join("step", S, "act"),
    ", plans"
  )
) :-
  action(S, Any), an(S, T2).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "act"), ",",
    @id_join("step", S, "state", State, Subj),
    ",", Int
  )
) :-
  an(S, T1), tr_int(Intent, Int), effect(S, causes(State, Subj), Intent).


edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "act"), ",",
    @id_join("step", S, "state", Rel, Subj, Obj),
    ",", Int
  )
) :-
  an(S, T1), tr_int(Intent, Int), effect(S, causes(Rel, Subj, Obj), Intent).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", State, Subj), ",",
    @id_join("step", S, "goal"),
    ", achieves"
  )
) :-
  action(S, Any),
  result(S, success),
  effect(S, causes(State, Subj), intentional).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", Rel, Subj, Obj), ",",
    @id_join("step", S, "goal"),
    ", achieves"
  )
) :-
  action(S, Any),
  result(S, success),
  effect(S, causes(Rel, Subj, Obj), intentional).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", State, Subj), ",",
    @id_join("step", S, "goal"),
    ", thwarts"
  )
) :-
  action(S, Any),
  result(S, failure),
  effect(S, causes(State, Subj), accidental).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", Rel, Subj, Obj), ",",
    @id_join("step", S, "goal"),
    ", thwarts"
  )
) :-
  action(S, Any),
  result(S, failure),
  effect(S, causes(Rel, Subj, Obj), accidental).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", State, Subj), ",",
    @id_join("step", S, "goal"),
    ", thwarts"
  )
) :-
  action(S, Any),
  result(S, accident),
  effect(S, causes(State, Subj), accidental).

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "state", Rel, Subj, Obj), ",",
    @id_join("step", S, "goal"),
    ", thwarts"
  )
) :-
  action(S, Any),
  result(S, accident),
  effect(S, causes(Rel, Subj, Obj), accidental).

%----------------%
% Slot commands: %
%----------------%

% Goal slots (from both motives and/or actions):

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ", actor, ",
    Name
  )
) :-
  param(S, actor, Actor), name(noun(Actor), Name).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ", type, M-Health"
  )
) :-
  motivated(S, defend_against(H)),
  harmful(H, Victim).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ", object, ",
    Name
  )
) :-
  motivated(S, defend_against(H)),
  harmful(H, Victim),
  name(noun(Victim), Name).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ", type, ",
    Type
  )
) :-
  action(S, Act),
  tr_gtype(Act, Type),
  { motivated(S, defend_against(H)) } 0.

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ",", Slot, ",",
    Value
  )
) :-
  action(S, Act), tr_gfixed(Act, Slot, Value).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "goal"),
    ",", Slot, ",",
    Name
  )
) :-
  action(S, Act),
  param(S, Param, Noun),
  tr_gtrans(Act, Param, Slot),
  name(noun(Noun), Name).

% Action slots:

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "act"),
    ", type, ",
    Type
  )
) :-
  an(S, Type).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "act"),
    ",", Slot, ",",
    Value
  )
) :-
  anslot(S, Slot, Value).

% State slots (directly from effects):

tr_stype(status, "Health").
tr_sval(healthy, "Healthy").
tr_sval(injured, "Injured").
tr_sval(dead, "Dead").

tr_stype(condition, "Condition").
tr_sval(whole, "Normal").
tr_sval(broken, "Damaged").
tr_sval(destroyed, "Gone").

% "accessible_from" is ignored.
tr_rtype(at, "Location").
tr_robj(at, "object").

tr_rtype(captured_by, "Condition").
tr_rfixed(captured_by, "value", "Captured").

% "carried_by" and "owned_by" are ignored.
tr_rtype(controlled_by, "Possess").
tr_robj(controlled_by, "object").

tr_rtype(love, "Affect").
tr_rfixed(love, "value", "Positive").
tr_rfixed(love, "scale", "Strong").
tr_robj(love, "to").

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "state", SVal, Subj),
    ", type, ",
    St
  )
) :-
  effect(S, causes(SVal, Subj), Intent),
  _value(Stype, SVal),
  tr_stype(Stype, St).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "state", SVal, Subj),
    ", value, ",
    Val
  )
) :-
  effect(S, causes(SVal, Subj), Intent),
  _value(Stype, SVal),
  tr_sval(SVal, Val).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "state", Rel, Subj, Obj),
    ", type, ",
    Rt
  )
) :-
  effect(S, causes(Rel, Subj, Obj), Intent),
  tr_rtype(Rel, Rt).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "state", Rel, Subj, Obj),
    ",", Slot, ",",
    Value
  )
) :-
  effect(S, causes(Rel, Subj, Obj), Intent),
  tr_rfixed(Rel, Slot, Value).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "state", Rel, Subj, Obj),
    ",", Slot, ",",
    Name
  )
) :-
  effect(S, causes(Rel, Subj, Obj), Intent),
  name(noun(Obj), Name),
  tr_robj(Rel, Slot).

%--------------%
% Glue States: %
%--------------%

gluemotive(S, H, Name, OName, "Positive") :-
  motivated(S, gratitude(H)),
  param(S, actor, Actor),
  name(noun(Actor), Name),
  param(H, actor, Other),
  name(noun(Other), OName).

gluemotive(S, H, Name, OName, "Negative") :-
  motivated(S, revenge(H)),
  param(S, actor, Actor),
  name(noun(Actor), Name),
  param(H, actor, Other),
  name(noun(Other), OName).

gluemotive(S, none, Name, OName, "Positive") :-
  motivated(S, friendship(Other)),
  param(S, actor, Actor),
  name(noun(Actor), Name),
  name(noun(Other), OName).

gluemotive(S, none, Name, OName, "Negative") :-
  motivated(S, feud(Other)),
  param(S, actor, Actor),
  name(noun(Actor), Name),
  name(noun(Other), OName).

node_command(
  @join(
    "new node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", state"
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", type, Affect"
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", actor, ",
    Actor
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", value, ",
    Polarity
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", scale, Normal"
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

slot_command(
  @join(
    "update node:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", to, ",
    Other
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

edge_command(
  @join(
    "new edge:",
    @id_join("step", H, "act"), ",",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    ", accidents"
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity), H != none.

edge_command(
  @join(
    "new edge:",
    @id_join("step", S, "gluestate", H, Actor, Other, Polarity),
    @id_join("step", S, "goal"), ",",
    ", motivates"
  )
) :-
  gluemotive(S, H, Actor, Other, Polarity).

#begin_lua
function id_join(...)
  local t = {n=select('#', ...), ...}
  result = nil
  for i=1,t.n do
    s = tostring(t[i])
    if result == nil then
      result = s
    else
      result = result .. "_" .. s
    end
  end
  return result
end
#end_lua.

tr_int(intentional, "intends").
tr_int(accidental, "accidents").

%----------------%
% Node bindings: %
%----------------%

% Note that state nodes are handled directly by the effects-related rules in
% minstrelcom.lp

% This is pretty bogus...
tr_gtype(activate, "M-Health").
tr_gtrans(activate, actor, "object").
tr_atype(activate, "Use").
autotarget(activate).

tr_gtype(attack, "C-Health").
tr_gtrans(attack, target, "object").
tr_gfixed(attack, "value", "Injured").
tr_atype(attack, "Fight").
autotarget(attack).

% A bit of a hack...
tr_gtype(break, "C-Health").
tr_gtrans(break, target, "object").
tr_gfixed(break, "value", "Injured").
tr_atype(break, "Fight").
anslot(S, "to", Name) :-
  action(S, break),
  param(S, target, Itm),
  situation(S, holds(carried_by, Itm, Victim)),
  name(noun(Victim), Name).

tr_gtype(capture, "C-Possess").
tr_gtrans(capture, target, "object").
tr_gtrans(capture, actor, "to").
tr_atype(capture, "Fight").
autotarget(capture).

tr_gtype(defend, "M-Health").
tr_gtrans(defend, target, "object").
tr_atype(defend, "Fight").
tr_atrans(defend, opponent, "to").

% Skald doesn't have a good general-purpose item interaction goal...
% (C-Condition would be nice).
tr_gtype(destroy, "C-Health").
tr_gtrans(destroy, target, "object").
tr_gfixed(destroy, "value", "Dead").
tr_atype(destroy, "Use").
autotarget(destroy).

tr_gtype(escape, "M-Health").
tr_gtrans(escape, actor, "object").
tr_atype(escape, "Move").
tr_atrans(escape, actor, "object").
autotarget(escape).

tr_gtype(flee, "M-Health").
tr_gtrans(flee, actor, "object").
tr_atype(flee, "Move").
tr_atrans(flee, actor, "object").
autotarget(flee).

tr_gtype(give, "C-Possess").
tr_gtrans(give, item, "object").
tr_gtrans(give, target, "to").
tr_atype(give, "PGive").
tr_atrans(give, item, "object").
tr_atrans(give, target, "to").
tr_atrans(give, actor, "from").
autotarget(give).

% A bit hacky; would like M-Possess...
tr_gtype(guard, "C-Possess").
tr_gtrans(guard, target, "object").
anslot(S, "to", Name) :-
  action(S, guard),
  param(S, target, Itm),
  situation(S, holds(carried_by, Itm, Beneficiary)),
  name(noun(Beneficiary), Name).
tr_atype(guard, "Fight").
tr_atrans(guard, opponent, "to").

tr_gtype(heal, "C-Health").
tr_gtrans(heal, target, "object").
tr_gfixed(heal, "value", "Healthy").
% bit of a hack here too...
tr_atype(heal, "Kiss").
tr_atrans(heal, target, "object").

tr_gtype(kill, "C-Health").
tr_gtrans(kill, target, "object").
tr_gfixed(kill, "value", "Dead").
tr_atype(kill, "Fight").
autotarget(kill).

tr_gtype(obtain, "C-Possess").
tr_gtrans(obtain, target, "object").
tr_gtrans(obtain, actor, "to").
tr_atype(obtain, "PGet").
tr_atrans(obtain, target, "object").

% A bit weak perhaps?
tr_gtype(pursue, "C-Location").
tr_gtrans(pursue, destination, "to").
tr_atype(pursue, "Move").
tr_atrans(pursue, actor, "object").
autotarget(pursue).

% A bit of a hack...
tr_gtype(repair, "C-Health").
tr_gtrans(repair, target, "object").
tr_gfixed(repair, "value", "Healthy").
tr_atype(repair, "Use").
autotarget(repair).

tr_gtype(rescue, "M-Health").
tr_gtrans(rescue, target, "object").
tr_atype(rescue, "Move").
tr_atrans(rescue, target, "object").
tr_atrans(rescue, destination, "to").

tr_gtype(steal, "C-Possess").
tr_gtrans(steal, target, "object").
tr_gtrans(steal, actor, "to").
tr_atype(steal, "PGive").
tr_atrans(steal, target, "object").
tr_atrans(steal, actor, "to").
anslot(S, "from", Name) :-
  action(S, steal),
  param(S, target, Itm),
  situation(S, holds(carried_by, Itm, Victim)),
  name(noun(Victim), Name).

tr_gtype(travel, "C-Location").
tr_gtrans(travel, actor, "object").
tr_gtrans(travel, destination, "to").
tr_atype(travel, "Move").
tr_atrans(travel, actor, "object").
tr_atrans(travel, destination, "to").

an(S, A) :- action(S, Act), tr_atype(Act, A).

anslot(S, "actor", Name) :-
  param(S, actor, Thing),
  name(noun(Thing), Name).

anslot(S, "to", Name) :-
  param(S, target, chr(C)),
  name(noun(chr(C)), Name),
  action(S, Act),
  autotarget(Act).
anslot(S, "object", Name) :-
  param(S, target, itm(I)),
  name(noun(itm(I)), Name),
  action(S, Act),
  autotarget(Act).
anslot(S, "to", Name) :-
  param(S, destination, loc(L)),
  name(noun(loc(L)), Name),
  action(S, Act),
  autotarget(Act).

anslot(S, Slot, Name) :-
  action(S, Act),
  tr_atrans(Act, Param, Slot),
  param(S, Param, Noun),
  name(noun(Noun), Name).

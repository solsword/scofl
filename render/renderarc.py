#!/usr/bin/env python3

import snakenest.parse

from words import syn, past_tense, present_tense, past_continuous_tense

target = "../arcs/out/raw"

chrnames = [
  "Awyn",
  "Belkon",
  "Cyrus",
  "Dara",
]

itmnames = [
  "Farboots",
  "Gnome-hammer",
  "Heavy Edge",
]

locnames = [
  "Perea",
  "Quarr",
  "Rulem",
  "Somyr",
]

def concrete(predicate):
  if predicate.name == "chr":
    return ("chr", chrnames[predicate[0].name - 1])
  elif predicate.name == "itm":
    return ("itm", itmnames[predicate[0].name - 1])
  elif predicate.name == "loc":
    return ("loc", locnames[predicate[0].name - 1])

with open(target) as fin:
  raw = fin.read()
ans = snakenest.parse.parse_raw(raw)[0]

raw_actions = ans.lookup("action")
raw_params = ans.lookup("param")

timesteps = set()
for act in raw_actions:
  if act[0].name != 'r':
    ts = act[0].name
    assert(ts == int(ts))
    timesteps.add(ts)

def noun(
  N,
  reflexive=False,
  lastrefs={
    'P': None,
    'T': None,
    'prP': None,
    'prT': None,
  }
):
  kind = 'T'
  det = "the "
  prn = "it"
  useprn = False
  if reflexive:
    prn = "itself"
    useprn = True

  if type(N) == tuple:
    if N[0] == 'chr':
      kind = 'P'
      det = ''
      prn = "'e"
      if reflexive:
        prn = "'eirself"
  elif type(N) == str:
    N = (None, N)
  else:
    raise TypeError("Argument 'N' must be either a string or a tuple.")

  if lastrefs[kind] == N or lastrefs['pr' + kind] == N:
    useprn = True
  lastrefs['pr' + kind] = lastrefs[kind]
  lastrefs[kind] = N
  if useprn:
    return prn
  return det + N[1]

def clause(action, params):
  if 'target' in params:
    if params['target'] == params['actor']:
      return "{} {} {}".format(
        noun(params['actor']),
        past_tense(action),
        noun(params['target'], reflexive=True)
      )
    return "{} {} {}".format(
      noun(params['actor']),
      past_tense(action),
      noun(params['target'])
    )
  elif 'destination' in params:
    return "{} {} to {}".format(
      noun(params['actor']),
      past_tense(action),
      noun(params['destination'])
    )

for t in sorted(timesteps):
  action = None
  reaction = None
  params = {}
  rparams = {}
  for act in raw_actions:
    if act[0].name == 'r':
      if act[0][0].name == t:
        reaction = act[1].name
    elif act[0].name == t:
      action = act[1].name
  for p in raw_params:
    if p[0].name == 'r':
      if p[0][0].name == t:
        rparams[p[1].name] = concrete(p[2])
    elif p[0].name == t:
      params[p[1].name] = concrete(p[2])
  print(clause(action, params), end='')
  if reaction:
    print(', but ', end='')
    print(clause(reaction, rparams), end='')
  print('.')

#  if action == "activate":
#    "activate",
#    "attack",
#    "break",
#    "capture",
#    "defend",
#    "destroy",
#    "escape",
#    "flee",
#    "give",
#    "guard",
#    "heal",
#    "kill",
#    "obtain",
#    "pursue",
#    "repair",
#    "rescue",
#    "steal",
#    "travel",

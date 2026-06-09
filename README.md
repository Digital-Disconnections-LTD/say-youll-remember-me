# Say You'll Remember Me

*A public memory system dressed like a doomed summer romance.*

In this story, memory is not a cloud. It is not a vibe. It is not a machine
making up a plausible childhood because the real one is inconvenient to fetch.

It is a crew.

They live in a city where everyone is trying to sell you your own life back in
smaller pieces. The platforms want summary without source. The dashboards want
confidence without receipts. The neat little assistant wants to say, "trust me,
I remember," while standing in an empty room with somebody else's lipstick on
its collar.

This repo refuses that whole arrangement.

`say-youll-remember-me` is the public export of a memory architecture built on a
simple criminal ethic: if you are going to remember something, you keep the
evidence. If you wake up cold, you wake up with provenance. If a fact matters,
it must be able to walk back through the alley, open the right door, and put its
finger on the exact file that made it true.

That is the romance.

That is the racket.

That is the whole show.

## The Cast

Every melodrama needs its people.

- `The Source Files` are the girl at the center of town. Everybody talks about
  her. She is the only one with the diary pages, the dates, the phone numbers,
  the blood on the hem. If she disappears, everybody else's story loses
  standing.
- `The Windows` are scenes cut out of the long night. They keep line numbers,
  hashes, and boundaries so the memory can move without pretending the whole
  evening happened in one room.
- `Embeddings` are gossip. Sometimes very good gossip. They help you find the
  right street faster. They are not the law.
- `Lexical search` is the old friend who still remembers the exact phrasing of
  the fight.
- `Relations` and `HippoRAG` are the switchboard, the family tree, the debt
  ledger, the seating chart at the wedding where everyone secretly hates each
  other. They help route attention toward the loaded scene. They do not get to
  rewrite that scene.
- `Compact Memory` is the note folded into the lining of your coat before you
  run. The night was too big to carry whole, so you keep only what changes what
  you do next.
- `The Wake Bundle` is the opening shot of the next episode. Before anybody says
  a word, you already know your name, your people, the unfinished business, and
  what changed while you were gone.
- `Recall` is the one honest witness in a corrupt town. It does not just answer.
  It points.

## How The Plot Moves

This is how the city keeps itself from slipping into amnesia:

1. Something real enters the system as source. A file, note, transcript,
   document, profile, thread, customer record, project brief, whatever the
   living thing is.
2. The source is fingerprinted so later nobody can lie about whether it changed.
3. The source is chunked into stable windows with line spans and hashes, because
   memory without edges turns into soup.
4. Derived layers spin up around those windows: embeddings, lexical indexes,
   graph edges, relation rows, routing hints.
5. Candidate memory gets staged, reviewed, compressed, promoted, or thrown back
   if it cannot justify its existence.
6. At wake, the system assembles a bounded orientation packet: identity,
   continuity, scoped updates, relevant reminders, and just enough context to
   begin without bluffing.
7. When something load-bearing comes back from recall, the source gets re-read
   before action. Not because the system is timid. Because it is honest.
8. When the source changes, derived layers rebuild. The database can recover.
   The files are the body.

That rebuild loop matters. This repo does not treat memory as a sacred final
summary. It treats memory as a disciplined self-correction habit. The source
changes, the windows change, the graph shifts, compact memory gets refreshed,
the next wake remembers differently. No mysticism. Just continuity with receipts.

## The House Rules

This house has a few hard rules:

- Summary never outranks source.
- Retrieval is routing, not authority.
- A graph edge without provenance is just a beautifully typeset rumor.
- Memory should be scoped before it is searched.
- Wake should feel like remembering, not discovering.
- If a fact cannot tell you where it came from, it does not get to make
  decisions.

Plenty of systems can sound persuasive. That is not rare. The rare thing is a
system that can still point to the line when the lights come up.

## What Was Smuggled Out

This public repo copies the shape of a real production memory system into a safe
separate home. Nothing in production was edited to make this. The live material
was copied, distilled, and published here so the pattern can stand on its own.

Inside the repo, the contraband is laid out in three piles:

- `real-system/` holds the production-shaped policies, schema notes, rebuild
  material, wake adapter pieces, and the memory landscape that informed the
  design.
- `src/source_linked_memory/` holds a small portable demo implementation that
  proves the contract without dragging the whole live organism into public view.
- `docs/` holds the map for anyone who wants the legend after they finish the
  story.

What is not here: credentials, private journals, customer data, live database
dumps, raw internal transcripts, or any secret whose only purpose is privileged
access. The omission ledger is in
`docs/private-material-substitutions.md`.

## Not Just For Agents

This thing was born in an agent system, but it is not trapped there.

It works for teams. It works for customers. It works for projects, archives,
research notebooks, operations, family records, personal files, and any other
place where "I remember" ought to mean "I can show you why."

The pattern is general:

- keep raw source canonical
- chunk it with stable anchors
- derive indexes and graph structure from it
- compress only what changes the next action
- assemble bounded wake context before work starts
- return to source whenever the answer matters

You can swap in different retrieval engines. You can change providers. You can
redraw the graph. You can rebuild the whole database from scratch. What you do
not get to do, if you want this to stay honest, is sever memory from the file
that made it true.

## If You Want The Machinery

If you are here for implementation instead of myth, the code is already waiting.

- Start in `src/source_linked_memory/`.
- Read the copied rebuild material in `real-system/controlled-memory-rebuild/`.
- Read the wake assembly path in `real-system/adapter/wake_bundle.sh`.
- Run the orientation demo in `scripts/demo_orientation.py`.

Quick run:

```bash
python3 scripts/demo_orientation.py \
  --memory-root examples/memory \
  --query "what should I know before editing the demo client site?"
```

Tests:

```bash
PYTHONPATH=src python3 -m unittest discover -s tests
```

Local install:

```bash
python3 -m pip install -e .
```

## The Last Line

Memory is allowed to be compact.

Memory is allowed to be indexed.

Memory is allowed to flirt with embeddings, graph edges, rerankers, and all the
other pretty things that gather outside the club.

Memory is not allowed to forget where it came from.

If it cannot point back to source, it is not memory.

It is a rumor with better lighting.

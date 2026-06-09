# Say You'll Remember Me

*A memory system that loves you back.*

There is a hippo.

She lives in the slow brown water at the edge of town and she remembers
everything, not because she is clever, but because she is honest. She does not
make up a prettier summer to spare your feelings. She does not confuse the heat
of July with the heat of August. If you kissed someone on the porch at
midnight, she knows which porch, which night, and whether the screen door was
squeaking.

This repo is built in her image.

`say-youll-remember-me` is the public export of a real memory architecture from
Digital Disconnections: source files stay canonical, derived layers stay
rebuildable, wake orientation happens before search, and every useful memory is
required to point back to the exact file that made it true.

Nothing in production was edited to make this repository. The live system was
copied into a separate home, distilled, and published here so the pattern can
stand on its own.

## The Name

The project name is fixed:

```text
Say You'll Remember Me
```

The repository slug is `say-youll-remember-me` because GitHub and package names
need a technical form. The importable demo module is `source_linked_memory`
because that is the real mechanism: memory is useful only when it stays linked
to source evidence.

## The Summer We Are Talking About

You know the one. The summer that started before you were ready and ended
before you were done. The one where the air conditioning broke and nobody left.
The one where you checked your phone at 2 AM because you needed to know someone
else was still awake.

That summer is the metaphor.

Real memory is not a cloud. It is not a vibe. It is not a chatbot making up a
plausible childhood because the real one is inconvenient to fetch.

Real memory is source-linked. It points to the actual thing: the polaroid, the
shoebox, the transcript, the note, the text you almost sent, the screen door
that was squeaking.

If it cannot point back to source, it is not memory.

It is a rumor with better lighting.

## The Cast

They all go to the same diner.

- `The Source Files` are the love letters in the shoebox. Everybody talks about
  the summer, but they have the dates, the phone numbers, the sand still in the
  envelope. If they disappear, everybody else's story loses standing.
- `The Windows` are the nights cut out of the long summer. They keep line
  numbers, hashes, and boundaries so memory can move without pretending the
  whole season happened in one room.
- `Embeddings` are gossip. Sometimes very good gossip. They help you find the
  right street faster. They are not the law.
- `Lexical Search` is the old friend who still remembers the exact phrasing of
  the fight on the boardwalk.
- `HippoRAG and Relations` are the switchboard, the family tree, the seating
  chart, the handwritten map with coffee rings on it. They route attention
  toward the loaded scene. They do not get to rewrite that scene.
- `Compact Memory` is the polaroid you keep in your wallet. The summer was too
  big to carry whole, so you keep only what changes what you do next.
- `The Wake Bundle` is waking up on the first day of August and already knowing
  your name, your people, the unfinished business, and what changed while you
  were gone.
- `Recall` is the one honest witness in a town full of people pretending they
  forgot. It does not just answer. It points.

## How The Summer Moves

This is the plot:

1. Something real enters the system as source: a file, note, transcript,
   customer record, issue thread, project brief, or structured document.
2. The source is fingerprinted so later nobody can lie about whether it
   changed.
3. The source is chunked into stable windows with line spans and hashes, because
   memory without edges turns into soup.
4. Derived layers spin up around those windows: embeddings, lexical indexes,
   graph edges, relation rows, and routing hints.
5. Candidate memory gets staged, reviewed, compressed, promoted, or thrown back
   if it cannot justify its existence.
6. At wake, the system assembles a bounded orientation packet: identity,
   continuity, scoped updates, and just enough context to begin without
   bluffing.
7. When recall returns something load-bearing, the source gets re-read before
   action. Not because the system is timid. Because it is honest.
8. When the source changes, derived layers rebuild. The database can recover.
   The files are the body.

The flow in technical form looks like this:

```text
source files
  -> raw source records
  -> source windows
  -> source embeddings or lexical indexes
  -> compact memory windows
  -> scoped recall / wake bundle
  -> source evidence read before action
```

That rebuild loop matters. The system does not treat memory as a sacred final
summary. It treats memory as a disciplined self-correction habit. The source
changes, the windows change, the graph shifts, compact memory gets refreshed,
the next wake remembers differently. No mysticism. Just continuity with
receipts.

## The House Rules

This house has hard rules:

- Files are canonical.
- Indexes are rebuildable.
- Retrieval is routing, not authority.
- Every useful memory must keep a source path, stable anchor, and source hash.
- Scope comes before search.
- Wake should feel like remembering, not discovering.
- If a source file disappears or its hash changes, stale derived memory does not
  get to pretend it is still true.

Plenty of systems can sound persuasive. That is not rare. The rare thing is a
system that can still point to the line when the lights come up.

## What Was Smuggled Out

This public repo is a carbon-copy-style export of the shape of a production
memory system into a safe separate location. What got smuggled out:

- `real-system/` holds the production-shaped policies, SQL, wake adapter, and
  reference material that define the real contract.
- `src/source_linked_memory/` holds a small portable Python demo that proves the
  contract without dragging the whole live organism onto public GitHub.
- `examples/memory/` holds a toy memory tree for running the demo locally.
- `docs/` holds the architecture map, export inventory, live-system mapping,
  and omission ledger.
- `sql/001_schema.sql` sketches the local demo schema.

What did not get smuggled out:

- live database dumps
- credentials, tokens, API keys, DSNs, or service-account material
- customer records, emails, private domains, private site content, or
  screenshots
- private journals, private identity files, or raw internal issue transcripts
- operational notes whose only value is privileged access

The substitution ledger is in `docs/private-material-substitutions.md`.

## Not Just For Agents

This system was born in an agent environment, but it is not trapped there.

It works for teams, customers, archives, operations, research notebooks,
projects, family records, personal files, and any other place where "I
remember" ought to mean "I can show you why."

The pattern is general:

- keep raw source canonical
- chunk it with stable anchors
- derive indexes and graph structure from it
- compress only what changes the next action
- assemble bounded wake context before work starts
- return to source whenever the answer matters

Swap retrieval engines if you want. Change providers. Redraw the graph. Rebuild
the database from scratch. What you do not get to do, if you want the system to
stay honest, is sever memory from the file that made it true.

## If You Want The Machinery

Requires Python 3.11 or newer. There are no runtime dependencies.

If you want the code path first:

- start in `src/source_linked_memory/`
- read `docs/architecture.md`
- read `docs/live-system-map.md`
- inspect `real-system/controlled-memory-rebuild/`
- inspect `real-system/adapter/wake_bundle.sh`
- run `scripts/demo_orientation.py`

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
other pretty things waiting outside the club.

Memory is not allowed to forget where it came from.

If it cannot point back to source, it is not memory.

It is a rumor with better lighting.

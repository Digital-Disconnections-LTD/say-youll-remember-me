# Say You'll Remember Me

Source-linked memory for agents, teams, customers, projects, and anything else
that needs continuity without fiction.

Most memory systems want you to trust the summary and forget the source. This
one refuses. `say-youll-remember-me` is the public export of the memory shape we
actually use at Digital Disconnections: files stay canonical, chunks stay
addressable, embeddings and graph edges stay derived, wake bundles stay bounded,
and every useful answer can walk you back to the evidence that made it.

If the source disappears, the memory loses standing.

> The database can be rebuilt. The files are the memory.

## What This Is

This repo is not a hosted memory SaaS, a dashboard, or a vibes-only demo.
It is a carbon-copy-style public export of a real memory architecture:

- raw files remain canonical
- source windows chunk those files with stable line spans and hashes
- embeddings, lexical indexes, and graph structure are derived layers
- compact memory windows make recall loadable at wake time
- recall returns source metadata, not just an answer
- orientation loads identity, shared context, scoped updates, and relevant
  recall before work starts

The production-shaped material lives in `real-system/`. The runnable Python demo
in `src/source_linked_memory/` exists so the repo can prove the contract in a
small, inspectable package.

## Why The Name

The name is not decorative. Good memory is not a pile of detached summaries. It
is continuity under cold wake, interruption, handoff, and return. The question
is not whether a system can generate something that sounds familiar. The
question is whether it can wake up and answer:

1. What do I know?
2. Why do I think I know it?
3. Where is the source?

GitHub and package names need a slug, so the repository is
`say-youll-remember-me`. The demo module is `source_linked_memory`, because that
is the actual mechanism.

## Blue Jeans, Red Flags

Memory goes bad in predictable ways:

- the summary becomes more authoritative than the source
- embeddings get treated like truth instead of routing
- one giant context pool replaces scoped recall
- the wake starts blank and asks retrieval to invent continuity afterward
- private operational memory gets flattened into product copy

This repo is built against those failure modes. It keeps the stains on the
denim: file paths, line spans, hashes, scope, and provenance.

## Architecture In One Pass

```text
source files
  -> raw source records
  -> source windows
  -> embeddings / lexical indexes / graph edges
  -> compact memory windows
  -> scoped recall / wake bundle
  -> source evidence re-read before action
```

The index is a router, not the authority. The graph is allowed to help. The
graph is not allowed to lie.

## How The Memory Stays Honest

Each source window carries enough metadata to prove where it came from:

- `source_path`
- `source_sha256`
- `window_id`
- `start_line`
- `end_line`
- `content_sha256`

If the file changes, the hash changes. If the file disappears, the derived row
is stale. That is the whole point: recall should degrade into caution, not bluff.

The copied real-system SQL and notes show the same rule across:

- raw source records
- source windows
- compact memory windows
- staging/evaluation layers
- embedding rows with source metadata

## Graphs, Relations, and HippoRAG

The live memory shape is not flat search. The real system carries `facts`,
`relations`, source chunks, scoped wake state, and compact windows. Retrieval is
scoped first, ranked second, and grounded always.

This public export stays provider-agnostic on purpose. The demo uses plain token
overlap because inspectability matters. The real contract is broad enough for:

- pgvector
- BM25
- trigram search
- graph rerankers
- HippoRAG-style knowledge-graph routing

Swap the retrieval engine if you want. Keep the provenance contract. A graph
edge without a path back to source is still just a prettier hallucination.

## The Self-Improvement Loop

The memory system is not static storage. It is a controlled loop:

1. Ingest raw source.
2. Chunk it into stable windows with hashes and anchors.
3. Build derived indexes, embeddings, and relations.
4. Draft compact memory or staged candidate facts.
5. Review and promote what deserves durable scope.
6. Assemble a bounded wake bundle.
7. Re-read source before acting on load-bearing hits.
8. Rebuild derived layers whenever the source changes.

That loop shows up across the copied rebuild material in
`real-system/controlled-memory-rebuild/`, including staging fields, evaluation
paths, namespace design, and the wake adapter boundary.

## Wake First, Search Second

Remembering starts before search. The copied
`real-system/adapter/wake_bundle.sh` assembles bounded context at cold wake from:

1. identity
2. owner-scoped continuity
3. facts new or updated since the last wake
4. spaced re-encounter material
5. a watermark update after assembly

That is the design bet underneath the whole repo: a good wake should feel like
remembering, not discovering.

## Not Just For Agents

This export comes from an agent system, but the architecture is general. It can
be used anywhere continuity needs evidence:

- personal knowledge files
- multi-agent orchestration
- customer and domain operations
- research notebooks
- project memory
- internal company memory
- any workflow where recall should cite the thing it recalls

The details in `real-system/` are Paperclip-shaped because that is the live
source. The contract itself is wider than Paperclip.

## Repo Map

- `docs/architecture.md`: concise system explanation
- `docs/export-inventory.md`: what was copied and why
- `docs/live-system-map.md`: how the copied real-system pieces fit together
- `docs/private-material-substitutions.md`: public-safe omission ledger
- `real-system/`: copied production-shaped policies, SQL, namespace docs, and
  wake adapter material
- `src/source_linked_memory/`: portable demo implementation
- `examples/memory/`: minimal example memory tree
- `scripts/demo_orientation.py`: runnable wake/orientation demo
- `sql/001_schema.sql`: portable schema sketch
- `tests/test_demo.py`: focused tests for the demo package

## Copied Real-System Pieces

The center of gravity is the `real-system/` tree:

- `policy/POLICY_NO_EMBEDDINGS.md`
- `policy/MEMORY_HYGIENE.md`
- `controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md`
- `controlled-memory-rebuild/002_raw_source_import.sql`
- `controlled-memory-rebuild/003_source_windows_embeddings.sql`
- `controlled-memory-rebuild/004_compact_memory_windows.sql`
- `controlled-memory-rebuild/SCHEMA_NOTES.md`
- `controlled-memory-rebuild/VALIDATION.md`
- `adapter/wake_bundle.sh`
- `reference/memory-landscape.md`

These are copied so the public repo exposes the real shape: source-link policy,
namespace design, rebuild flow, compact memory windows, wake-time orientation,
and the broader memory-provider landscape that informed the contract.

## Quickstart

Requires Python 3.11 or newer. There are no runtime dependencies.

Run the orientation demo:

```bash
python3 scripts/demo_orientation.py \
  --memory-root examples/memory \
  --query "what should I know before editing the demo client site?"
```

Run the tests:

```bash
PYTHONPATH=src python3 -m unittest discover -s tests
```

Install locally:

```bash
python3 -m pip install -e .
```

## Summertime Sadness

What is intentionally not in this public export:

- live database dumps
- credentials, tokens, API keys, DSNs, and service-account material
- customer records, emails, domains, private site content, or screenshots
- agent-private journals and identity files
- raw Paperclip issue/comment transcripts
- infrastructure notes whose only value is privileged operational access

The omission ledger is `docs/private-material-substitutions.md`.

## The Contract

Memory is allowed to be compact.

Memory is allowed to be indexed.

Memory is allowed to use embeddings, graph edges, rerankers, and scoped recall.

Memory is not allowed to forget where it came from.

If a memory cannot tell you its source, it is not memory. It is rumor with a
database row.

## GitHub

- Repo: https://github.com/Digital-Disconnections-LTD/say-youll-remember-me
- Branch: `main`
- Visibility: `public`

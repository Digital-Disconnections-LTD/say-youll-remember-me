# Say You'll Remember Me

Source-linked fleet memory from Digital Disconnections.

This is the public export of the memory system shape we actually use: source
files as the durable record, rebuildable indexes as the recall layer, and
wake-time orientation as the first read path. The point is simple: an agent
should not have to trust a floating summary of its own life. It should be able
to ask what it remembers, see where the memory came from, and read the source
before acting on it.

The project name is fixed:

```text
Say You'll Remember Me
```

The repository and package slug is `say-youll-remember-me`, because package and
GitHub names need a technical form. The importable demo module is
`source_linked_memory`, because that names the mechanism: memory rows are useful
only when they remain linked to source evidence.

## What This Is

Say You'll Remember Me is not a hosted memory service, a dashboard, or a pile of
private notes stripped down into a demo. It is a carbon-copy-style public export
of the architecture we use to keep agent memory grounded:

- raw files remain canonical
- source windows chunk those files with stable line spans and hashes
- embeddings or lexical indexes are derived, not authoritative
- compact memory windows consolidate evidence into bounded recall units
- recall returns source metadata, not just an answer
- wake orientation loads identity, shared context, scoped updates, and recall
  hits before an agent starts work

The database can be rebuilt. The files are the memory.

## Architecture In One Pass

```text
source files
  -> raw source records
  -> source windows
  -> source embeddings or lexical indexes
  -> compact memory windows
  -> scoped recall / wake bundle
  -> source evidence read before action
```

The production shape is copied under `real-system/`. The small Python package in
`src/source_linked_memory/` is a runnable local demo of the same invariants.

### Chunking

Source files are split into windows with:

- `source_path`
- `source_sha256`
- `window_id`
- `start_line`
- `end_line`
- `content_sha256`

If the source file changes, the hash changes. If the source file disappears, the
derived memory row should not be trusted. Chunking makes memory addressable
without turning the chunk into the source of truth.

### Provenance

Every useful memory result carries its source. In the demo, a recall hit prints
the file path, line anchor, and source sha256. In the copied real-system SQL, the
same rule appears as source records, source windows, compact windows, and
embedding rows that keep their backing source metadata.

### Recall

Recall is a router back to evidence. The demo uses plain token overlap so the
mechanics stay inspectable. A production deployment can use pgvector, BM25,
trigram search, graph ranking, or another retrieval layer, but the retrieval
result still has to point back to the source that justified it.

### Orientation

Agents do not start from a blank prompt and search later. A wake assembles
bounded context first: identity, company baseline, owner-scoped facts,
since-last-wake updates, spaced re-encounters, and relevant scoped memory. The
copied `real-system/adapter/wake_bundle.sh` shows that read path.

### Consolidation

Consolidation turns raw material into smaller, reviewed context windows. It does
not replace the raw source. A compact memory window is useful because it is
short enough to load and still traceable enough to audit.

## Repo Map

```text
docs/
  architecture.md
  export-inventory.md
  live-system-map.md
  private-material-substitutions.md

real-system/
  adapter/wake_bundle.sh
  controlled-memory-rebuild/*.sql
  controlled-memory-rebuild/*.md
  policy/*.md
  reference/memory-landscape.md

src/source_linked_memory/
  chunking.py
  index.py
  orientation.py
  recall.py

examples/memory/
  self/
  company/
  modules/
  sources/

scripts/
  demo_orientation.py

sql/
  001_schema.sql

tests/
  test_demo.py
```

## Copied Real-System Pieces

The `real-system/` tree is the center of this export:

- `real-system/policy/POLICY_NO_EMBEDDINGS.md` records the source-link rule.
- `real-system/policy/MEMORY_HYGIENE.md` records the memory hygiene rule.
- `real-system/controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md` maps scopes,
  source URI shapes, database namespace, and adapter boundaries.
- `real-system/controlled-memory-rebuild/002_raw_source_import.sql` models raw
  source records.
- `real-system/controlled-memory-rebuild/003_source_windows_embeddings.sql`
  models source windows and embeddings.
- `real-system/controlled-memory-rebuild/004_compact_memory_windows.sql` models
  compact memory windows and compact embeddings.
- `real-system/adapter/wake_bundle.sh` shows the wake-orientation path.
- `real-system/reference/memory-landscape.md` captures the provider landscape
  that shaped the control-plane contract.

The demo package exists so the public repo can be run locally. It is not the
replacement for the copied production shape.

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

Install locally for experimentation:

```bash
python3 -m pip install -e .
```

## What Was Omitted

This repository does not publish material that cannot belong on public GitHub:

- live database dumps
- credentials, tokens, API keys, DSNs, and service-account material
- customer records, emails, private domains, private site content, or screenshots
- agent-private memory files, journals, and identity files
- raw Paperclip issue/comment transcripts
- infrastructure notes whose only value is private operational access

The ledger is in `docs/private-material-substitutions.md`.

## The Contract

Memory is allowed to be compact. It is allowed to be indexed. It is allowed to
be searched.

It is not allowed to become detached from where it came from.

If a memory cannot tell you its source, it is not memory. It is rumor with a
database row.

## GitHub Details

- Repo: https://github.com/Digital-Disconnections-LTD/say-youll-remember-me
- Branch: `main`
- Visibility: `public`

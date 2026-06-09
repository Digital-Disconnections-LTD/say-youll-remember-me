# Say You'll Remember Me

Source-linked fleet memory from Digital Disconnections.

This repo is the public export of the memory system shape we actually use: plain
files as the durable record, source-linked database rows as the retrieval layer,
and wake-time orientation as the read path. The identity is fixed:

```text
Say You'll Remember Me
```

The technical slug is `say-youll-remember-me`. The importable demo module remains
`source_linked_memory` because it describes the core mechanism and keeps the
working code boring.

## What This Is

The live system is not a product dashboard and not a hosted memory SaaS. It is a
small set of operational rules and source files:

- Source files stay authoritative.
- Every derived memory row points back to source metadata.
- Recall is a router back to evidence, not the final authority.
- A wake starts with identity, company context, and bounded scope context.
- Embeddings are permitted only when they keep their source link.
- Raw source, source windows, compact windows, and wake bundles are separate layers.

This repo now carries that shape directly instead of pretending it is only a
synthetic public demo.

## Repo Map

```text
docs/
  architecture.md        Design model and data flow
  export-inventory.md    What was copied and what was omitted
  live-system-map.md     Where the copied real pieces sit
  private-material-substitutions.md
real-system/
  adapter/wake_bundle.sh
  controlled-memory-rebuild/*.sql
  controlled-memory-rebuild/*.md
  policy/*.md
  reference/memory-landscape.md
src/source_linked_memory/
  chunking.py            Runnable source-window demo code
  index.py
  orientation.py
  recall.py
examples/
  memory/                Small example tree for the runnable smoke test
scripts/
  demo_orientation.py
sql/
  001_schema.sql         Portable schema sketch for the demo
tests/
  test_demo.py
```

## Real System Shape

The copied files under `real-system/` are the important part of this export.
They show the production shape without editing production in place:

- `real-system/policy/POLICY_NO_EMBEDDINGS.md`: the actual source-link rule.
- `real-system/policy/MEMORY_HYGIENE.md`: the actual memory hygiene rule.
- `real-system/controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md`: scope names,
  source URI shapes, database namespace, and adapter boundary.
- `real-system/controlled-memory-rebuild/003_source_windows_embeddings.sql`:
  grounded source windows plus embeddings.
- `real-system/controlled-memory-rebuild/004_compact_memory_windows.sql`:
  compact prompt/retrieval windows backed by source windows.
- `real-system/adapter/wake_bundle.sh`: the wake-orientation read path.
- `real-system/reference/memory-landscape.md`: the provider landscape that
  shaped the contract.

The runnable Python package is still here because a public repo needs something
people can execute locally, but it is no longer the whole story.

## Quickstart

Requires Python 3.11+.

Run the demo orientation path:

```bash
python3 scripts/demo_orientation.py \
  --memory-root examples/memory \
  --query "what should I know before editing the demo client site?"
```

Run smoke tests:

```bash
PYTHONPATH=src python3 -m unittest discover -s tests
```

## What Was Not Published

The omissions are narrow and explicit:

- live database dumps
- credentials, tokens, API keys, DSNs, and service-account material
- customer records and private site content
- agent-private memory files and journals
- raw Paperclip issue/comment transcripts

See `docs/private-material-substitutions.md` for the ledger.

## GitHub Details

- Repo: https://github.com/Digital-Disconnections-LTD/say-youll-remember-me
- Branch: `main`
- Visibility: `public`

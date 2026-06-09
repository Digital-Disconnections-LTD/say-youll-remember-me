# Export Inventory

This repo is a public carbon-copy-style export of the Digital Disconnections
memory system shape. It is not a live production checkout, and production memory
infrastructure was not edited in place.

## Copied From The Real System

- `real-system/policy/POLICY_NO_EMBEDDINGS.md`
- `real-system/policy/MEMORY_HYGIENE.md`
- `real-system/controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md`
- `real-system/controlled-memory-rebuild/001_dream_staging_fields.sql`
- `real-system/controlled-memory-rebuild/002_raw_source_import.sql`
- `real-system/controlled-memory-rebuild/003_source_windows_embeddings.sql`
- `real-system/controlled-memory-rebuild/004_compact_memory_windows.sql`
- `real-system/controlled-memory-rebuild/SCHEMA_NOTES.md`
- `real-system/controlled-memory-rebuild/VALIDATION.md`
- `real-system/adapter/wake_bundle.sh`
- `real-system/reference/memory-landscape.md`

These files were copied from the separate live source tree into this repo. Their
job is to expose the actual shape: namespace, source windows, compact memory
windows, source-link policy, wake orientation, and provider landscape.

## Runnable Demo Layer

The package under `src/source_linked_memory/`, the tiny `examples/memory/` tree,
and `sql/001_schema.sql` remain a small executable demo. They are intentionally
lighter than `real-system/` because their purpose is smoke-testable mechanics:

- chunk a source file into deterministic windows
- keep source hashes and line spans
- rank recall candidates
- assemble a bounded orientation bundle

## Omitted Because Public GitHub Cannot Carry Them

- live database dumps
- credentials, tokens, API keys, DSNs, service-account files, and local secret paths
- customer records, customer emails, private domains, private site content, or screenshots
- agent-private memory files, journals, and identity files
- raw Paperclip issue/comment transcripts
- infrastructure notes whose only value is private operational access

## Substitutions

- `examples/memory/` stands in for private agent/customer memory.
- `sql/001_schema.sql` stands in for a runnable local demo schema.
- The real adapter script remains copied in `real-system/adapter/wake_bundle.sh`,
  but it expects local environment variables instead of shipping secrets.

## Project Identity

Canonical public name: **Say You'll Remember Me**.

Technical slug: `say-youll-remember-me`.

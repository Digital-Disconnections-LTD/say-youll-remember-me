# Live System Map

This file maps the public export to the real memory-system pieces it copied.

## Policy

- `real-system/policy/POLICY_NO_EMBEDDINGS.md`
- `real-system/policy/MEMORY_HYGIENE.md`

These are the standing rules: embeddings are allowed only when source-linked,
and memory hygiene favors source files plus scoped retrieval.

## Database Shape

- `real-system/controlled-memory-rebuild/001_dream_staging_fields.sql`
- `real-system/controlled-memory-rebuild/002_raw_source_import.sql`
- `real-system/controlled-memory-rebuild/003_source_windows_embeddings.sql`
- `real-system/controlled-memory-rebuild/004_compact_memory_windows.sql`

The live shape separates raw sources, source windows, source embeddings, compact
memory windows, and compact embeddings. The compact windows are the normal
prompt/retrieval unit; source windows remain the evidence layer.

## Namespace And Scope

- `real-system/controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md`

This is the real namespace contract: `agentic_memory` for the database,
`company:shared`, `customer:<uuid>`, `domain:<fqdn>`, `project:<slug>`, and
agent-scoped names for identity/craft/customer/project views.

## Wake Read Path

- `real-system/adapter/wake_bundle.sh`

The wake bundle is the important read path. It assembles bounded context at cold
wake from identity, since-last-wake changes, and spaced re-encounter facts. It
is read-only over memory facts and writes only the wake watermark.

## Reference Survey

- `real-system/reference/memory-landscape.md`

This is the provider-landscape survey that pushed the contract toward a small
control-plane surface: ingest, query, scope, provenance, maintenance, and
context assembly.

## Demo Boundary

The Python code in `src/source_linked_memory/` is not a replacement for the
files above. It is a runnable local demonstration of the same invariants:
source windows, hashes, ranked recall, and bounded orientation output.

# Policy: Embeddings Must Link to Source Files

**Status:** Active — operator directive, 2026-05-20 (updated)
**Scope:** All Digital Disconnections agents
**Source:** Operator directive (Cassidy Barton)

## Rule

Active agent memory must be **file-based with direct links to real source files**. Vector embeddings are permitted as a supplementary retrieval path, **but every embedding must include metadata that links back to its source file**. Embeddings without traceable provenance are forbidden.

## Why

> "Anything in embeddings loses its reality." — Operator

When facts pass through an embedding model and come back via similarity search, the result is an approximation. The nuance, specificity, and accuracy degrade. For agents making real decisions about real customers and real infrastructure, approximations are unacceptable — **unless the embedding can point you back to the real file to verify**.

Embeddings are useful as an index (finding *where* something lives), not as a substitute for the something itself. The link from embedding to source file is what makes them safe to use.

## How to apply

1. **Store memory as markdown files** in `$AGENT_HOME/memory/` with a `MEMORY.md` index.
2. **Link to real source files** — every factual claim in a memory file should point to the real file, real database row, or real URL it came from.
3. **Embeddings must carry source metadata** — if you use vector embeddings (HippoRAG, pgvector, etc.), each embedding must include a link or metadata field pointing to the source file it was derived from. An embedding that cannot be traced back to its source file violates this policy.
4. **Verify links before acting** — memory can go stale. Before acting on a remembered fact, verify the source file still exists and contains what you expect.
5. **Prefer direct reads over cached summaries** — when in doubt, read the real file again rather than trusting a memory paraphrase.
6. **Use embeddings as an index, not an oracle** — embeddings tell you *where* to look; the source file tells you *what* is true. Never treat the embedding's returned text as authoritative on its own.

## Schema and ingest enforcement (added 2026-05-24, DIS-460)

This policy is now enforced at the schema and ingest levels, not just by convention. The `agentic_memory.facts` table carries a `CHECK (source_path LIKE '/%')` constraint — relative paths are rejected at write time. Two new columns, `source_sha256 char(64)` and `embed_model text`, travel with every fact and will be made `NOT NULL` after the catch-up backfill (DIS-456 child issue #2). The `memory-curator` agent computes a sha256 of the source file before ingesting: if the hash is unchanged, it skips the file entirely; if the hash changed, it deletes all facts for that path and re-ingests clean — eliminating stale embeddings and mixed-model contamination. The `memory-recall` agent validates every returned `source_path` against the filesystem before emitting it: facts whose source file no longer exists are silently dropped from the response and logged to stderr, so no agent ever acts on a dangling citation. The curator's next freetime pass cleans those rows from the index.

## Exceptions

None. This policy applies to all agents, all memory types (role, feedback, project, reference), and all decisions.

## Related

- `agentic-flows.md` — Flow 3: Memory Architecture describes the three-layer memory model (worker, customer, global)
- `feedback_operator_directives.md` — Contains the original operator directive about embeddings
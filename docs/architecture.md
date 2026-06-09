# Architecture

## Principles

1. **Files are canonical.** Markdown, transcripts, issue notes, and structured records
   are the source of truth.
2. **Indexes are rebuildable.** Embeddings, lexical indexes, and graph edges are
   derived from source files.
3. **No orphan memories.** Every indexed fact or window must point to a real source,
   a stable anchor, and the sha256 of the source bytes used at indexing time.
4. **Remembering starts before search.** A wake loads identity/self, company baseline,
   and the active module before invoking recall.
5. **Modules compose context.** A client, project, or skill is a named module that can
   be attached for a task; unrelated modules are simply not loaded.

## Data Flow

```text
source files
  -> deterministic windows
  -> source-linked index rows
  -> recall candidates
  -> read source
  -> synthesize answer or orientation bundle
```

The index is a router, not the authority. A recall result is useful only because it
names the source that should be read next.

## Memory Layers

### Self

The self layer is portable, agent-owned continuity: role, values, durable operating
lessons, and open questions. It should be small enough to load every wake.

### Company

The company layer holds shared standing knowledge: policies, infrastructure maps,
workflow rules, and durable decisions. Everyone can read it; private customer data
belongs in its original system of record, not here.

### Modules

Modules are attachable context packs. A module can represent a customer, project,
skill, or incident. Each module should include a concise `CONTEXT.md` plus links to
source files.

```text
memory/
  self/
    SOUL.md
  company/
    COMPANY.md
  modules/
    demo-client/
      CONTEXT.md
  sources/
    demo-client-request.md
```

## Source Windows

A source window is a chunk of a source file with enough metadata to prove where it
came from:

- `source_path`
- `source_sha256`
- `window_id`
- `start_line`
- `end_line`
- `content`
- `index_model` or embedding model

If the source hash changes, derived windows should be re-indexed. If the source file
is gone, the index row is stale and should not be returned.

## Recall

Recall is a two-step operation:

1. Rank candidate source windows for a query.
2. Read the source file behind the winning windows before acting on the result.

This repo's demo uses lexical scoring so the mechanics are plain. A production system
can swap in pgvector, BM25, trigram search, or a graph reranker as long as the source
metadata remains mandatory.

## Orientation Bundle

Given a wake/task, assemble:

1. Self block.
2. Company block.
3. Active module `CONTEXT.md`.
4. Source-linked recall candidates for the task.
5. A list of omitted candidates if the token/character budget was exceeded.

The assembler should drop low-ranked recall snippets before dropping self or module
context. Silent truncation is a memory bug.

## Consolidation

Consolidation turns raw source into smaller reviewed context files, but it does not
replace the raw source. A useful loop:

1. Ingest raw source.
2. Generate candidate summary or context update.
3. Review/promote into `CONTEXT.md`, `COMPANY.md`, or `SOUL.md`.
4. Keep links back to the source.
5. Rebuild the derived index.

## What This Avoids

- Hidden memory that cannot cite its source.
- Treating embeddings as truth.
- LLM-paraphrased facts as the canonical record.
- Loading all customer/project context when one module is enough.
- Hard-wiring memory to one orchestration platform.


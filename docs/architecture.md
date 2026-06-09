# Architecture

## Principles

1. **Files are canonical.** Markdown, transcripts, issue notes, and structured
   records are the source of truth.
2. **Indexes are rebuildable.** Embeddings, lexical indexes, and graph edges are
   derived from source files.
3. **No orphan memories.** Every indexed fact or window must point to a real
   source, a stable anchor, and the sha256 of the source bytes used at indexing
   time.
4. **Remembering starts before search.** A wake loads identity/self, company
   baseline, and active scope context before invoking fallback recall.
5. **Scope composes context.** Customer, domain, project, company, and agent
   scopes decide what gets loaded; unrelated scopes are not pulled just because
   they exist.

## Data Flow

```text
source files
  -> raw source records
  -> source windows
  -> source embeddings
  -> compact memory windows
  -> scoped recall / wake bundle
  -> read source evidence when needed
```

The index is a router, not the authority. A recall result is useful because it
names the source that should be read next.

## Copied Real Pieces

The `real-system/` tree is the carbon-copy part of this repo:

- `policy/`: memory rules that agents actually follow.
- `controlled-memory-rebuild/`: SQL and namespace documents for the rebuild.
- `adapter/wake_bundle.sh`: the cold-wake orientation assembler.
- `reference/memory-landscape.md`: the provider survey and control-plane contract.

## Memory Layers

### Identity

Agent-owned continuity: role, standing lessons, and durable operating texture.
It loads before task-specific material.

### Company

Fleet-wide memory: policy, infrastructure, workflow, and durable shared
decisions.

### Scoped Work

Customer, domain, project, and agent-view scopes are the normal work boundary.
The real namespace shapes are in
`real-system/controlled-memory-rebuild/NAMESPACE_BLUEPRINT.md`.

## Source Windows

A source window is a chunk of a source file with enough metadata to prove where
it came from:

- `source_path`
- `source_sha256`
- `window_id`
- `start_line`
- `end_line`
- `content`
- `index_model` or embedding model

If the source hash changes, derived windows should be re-indexed. If the source
file is gone, the index row is stale and should not be returned.

## Compact Memory Windows

The controlled rebuild separates evidence windows from compact prompt windows.
Compact memory windows are the normal thing a wake or recall path consumes:
action, result, lesson, customer/project/domain scope, and source-window
backing. The copied table shape is in
`real-system/controlled-memory-rebuild/004_compact_memory_windows.sql`.

## Recall

Recall is a four-step operation:

1. Filter by scope.
2. Rank compact windows or source windows for a query.
3. Return source metadata with the result.
4. Read the source file behind important hits before acting on the result.

This repo's demo uses lexical scoring so the mechanics are plain. A production
system can swap in pgvector, BM25, trigram search, or a graph reranker as long
as the source metadata remains mandatory.

## Orientation Bundle

The copied wake path is `real-system/adapter/wake_bundle.sh`. On a cold wake, it
assembles:

1. identity blurb
2. owner-scoped identity facts
3. facts new or updated since last wake
4. spaced re-encounter facts
5. a watermark update after assembly

The important production invariant is bounded output. Total bundle size does
not grow with total fleet fact count.

## Consolidation

Consolidation turns raw source into smaller reviewed context files, but it does
not replace the raw source. A useful loop:

1. Ingest raw source.
2. Generate candidate summary or context update.
3. Review/promote into a scoped or identity context file.
4. Keep links back to the source.
5. Rebuild the derived index.

## What This Avoids

- Hidden memory that cannot cite its source.
- Treating embeddings as truth.
- LLM-paraphrased facts as the canonical record.
- Loading all customer/project context when one scope is enough.
- Hard-wiring memory to one orchestration platform.

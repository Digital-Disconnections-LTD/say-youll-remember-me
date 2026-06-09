# Schema Notes

## Live Tables

Live memory reads from:

- `agentic_memory.facts`
- `agentic_memory.relations`
- `agentic_memory.agent_wake_state`

Source/provenance tables:

- `agentic_memory.source_chunks`
- `agentic_memory.enrichment_notes`
- `agentic_memory.enrichment_runs`
- `agentic_memory.facts_staging`

## Current Constraint

`facts_staging` exists and is useful for non-readable staged memory. It already has PVE legacy columns:

- `legacy_agent`
- `legacy_source_path`
- `legacy_source_issue`
- `legacy_significance`
- `source_triple_ids`
- `legacy_source_ids`
- `import_batch_id`
- `legacy_subject`
- `legacy_predicate`
- `legacy_object`
- `legacy_source_quality`
- `legacy_source_text`

This means the rebuild should not create a parallel facts table unless needed. The minimum-force path is to add rebuild batch metadata and use generation/import batch identifiers to isolate candidates.

## Needed Additions

Add tables for:

- rebuild batches/runs
- selected source chunks for a batch
- evaluation samples/results

Add columns or indexes only if they improve staging operations directly.

Candidate facts can land in `facts_staging` with a distinct `import_batch_id`, while richer rebuild metadata lives in separate tables.

## Adapter Boundary

Do not edit Paperclip core for wake recall. The wake bundle is injected at the
adapter/hook boundary today, and that is the right place for this local box:

- `/home/discnxt/ops/bin/wake_bundle.sh`
- agent adapter wake context
- helper functions such as `aib/lib/site_context.py`

Paperclip's job is to preserve structured operational state. The adapter's job
is to decide which bounded memory packet enters a wake.

## Additive Dream Fields

The DIS-1360 spec calls for these nullable fields on `facts_staging`:

- `derived_by`
- `derived_kind`
- `source_issue_ids`
- `source_comment_ids`
- `source_communication_ids`
- `source_fact_ids`
- `source_staging_ids`
- `contradicts_fact_ids`
- `supersedes_fact_ids`
- `candidate_significance`
- `retention_recommendation`
- `dream_batch_id`

These fields let a local dream writer create derived candidates without changing
live recall. They also keep PVE lineage fields intact.

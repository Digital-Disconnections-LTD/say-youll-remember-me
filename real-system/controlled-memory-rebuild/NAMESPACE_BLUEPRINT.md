# Memory Rebuild Namespace Blueprint

Created: 2026-06-08

This file names the rebuild consistently so later work does not invent parallel terms.

## Project Namespace

Canonical project folder:

`plans/controlled-memory-rebuild/`

Canonical short name:

`cmr`

Use `cmr` for scripts, batch IDs, logs, reports, and generated work products unless a human-facing title needs the full name.

## Database Namespace

Schema:

`agentic_memory`

Do not create a second memory schema unless the live schema must be isolated for a cutover test. Prefer additive tables inside `agentic_memory`.

Existing live tables:

- `agentic_memory.facts`
- `agentic_memory.relations`
- `agentic_memory.facts_staging`
- `agentic_memory.source_chunks`
- `agentic_memory.agent_wake_state`

New rebuild source tables:

- `agentic_memory.raw_source_walks`
- `agentic_memory.raw_sources`
- future: `agentic_memory.source_windows`
- future: `agentic_memory.source_embeddings`
- future: `agentic_memory.compact_memory_windows`

New dream metadata tables:

- `agentic_memory.dream_batches`
- `agentic_memory.dream_source_windows`

Do not trust `agentic_memory.source_chunks` as canonical source. Treat it as a legacy/cache table because it is noisy and currently has a damaged page. Raw rebuild source lives in `raw_sources`.

Source windows are evidence, not the whole memory system. Embeddings are indexes
over grounded records/windows, not source of truth. The useful agent retrieval
layer should be chunky compact memory: unified action/result/lesson/customer
windows backed by one or more source windows.

## Batch IDs

Batch ID patterns:

- Raw source walk: `cmr-rawwalk-YYYYMMDDTHHMMSSZ`
- Dream batch: `cmr-dream-YYYYMMDDTHHMMSSZ`
- PVE import batch: `cmr-pve-<agent>-YYYYMMDDTHHMMSSZ`
- Evaluation run: `cmr-eval-YYYYMMDDTHHMMSSZ`
- Cutover rehearsal: `cmr-rehearsal-YYYYMMDDTHHMMSSZ`

Use UTC in batch IDs.

## Source URIs

Use stable URI prefixes. They do not need to be network-addressable.

- Paperclip issue window: `paperclip://issues/<issue_uuid>`
- Paperclip issue comment: `paperclip://comments/<comment_uuid>`
- Customer record: `paperclip://customer/<customer_uuid>`
- Contact record: `paperclip://contact/<contact_uuid>`
- Domain record: `paperclip://domain/<domain_uuid>`
- Site record: `paperclip://customer_site/<site_uuid>`
- Communication record: `paperclip://communication/<communication_uuid>`
- Company file: `company-file://<relative_path>`
- Claude project transcript or memory file: `claude-project://<relative_path>`
- PVE entity: `pve://<legacy_agent>/entities/<entity_id>`
- PVE triple: `pve://<legacy_agent>/triples/<triple_id>`

`source_uri` is the stable identity. `source_path` is optional and should point to the strongest local file artifact when one exists.

## Source Windows And Embeddings

Keep chunks/windows manageable and source-grounded.

Recommended future window fields:

- `raw_source_id`
- `window_uri`
- `content_sha256`
- `content`
- `start_line`
- `end_line`
- `start_char`
- `end_char`
- `heading_path`
- `semantic_kind`
- `metadata`

Recommended future embedding fields:

- `window_id`
- `embedding_model`
- `embedding`
- `embedded_at`
- `metadata`

Recommended compact memory window fields:

- `compact_uri`
- `source_window_ids`
- `raw_source_ids`
- `content`
- `summary`
- `episode_kind`
- `outcome`
- `customer_id`
- `project_key`
- `domain_name`
- `agent_slug`
- `scope`
- `metadata`

The retrieval order is compact memory first, grounded evidence always available:

1. Use deterministic customer/project/domain/agent scope filters to choose the
   relevant compact memory and source records/windows.
2. Use embeddings to find nebulous semantic matches inside that scoped set.
3. Return compact chunks for wake/use, plus source URI/path/line metadata so the
   agent can inspect the grounded evidence when needed.

## Scope Names

Use these exact scope shapes:

- Customer scope: `customer:<customer_uuid>`
- Domain scope: `domain:<fqdn>`
- Project scope: `project:<project_slug_or_issue_uuid>`
- Agent private core scope: `agent:<agent_slug>:core`
- Agent craft scope: `agent:<agent_slug>:craft`
- Agent customer view scope: `agent:<agent_slug>:customer:<customer_uuid>`
- Agent project view scope: `agent:<agent_slug>:project:<project_slug_or_issue_uuid>`
- Company shared scope: `company:shared`

Agent core memories are separated in the database for identity and continuity.
This is organization, not access control. Agents may view and share across agent
memories when it helps the work. Keep provenance so copied or inherited context
remains understandable later. Heather remains Heather; Sage can ingest Heather's
useful lessons by copying them into Sage's view or a shared customer/project/company
scope with source attribution.

All agents may pull shared customer and project context. Retrieval should compose
scopes instead of treating memory as one flat pool:

- Agent wake: `agent:<agent>:core`, `agent:<agent>:craft`, `company:shared`
- Customer work: agent wake scopes plus `customer:<customer_uuid>` and relevant `domain:<fqdn>`
- Project work: agent wake scopes plus `project:<project>` and linked customer/domain scopes
- Cross-agent inheritance: pull whatever is useful, then preserve source attribution when copying lessons into another agent, customer, project, or company scope

Customer/domain wake bundles read `customer:<id>` and `domain:<fqdn>` from live `facts`. Project-aware bundles also read `project:<project>` when the adapter knows the project or issue.

## Derived Candidate Fields

For local dream output into `facts_staging`:

- `derived_by`: `cmr_dreamer`
- `derived_kind`: one of `closed_issue`, `customer_email_window`, `self_note_cluster`, `pve_import_cluster`
- `dream_batch_id`: use the dream batch pattern above
- `candidate_significance`: 1-10, where lower means more durable
- `retention_recommendation`: `promote`, `keep_staged`, `archive_leaf`, or `decline`

Do not write derived candidates directly to `facts`.

## Script Names

Ops scripts live in:

`/home/discnxt/ops/bin/`

Names:

- `memory_source_walk.py`: raw source import
- `memory_dream_candidates.py`: derive staged candidate facts
- `memory_eval_harness.py`: validate bundle precision/flood behavior
- `memory_cutover_rehearsal.py`: rehearse promotion/cutover on explicit batches

Do not name scripts after agents. Agents may run them later, but the scripts are system maintenance tools.

## Output Paths

Generated reports:

`plans/controlled-memory-rebuild/reports/`

Source packet exports:

`plans/controlled-memory-rebuild/source-packets/`

Evaluation fixtures:

`plans/controlled-memory-rebuild/fixtures/`

Logs:

`/home/discnxt/ops/log/controlled-memory-rebuild/`

Backups:

`/home/discnxt/backups/agentic_memory/controlled-rebuild-<timestamp>/`

## Adapter Boundary

Wake recall is adapter-layer behavior:

- `/home/discnxt/ops/bin/wake_bundle.sh`
- Paperclip agent adapter prompt injection
- helper calls such as `aib/lib/site_context.py`

Avoid Paperclip core edits unless the adapter boundary cannot express the behavior.

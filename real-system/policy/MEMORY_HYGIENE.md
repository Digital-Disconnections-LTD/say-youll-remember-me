# Memory Hygiene

The goal here is to keep memory useful: fast to recall, easy to trust, and small enough that a heartbeat doesn't burn tokens on stale snapshots.

**Orient from the wake bundle first; recall is the fallback (DIS-937).** Your wake already carries an orientation pack — always-resident identity core, a "since you last woke" delta, and any due re-encounters (DIS-936). Read that first; it is what you remember. Spawn `memory-recall` (via the Task tool) **only on a miss** — when you need something that isn't in front of you (a deep-dive the bundle didn't surface, or "has any *other* agent seen this?"). It returns a table of facts with verified `source_path` columns and a related-facts section — the table is just the index, the real value is the source file each row points to. Read the cited file when a row looks load-bearing. Lower recall-invocation-rate = more remembering; recall on every wake is the old DISCOVERING posture.

**Trust the `source_path`.** As of DIS-460, every fact in `agentic_memory.facts` carries an absolute path (CHECK constraint `source_path ~~ '/%'`), a `source_sha256`, and an `embed_model` column. When you act on a recalled fact, cite the path in your reply or comment — `Source: <path>` is enough. This is how the audit trail stays honest.

**Curate your own PARA.** Stale facts poison the next heartbeat's context. Delete outright when something stops being true; the supersede-with-history pattern from the default PARA skill is overridden for Discnxt — see [[feedback_para_delete_dont_supersede]]. Rewrite `summary.md` in place; drop stale `items.yaml` entries entirely.

**Soft size target: ~50K** across an agent's daily notes + PARA index. The nightly memory-curator (Wren-owned, routine `c5940e4c-7bf7-47c8-99b1-46b1a984a491`, cron `0 3 * * *` UTC) handles index-side dedup and embedding regen. The daily-snapshot pruning side is yours — when notes pile up, fold the still-relevant bits into PARA and drop the rest. Failure example: DIS-456 — unchecked daily notes leaked across weeks until recall got slow.

**Index file:** `memory/MEMORY.md` (200-line cap; entries are one-liners pointing into the dir).

Source paths confirmed: `discovery-notes-2026-05-24.md` §3, §8.

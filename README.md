# Source-Linked Agent Memory

A small, inspectable memory architecture for task-based agents.

The rule is simple: **source files are truth; retrieval is only a router back to those
sources.** The system stores durable memory as files, indexes source chunks with
provenance metadata, and assembles a bounded wake/orientation bundle from the pieces
that matter for the current task.

This repo is a public-safe distillation of Digital Disconnections' internal memory
work. It is not a dump of the production system. Production paths, company data,
customer data, credentials, and agent-private memory are intentionally excluded.

## What This Demonstrates

- File-first memory: markdown and transcript files are canonical.
- Source windows: source files are chunked into deterministic windows.
- Provenance-first retrieval: every indexed row carries source path, anchor, sha256,
  and model/index metadata.
- Recall as routing: search returns source-linked candidates; the source is then read
  to answer the question.
- Orientation bundles: each wake starts from self, company, and task modules before
  fallback search.
- Consolidation loops: raw sources can be compacted into small, reviewed context files
  without replacing the original source.

## Repo Map

```text
docs/
  architecture.md        Design model and data flow
  export-inventory.md    What was copied, distilled, and excluded
  public-safety.md       Scrubbing rules for public exports
examples/
  memory/                Synthetic self/company/module/source files
scripts/
  demo_orientation.py    End-to-end local demo
sql/
  001_schema.sql         Portable schema sketch with provenance invariants
src/source_linked_memory/
  chunking.py            Source windowing and hashing
  index.py               Tiny JSONL lexical index for demo use
  orientation.py         Bounded wake bundle assembly
  recall.py              Source-linked recall
tests/
  test_demo.py           Smoke tests for the demo path
```

## Quickstart

Requires Python 3.11+.

```bash
python3 scripts/demo_orientation.py \
  --memory-root examples/memory \
  --query "what should I know before editing the demo client site?"
```

Run the smoke tests:

```bash
PYTHONPATH=src python3 -m unittest discover -s tests
```

The demo intentionally uses lexical scoring and JSONL files so the architecture is
visible. In a production system, the same source metadata travels with a vector index
or hybrid search table.

## Package Status

This is an architecture scaffold and runnable demo, not a published package yet.
Public copy, naming, and license selection should be finalized before promoting it as
a reusable library.

## Design In One Sentence

Load the agent's self, load the company baseline, strap on the relevant module, use
search only to find source files worth reading, and never let a derived memory outrank
the source it came from.

## GitHub First Push Path

Target public repo:

```text
Digital-Disconnections-LTD/source-linked-agent-memory
```

Initial push:

```bash
git remote add origin https://github.com/Digital-Disconnections-LTD/source-linked-agent-memory.git
git branch -M main
git push -u origin main
```

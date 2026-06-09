# Private Material Substitutions

The export keeps the real memory-system shape and omits only material that a
public GitHub repo cannot carry.

## Omitted

- Secrets: tokens, API keys, DSNs, service-account files, private keys, local
  secret paths, and authentication payloads.
- Live data: database dumps, raw production rows, customer records, customer
  emails, customer screenshots, private site files, and private domains.
- Agent-private continuity: memory files, journals, identity files, and session
  transcripts that belong to individual agents.
- Raw Paperclip issue/comment transcripts.

## Retained

- Internal file paths when they are part of copied source comments or explain
  how the real system is wired.
- Environment variable names such as `DATABASE_URL` and `PAPERCLIP_API_KEY`
  where copied code expects caller-provided runtime configuration.
- Database schema names and table names for the memory system.
- Issue identifiers in copied architecture notes when they explain why a
  source exists.

## Substituted

- `examples/memory/` replaces private memory directories for the runnable demo.
- `sql/001_schema.sql` is a portable demo schema, while the real controlled
  rebuild SQL lives under `real-system/controlled-memory-rebuild/`.
- The public repo name uses the fixed project identity, `Say You'll Remember
  Me`, with the technical slug `say-youll-remember-me`.

# Public Safety Rules

Use this checklist before anything from an internal memory system is published.

## Do Publish

- Architecture that another team can understand.
- Synthetic examples.
- Portable schema sketches.
- Code that demonstrates source-link invariants.
- Inventory explaining what was copied, distilled, and excluded.

## Do Not Publish

- Credentials, tokens, DSNs, hostnames that reveal private infrastructure, or private
  service configuration.
- Customer names, emails, domains, contracts, screenshots, or site-specific content.
- Agent private memory, identity files, journals, or session transcripts.
- Production database dumps.
- Internal paths unless they are necessary historical citations in a private issue.

## Minimum Scan

Before a public push, run:

```bash
git status --short
grep -RInE '(SECRET|TOKEN|PASSWORD|API_KEY|DATABASE_URL|Bearer |gho_|sk-|BEGIN [A-Z ]*PRIVATE KEY)' .
python3 -m unittest discover -s tests
```

The grep can produce false positives from docs that name what to avoid. Inspect each
hit before pushing.


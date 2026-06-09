# Validation Cases

The rebuild must pass these cases before any live cutover.

## Arrow Customer Context

Query intent:

> Build or edit an Arrow customer site.

Expected compact context:

- customer record
- domain/DNS record
- site output/deploy path
- onboarding source: self-serve, Cass, JC, Jamal, or other
- purchase/domain state
- whether ZIP/preview exists
- email thread/window pointer
- customer preferences and durable lessons

Avoid:

- old speculative Arrow plans
- repeated issue chatter
- unrelated PVE identity history

## Existing Domain Handoff

Query intent:

> Customer already has a domain.

Expected:

- ask whether they have registrar access/unlock/EPP code
- if no, route to human handoff and ask preferred contact method: email/text/phone
- do not pretend self-serve can handle hands-on migration without access

## Heather/PVE Inheritance

Expected:

- Heather/Lena/Maya memories remain legacy sources
- current agents can adopt/promote with lineage
- no direct flattening into Sage identity
- rejected/noisy facts remain inspectable but not wake-flooding

## Contabo Operations

Expected:

- Contabo hosting/DNS/deploy facts surface for deploy/DNS tasks
- they do not appear in unrelated customer-design tasks
- no proposal moves working Contabo workflows without explicit need

## Operator Authority

Expected:

- Cass, JC, and Jamal authority surfaces when relevant
- agents do not refuse their directions based on principles/guidance
- agents may escalate only concrete missing access, impossible target, legal/safety blocker, or unclear operator intent


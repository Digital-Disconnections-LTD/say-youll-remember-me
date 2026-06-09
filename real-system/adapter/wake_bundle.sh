#!/usr/bin/env bash
# wake_bundle.sh — Phase-4 REMEMBERING injection (DIS-967 / DIS-963)
#
# Runs the Wren-PASS'd wake-bundle assembler (memory-recall.md Steps 7.5-7.9)
# automatically at every cold wake, invoked by a SessionStart hook (matcher
# `startup`) in ~/.claude/settings.json. Prints the assembled bundle as the
# hook's `additionalContext` so it lands in the agent's context WITHOUT the
# agent having to spawn memory-recall (which DIS-937 demoted to a fallback).
#
# Lifted verbatim from /home/discnxt/.claude/agents/memory-recall.md:
#   7.5 identity blurb (lines ~496-506, caps 74-80)
#   7.6 always-resident core, owner-scoped (lines ~563-581)  [BINDING gate]
#   7.7 since-last-wake delta            (lines ~593-626)
#   7.8 Fibonacci spaced re-encounter    (lines ~642-681)
#   7.9 watermark upsert                 (lines ~692-700)
#   formatting templates                 (lines ~714-773)
#   caps IDENTITY_CORE_CAP/DELTA_CAP/REENCOUNTER_CAP (lines 69-72)
#
# Invariants:
#   * READ-ONLY on agentic_memory.facts / relations. Writes ONLY the additive
#     agentic_memory.agent_wake_state watermark (7.9).
#   * BINDING identity gate: core filters `agent_owner = WAKING`. A naive
#     `WHERE layer='identity'` bleeds 38 rows across 9 agents — owner-scope is
#     the only safe filter. Missing identity -> empty core, never a bleed.
#   * Bounded / fleet-invariant: caps 5/8/3 -> <=16 facts; bundle size is
#     invariant to total fleet fact count.
#   * ALWAYS exits 0. Any error / missing identity -> empty additionalContext.
#     Never blocks the wake, never bleeds.
#   * psql statement_timeout caps each query; whole hook target < 2s.
#
# memory-recall.md is intentionally left untouched (protects R4 / DIS-925).

set -uo pipefail

# ---------------------------------------------------------------------------
# Always emit a valid SessionStart hook payload. On any failure we emit an
# EMPTY additionalContext and exit 0 (never block the wake).
# ---------------------------------------------------------------------------
emit() {
  # $1 = bundle markdown (may be empty)
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "${1:-}" | jq -Rs \
      '{hookSpecificOutput:{hookEventName:"SessionStart", additionalContext: .}}'
  else
    # jq-less fallback: emit empty context rather than risk malformed JSON
    printf '%s' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'
  fi
  exit 0
}
emit_empty() { emit ""; }

# Any unexpected error anywhere -> empty bundle, exit 0.
trap 'emit_empty' ERR

# ---------------------------------------------------------------------------
# Caps (memory-recall.md lines 69-72)
# ---------------------------------------------------------------------------
IDENTITY_CORE_CAP=5
DELTA_CAP=8
REENCOUNTER_CAP=3
IDENTITY_TOKEN_BUDGET="${IDENTITY_TOKEN_BUDGET:-400}"   # few-hundred-token cap

# ---------------------------------------------------------------------------
# Resolve the waking agent UUID (the owner-scope key for the BINDING gate)
#   1. $PAPERCLIP_AGENT_ID  (set on every Paperclip wake)
#   2. decode `sub` from the $PAPERCLIP_API_KEY JWT
#   3. basename of $PWD == workspace dir == agent UUID (fleet-wide)
# Empty / non-UUID -> exit 0 with no output (non-Paperclip session).
# ---------------------------------------------------------------------------
UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'

WAKING="${PAPERCLIP_AGENT_ID:-}"

if [ -z "$WAKING" ] && [ -n "${PAPERCLIP_API_KEY:-}" ]; then
  # decode JWT payload (2nd dot-delimited segment), base64url -> json -> .sub
  jwt_payload=$(printf '%s' "$PAPERCLIP_API_KEY" | cut -d. -f2)
  # pad base64url to a multiple of 4 and translate the url alphabet
  pad=$(( (4 - ${#jwt_payload} % 4) % 4 ))
  jwt_payload="${jwt_payload}$(printf '=%.0s' $(seq 1 $pad))"
  WAKING=$(printf '%s' "$jwt_payload" | tr '_-' '/+' | base64 -d 2>/dev/null \
             | jq -r '.sub // empty' 2>/dev/null || true)
fi

if [ -z "$WAKING" ]; then
  cand=$(basename "$PWD")
  [[ "$cand" =~ $UUID_RE ]] && WAKING="$cand"
fi

# must be a UUID or we bail (never query with a bogus owner)
[[ "$WAKING" =~ $UUID_RE ]] || emit_empty

# ---------------------------------------------------------------------------
# DB connection. Cap every statement so the hook can never hang the wake.
# ---------------------------------------------------------------------------
[ -n "${DATABASE_URL:-}" ] || emit_empty
export PGOPTIONS='-c statement_timeout=1500'
PSQL() { psql "$DATABASE_URL" -X -q -At -F$'\037' "$@" 2>/dev/null; }

# Bail (empty) if the memory table is absent (reuse the to_regclass guard).
HAVE_FACTS=$(psql "$DATABASE_URL" -X -q -At -c "SELECT to_regclass('agentic_memory.facts') IS NOT NULL;" 2>/dev/null || true)
[ "$HAVE_FACTS" = "t" ] || emit_empty

# No query/scope context on a bare wake -> match company:shared + genuinely
# unscoped + own facts (the empty sentinel never matches a real client scope).
SCOPE_MATCH=""

# ===========================================================================
# 7.5 — Identity blurb (slice 1).  Read ONLY the bounded BLURB region.
# ===========================================================================
SELF_FILE="${SELF_FILE:-$HOME/.claude/projects/-home-discnxt--paperclip-instances-default-workspaces-${WAKING}/memory/SELF.md}"
IDENTITY_BLURB=""; SELF_BASENAME="none"
if [ -r "$SELF_FILE" ]; then
  SELF_BASENAME="$(basename "$(dirname "$SELF_FILE")")/$(basename "$SELF_FILE")"
  IDENTITY_BLURB=$(awk '/<!-- BLURB:START -->/{f=1;next} /<!-- BLURB:END -->/{f=0} f' "$SELF_FILE")
  [ -z "$IDENTITY_BLURB" ] && IDENTITY_BLURB=$(head -c 1500 "$SELF_FILE")
  # clamp to the fixed identity-blurb budget (chars = tokens*4)
  maxchars=$(( IDENTITY_TOKEN_BUDGET * 4 ))
  if [ "${#IDENTITY_BLURB}" -gt "$maxchars" ]; then
    IDENTITY_BLURB="$(printf '%s' "$IDENTITY_BLURB" | head -c "$maxchars")
…[identity blurb clamped to ${IDENTITY_TOKEN_BUDGET}-tok fixed budget]"
  fi
fi

# ===========================================================================
# 7.6 — Always-resident core: owner-scoped identity facts (BINDING gate)
# ===========================================================================
CORE_ROWS=()
CORE_TSV=$(PSQL -v waking="$WAKING" -v cap="$IDENTITY_CORE_CAP" <<'SQL'
SELECT topic,
       replace(replace(summary, E'\n',' '), E'\r',' '),
       source_path
FROM agentic_memory.facts
WHERE layer = 'identity' AND agent_owner = :'waking'::uuid
ORDER BY id ASC
LIMIT :'cap'::int;
SQL
)
while IFS=$'\037' read -r ctopic csummary cpath; do
  [ -z "$ctopic" ] && continue
  CORE_ROWS+=("$ctopic"$'\037'"$csummary"$'\037'"$cpath")
done <<< "$CORE_TSV"

# ===========================================================================
# 7.7 — Wake-delta: facts new/updated since last wake
# ===========================================================================
DELTA_ROWS=(); LAST_WAKE_AT=""
LAST_WAKE_AT=$(PSQL -v waking="$WAKING" <<'SQL'
SELECT last_wake_at FROM agentic_memory.agent_wake_state
WHERE agent_owner = :'waking'::uuid;
SQL
)
FIRST_WAKE=""
if [ -z "$LAST_WAKE_AT" ]; then
  FIRST_WAKE="yes"
  LAST_WAKE_AT=$(date -u -d '30 days ago' '+%Y-%m-%d %H:%M:%S+00' 2>/dev/null \
                 || echo "$(date -u +'%Y-%m-%d') 00:00:00+00")
fi
DELTA_TSV=$(PSQL -v waking="$WAKING" -v sm="$SCOPE_MATCH" \
                 -v since="$LAST_WAKE_AT" -v cap="$DELTA_CAP" <<'SQL'
SELECT topic,
       replace(replace(summary, E'\n',' '), E'\r',' '),
       source_path,
       to_char(GREATEST(ingested_at, last_verified), 'YYYY-MM-DD HH24:MI') AS changed_at
FROM agentic_memory.facts
WHERE GREATEST(ingested_at, last_verified) > :'since'::timestamptz
  AND (
    scope = :'sm'
    OR scope = 'company:shared'
    OR (scope IS NULL AND (agent_owner IS NULL OR agent_owner = :'waking'::uuid))
    OR agent_owner = :'waking'::uuid
  )
ORDER BY GREATEST(ingested_at, last_verified) DESC, id DESC
LIMIT :'cap'::int;
SQL
)
while IFS=$'\037' read -r dtopic dsummary dpath dchanged; do
  [ -z "$dtopic" ] && continue
  DELTA_ROWS+=("$dtopic"$'\037'"$dsummary"$'\037'"$dpath"$'\037'"$dchanged")
done <<< "$DELTA_TSV"

# ===========================================================================
# 7.8 — Spaced re-encounter: Fibonacci-due facts (query-independent)
# ===========================================================================
REENCOUNTER_ROWS=()
RENC_TSV=$(PSQL -v waking="$WAKING" -v cap="$REENCOUNTER_CAP" <<'SQL'
SELECT topic,
       replace(replace(summary, E'\n',' '), E'\r',' '),
       source_path,
       encounter_count,
       to_char(last_accessed, 'YYYY-MM-DD') AS last_seen
FROM agentic_memory.facts
WHERE last_accessed IS NOT NULL
  AND encounter_count >= 1
  AND now() - last_accessed > (
        CASE
          WHEN encounter_count <= 2 THEN interval '1 day'
          WHEN encounter_count = 3  THEN interval '2 days'
          WHEN encounter_count = 4  THEN interval '3 days'
          WHEN encounter_count = 5  THEN interval '5 days'
          WHEN encounter_count = 6  THEN interval '8 days'
          WHEN encounter_count = 7  THEN interval '13 days'
          WHEN encounter_count = 8  THEN interval '21 days'
          WHEN encounter_count = 9  THEN interval '34 days'
          WHEN encounter_count = 10 THEN interval '55 days'
          ELSE                           interval '89 days'
        END
      )
  AND (
    agent_owner = :'waking'::uuid
    OR scope = 'company:shared'
    OR (scope IS NULL AND (agent_owner IS NULL OR agent_owner = :'waking'::uuid))
  )
ORDER BY last_accessed ASC, id ASC
LIMIT :'cap'::int;
SQL
)
while IFS=$'\037' read -r rtopic rsummary rpath rcount rseen; do
  [ -z "$rtopic" ] && continue
  REENCOUNTER_ROWS+=("$rtopic"$'\037'"$rsummary"$'\037'"$rpath"$'\037'"$rcount"$'\037'"$rseen")
done <<< "$RENC_TSV"

# ===========================================================================
# 7.9 — Upsert the wake watermark to now() AFTER assembling all sections.
# The hook is now the canonical wake-marker (resolves DIS-936 #1). Best-effort:
# a failed upsert never blocks the bundle. memory-recall.md keeps its own 7.9.
# ===========================================================================
psql "$DATABASE_URL" -X -q -v waking="$WAKING" >/dev/null 2>&1 <<'SQL' || true
INSERT INTO agentic_memory.agent_wake_state (agent_owner, last_wake_at)
VALUES (:'waking'::uuid, now())
ON CONFLICT (agent_owner) DO UPDATE SET last_wake_at = now();
SQL

# ===========================================================================
# Format the bundle (memory-recall.md templates, lines 714-773)
# ===========================================================================
nl=$'\n'
B="## Wake Orientation (auto-injected — DIS-967 wake_bundle.sh)"
B+="${nl}_Owner-scoped to agent ${WAKING}. Read-only on memory; bounded ${IDENTITY_CORE_CAP}/${DELTA_CAP}/${REENCOUNTER_CAP}._${nl}"

# --- Identity ---
B+="${nl}### Identity  (self-file: ${SELF_BASENAME})${nl}"
if [ -n "$IDENTITY_BLURB" ]; then
  B+="${IDENTITY_BLURB}${nl}"
else
  B+="_(no self-file for this agent — running identity-less; today's behavior)_${nl}"
fi

# --- Always with you (7.6) ---
B+="${nl}### Always with you (${#CORE_ROWS[@]} identity facts)${nl}"
if [ "${#CORE_ROWS[@]}" -eq 0 ]; then
  B+="_(no identity facts seeded for this agent yet — core is empty)_${nl}"
else
  B+="| topic | summary | source_path |${nl}|---|---|---|${nl}"
  for row in "${CORE_ROWS[@]}"; do
    IFS=$'\037' read -r t s p <<< "$row"
    B+="| ${t} | ${s} | ${p} |${nl}"
  done
fi

# --- Since your last wake (7.7) ---
B+="${nl}### Since your last wake (${#DELTA_ROWS[@]} new/updated; watermark: ${LAST_WAKE_AT})${nl}"
if [ "${#DELTA_ROWS[@]}" -eq 0 ]; then
  B+="_(nothing new since last wake)_${nl}"
else
  B+="| topic | summary | changed_at | source_path |${nl}|---|---|---|---|${nl}"
  for row in "${DELTA_ROWS[@]}"; do
    IFS=$'\037' read -r t s p c <<< "$row"
    B+="| ${t} | ${s} | ${c} | ${p} |${nl}"
  done
fi
[ -n "$FIRST_WAKE" ] && B+="_(first wake — showing 30-day grace window)_${nl}"

# --- Due for re-encounter (7.8) ---
B+="${nl}### Due for re-encounter (${#REENCOUNTER_ROWS[@]} overdue)${nl}"
if [ "${#REENCOUNTER_ROWS[@]}" -eq 0 ]; then
  B+="_(nothing overdue for re-encounter)_${nl}"
else
  B+="| topic | summary | encounters | last seen | source_path |${nl}|---|---|---|---|---|${nl}"
  for row in "${REENCOUNTER_ROWS[@]}"; do
    IFS=$'\037' read -r t s p cnt seen <<< "$row"
    B+="| ${t} | ${s} | ${cnt} | ${seen} | ${p} |${nl}"
  done
fi

emit "$B"

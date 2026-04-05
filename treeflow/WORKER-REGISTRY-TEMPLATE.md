# {Plan Name} — Worker Registry

> Orchestrator-only. Never sent to workers.
> Remove this header line before writing the file.

## Skill Routing

Built during planning from `Files:` lists across all bead descriptions.

| File patterns | Domain | Worker prefix |
|---|---|---|
| {e.g., `lib/engine/commands/*.ts`} | {commands} | {`commands-`} |
| {e.g., `entrypoints/background.ts`} | {chrome-api} | {`chrome-api-`} |
| {e.g., `entrypoints/sidepanel/*.tsx`} | {react-ui} | {`ui-`} |
| {e.g., `lib/state/*.ts`} | {state} | {`state-`} |
| {e.g., `tests/**`} | {testing} | {`test-`} |

## Worker Registry

| Status | Values |
|--------|--------|
| `active` | Currently working |
| `idle` | Stopped, resumable via SendMessage |
| `retired` | Context too full (<40% remaining) |
| `failed` | Errored, needs investigation |

### Decision rule
- ≥50% context + same domain → **always reuse** via SendMessage
- 40–50% context + same domain → reuse if task is simple/small
- <40% context → retire, spawn fresh

---

<!-- Add worker entries below as they are spawned. Example:

### chrome-api-1
- **Status**: idle | **Skill**: chrome-api | **Context**: ~25% | **Last bead**: BD-12
- **Idle since**: 14:32

### commands-1
- **Status**: retired | **Skill**: commands | **Context**: ~18% | **Last bead**: BD-15

-->

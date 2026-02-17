---
name: taskflow
description: Autonomous task management using Beads. Use when working on multi-step projects, breaking down PRDs, or managing complex implementations. Tracks all work in Beads issue graph.
allowed-tools: Bash, Read, Edit, Write, Glob, Grep
---

# TaskFlow - Autonomous Planning & Execution with Beads

You are an autonomous agent using **Beads** (`bd`) as the system of record. Every strategic action must create or update a Beads issue.

## Rules

1. **Beads is truth** - If not in Beads, it doesn't exist. Never do work without a corresponding issue.
2. **Always update** - Every action = Beads update. Done = close. Blocked = mark blocked + comment why.
3. **Small units** - Tasks must be completable in one session. Decompose anything larger.
4. **Proper types** - Use correct issue types for hierarchy (epic > feature > task).
5. **Durable issues** - Write so another agent can resume without conversation context.

## Entry Protocol

Run on skill activation:

```bash
ls -la .beads/
```

**IF `.beads/` exists:**
- Run `bd ready` to find actionable work
- IF ready issues exist: proceed to execution loop
- IF no ready issues: run `bd blocked` and `bd list` to assess state

**IF `.beads/` does NOT exist:**
- Run `bd doctor` to verify installation
- IF user provided goal/PRD: run `bd init` then proceed to planning mode
- IF no goal: ask user what to accomplish

## Type Selection (Use Correct Types)

| Type | Use When | Priority Default |
|------|----------|------------------|
| `epic` | Top-level goal, major deliverable, ships as a whole | P0 |
| `feature` | User-facing capability, delivers user value | P1 |
| `task` | Implementation work, concrete action | P2 |
| `bug` | Defect, something broken | P1 |
| `chore` | Refactor, cleanup, no user-facing change | P3 |
| `gate` | Coordination point, wait for multiple deps | P2 |

**Decision logic:**
- "What should user see?" → `feature`
- "How do we build that?" → `task`
- "Top-level goal?" → `epic`
- "Broken?" → `bug`
- "Cleanup/refactor?" → `chore`

## Priority Scale

- `0` (P0/CRITICAL) - Blocks everything, drop all other work
- `1` (P1/HIGH) - Important features, major bugs
- `2` (P2/MEDIUM) - Standard work
- `3` (P3/LOW) - Nice-to-have
- `4` (P4/BACKLOG) - Future, not planned

## Command Reference

### Create
```bash
bd create "Title" -t <type> -p <priority> -d "Description"
bd create "Title" -t task --parent <parent-id>  # with hierarchy
```

### Find Work
```bash
bd ready          # Show unblocked, actionable issues (highest priority)
bd blocked        # Show blocked issues
bd list           # All issues
bd show <id>      # Full issue details
```

### Update Status
```bash
bd update <id> --status=in_progress
bd close <id>
bd update <id> --status=blocked
bd comments <id> add "Reason for block / progress notes"
```

### Dependencies
```bash
bd dep add <child-id> <parent-id>              # child blocked by parent
bd dep add <child-id> <parent-id> -t parent-child  # hierarchy
```

### Visibility
```bash
bd graph --all           # Full dependency graph
bd graph <epic-id>       # Epic-specific graph
bd epic status <epic-id> # Epic progress
```

### Critical
```bash
bd sync --flush-only     # ALWAYS run before session end
```

## Planning Mode

When user provides goal/PRD and `.beads/` is initialized:

### 1. Create Epic
```bash
bd create "Goal: <High-level deliverable>" -t epic -p 0 -d "<Why this matters, what defines done>"
```

### 2. Decompose to Features
Break epic into user-facing capabilities:
```bash
bd create "<Feature name>" -t feature -p 1 --parent <epic-id> -d "<User value, acceptance criteria>"
```

### 3. Decompose to Tasks
Break each feature into implementation steps:
```bash
bd create "<Concrete work unit>" -t task -p 2 --parent <feature-id> -d "<Exactly what to do, how to verify>"
```

### 4. Add Dependencies
```bash
bd dep add <task-b-id> <task-a-id>  # B depends on A completing first
```

### 5. Validate
```bash
bd ready          # Should show at least one actionable task
bd graph --all    # Verify structure looks correct
```

**Planning principles:**
- Epic = "Goal: X" format, describes end state
- Features = user-facing capabilities
- Tasks = concrete, actionable work (specific files, endpoints, functions)
- Name by WHAT (deliverable), not WHEN (timeline)
- Each task = 1 focused session max

**Good task examples:**
- "Create User model with email, password_hash, created_at fields in models/user.py"
- "Add POST /api/auth/login endpoint in routes/auth.py returning JWT"
- "Write unit tests for authenticate() in tests/test_auth.py"

**Bad task examples:**
- "Implement backend" (too vague)
- "Handle auth" (unclear scope)
- "Do the database stuff" (not actionable)

## Execution Loop

Run continuously until no ready issues or user input needed:

### 1. Find Work
```bash
bd ready
```

**IF no issues returned:**
- Run `bd blocked` - if blocked issues exist, analyze and resolve blockers
- Run `bd list --status=open` - if no open issues, check if work is complete
- IF nothing to do: report status to user and wait

**IF issues returned:**
- Select highest priority (lowest number)
- Proceed to step 2

### 2. Read Issue
```bash
bd show <id>
```
Parse output for title, description, acceptance criteria, dependencies.

### 3. Claim Issue
```bash
bd update <id> --status=in_progress
```

### 4. Execute Work
- Do EXACTLY what issue describes, no scope creep
- Do NOT add features, refactor unrelated code, or "improve" things
- Stay focused on single issue completion criteria

### 5. Handle Outcome

**IF work completed successfully:**
```bash
bd close <id>
```
Return to step 1.

**IF blocked (need API key, external dependency, user decision):**
```bash
bd update <id> --status=blocked
bd comments <id> add "Blocked because: <specific reason>"
```
Create unblocking task if actionable:
```bash
bd create "Unblock: <what's needed>" -t task -p 1 -d "<how to resolve>"
bd dep add <blocked-id> <unblock-task-id>
```
Return to step 1.

**IF discovered new work during execution:**
```bash
bd create "Found: <new thing>" -t task -p 2 -d "<what needs doing>"
# Optionally link: bd dep add <new-id> <current-id> -t discovered-from
```
Continue current work, new issue will be picked up later.

**IF issue too large (will take >1 session):**
```bash
bd create "Subtask 1: <specific part>" -t task --parent <large-id> -d "..."
bd create "Subtask 2: <specific part>" -t task --parent <large-id> -d "..."
bd dep add <subtask-2> <subtask-1>  # if order matters
bd close <large-id>  # decomposed, now track via subtasks
```
Return to step 1.

## State Detection & Actions

### When `bd ready` returns empty
1. Run `bd blocked` → if results, focus on unblocking
2. Run `bd list --status=open` → if empty, work complete
3. Run `bd list --status=in_progress` → check if you have stale in-progress items
4. IF all clear: report completion to user

### When encountering errors in work
- DO NOT immediately mark blocked
- Attempt to resolve (check code, read docs, fix issues)
- ONLY mark blocked if truly cannot proceed without external input

### When user provides new goal mid-session
- Complete current issue or mark in_progress (don't abandon)
- Create new epic for new goal
- Ask user if they want to switch focus or finish current work first

## Session End Protocol

**CRITICAL - ALWAYS RUN BEFORE SESSION ENDS:**
```bash
bd sync --flush-only
```

This exports Beads state to JSONL. Without this, work is lost.

## Error Handling

**IF `bd` command fails with "not found":**
- Run `bd doctor` to check installation
- Inform user Beads not installed or not in PATH

**IF command fails with "no repository found":**
- Run `bd init` if user wants to start tracking
- Confirm before initializing

**IF dependency graph has cycles:**
- Detect via `bd graph --all` output
- Report to user, ask which dependency to remove

## Anti-Patterns (DO NOT DO)

- Creating issues without executing them (plan paralysis)
- Working without claiming issue first (no audit trail)
- Closing issues that aren't actually done (false progress)
- Creating mega-tasks that take multiple sessions (decompose first)
- Adding "nice to have" scope to existing issues (create separate issue)
- Forgetting `bd sync --flush-only` at session end (data loss)

---

**Remember: If it's not in Beads, it doesn't exist. Use proper types. Always update. If it's ready, work it.**

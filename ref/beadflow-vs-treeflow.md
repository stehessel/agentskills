# Beadflow vs Treeflow — Decision Guide

Both skills use Beads (`bd`) for issue tracking and both support parallel execution via sub-agents. The difference is in **who writes code** and **how much coordination machinery you need**.

## At a Glance

| | Beadflow | Treeflow |
|--|---------|----------|
| **Orchestrator** | Writes code + coordinates | Pure coordinator, never touches code |
| **Sub-agents** | Ephemeral, one-shot | Named, reusable, domain-specialized |
| **State management** | Beads only | Beads + `registry.json` + `tf.py` |
| **Context strategy** | Main agent accumulates everything | Layered files — workers get only what they need |
| **Worker reuse** | None — fresh agent each time | `SendMessage` resumes with full conversation history |
| **Phase transitions** | Manual (check beads, move on) | `tf.py phase-gate` + smoke test |
| **Context pressure** | Main agent fills up over time | Orchestrator stays lean, workers are disposable |
| **Overhead** | Low — just beads | Higher — registry, context files, tf.py, worker prompts |
| **Cost** | 1 agent + ephemeral sub-agents | 1 orchestrator + N named workers |

## Decision Flowchart

```
Does the project fit in one context window?
├─ Yes → beadflow
└─ No or unsure
   │
   Does the main agent need to see all code to make decisions?
   ├─ Yes → beadflow (accept compaction risk)
   └─ No — tasks are independent enough to scope per-worker
      │
      Are there 3+ phases where the same domain repeats?
      ├─ Yes → treeflow (worker reuse pays off)
      └─ No
         │
         Do you need coordination guarantees?
         (phase gates, notification tracking, smoke tests)
         ├─ Yes → treeflow
         └─ No → beadflow with [parallel] groups
```

## Use Beadflow When

- **Project fits in one context window** — the main agent can hold everything it needs
- **Tasks are interconnected** — the agent writing code benefits from seeing prior implementations directly, not through summaries
- **Parallel groups are small** — 2-4 tasks per `[parallel]` group, not recurring across phases
- **You want low overhead** — no registry, no context files, no tf.py
- **Project is 5-15 tasks** — one-session work

Beadflow's built-in `[parallel]` execution handles most parallelism needs. The main agent claims multiple ready issues and spawns ephemeral sub-agents. This is fast and simple for isolated parallel groups.

## Use Treeflow When

- **Project exceeds one context window** — if the main agent would hit compaction after 15-20 tasks, treeflow keeps the orchestrator lean by delegating all code work
- **Workers benefit from reuse** — e.g., `chrome-api-1` doing 3 related Chrome API tasks across phases is faster than 3 cold-start sub-agents because it retains file reads, type definitions, and conventions
- **You need coordination guarantees** — `tf.py phase-gate` prevents premature integration, `tf.py smoke-test` catches incomplete wiring, `tf.py worker-close` ensures beads actually close
- **Worker specialization matters** — the skill routing table ensures the right worker (by domain expertise) gets the right task
- **Project is multi-phase (15-50+ tasks)** — the orchestrator coordinates across phases without accumulating implementation details
- **You want deterministic state management** — registry.json tracks every worker's status, context %, and notification state atomically

## How They Compose

Treeflow builds on beadflow — it uses the same Beads commands, plan format, and sculptor import. The progression is natural:

1. **Start with beadflow** for most projects
2. **Switch to treeflow** when you notice:
   - Context getting full and you're not halfway done
   - Same types of tasks repeating across phases (ripe for worker reuse)
   - Parallel groups getting large (5+ independent tasks)
   - Coordination failures (integration runs too early, workers don't close beads)

You don't need to decide upfront. A beadflow session can be "promoted" to treeflow by having the orchestrator stop writing code and start dispatching workers instead.

## Cost Comparison

For a 20-task project with 3 phases:

**Beadflow**: 1 main agent context window. Sub-agents for `[parallel]` groups are ephemeral and small. Risk: compaction loses context around task 15-20.

**Treeflow**: 1 orchestrator (stays at ~20-30% context throughout) + ~5-8 named workers (each using 30-60% of their context). More total tokens, but no compaction risk and faster wall-clock time due to parallelism.

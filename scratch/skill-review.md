# Skill Review: sculptor & beadflow

Review based on:
- [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview.md)
- [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md)

---

## sculptor/SKILL.md

### What's Working Well

- **Clear phase-based workflow** with explicit approval gates between phases
- **HARD-GATE constraint** effectively prevents scope creep into implementation
- **Annotation format** (`>>` markers) is well-specified with a prefix table
- **Learnings section** captures real session feedback — this is gold for iterative improvement
- **Anti-patterns section** gives clear guardrails
- **Session continuity** via file-based state detection is well-designed

### Issues & Changes Made

#### 1. Description lacks trigger terms (Best Practice: "Be specific and include key terms")

The description should include key terms users might say when they want this skill. Added terms like "brainstorm", "PRD", "spec", "plan" so the skill triggers on more natural language patterns.

**Before:** `Collaborative idea polishing through structured dialogue and annotation cycles. Use when exploring, refining, or formalizing ideas into specs and implementation plans.`

**After:** `Collaborative idea polishing through structured dialogue and annotation cycles. Use when the user wants to brainstorm, explore, refine, or formalize ideas into specs, PRDs, or implementation plans. Handles research, drafting, annotation review, and technical spec creation.`

#### 2. Typo on line 251

"sesnse" -> "sense"

#### 3. Verbose explanations Claude already knows (Best Practice: "Claude is already very smart")

The Research phase had explanations of what "prior art" and "technical landscape" mean — Claude already knows these concepts. The template comments like `[What problem exists, who has it, why it matters]` are fine as structural hints, but the surrounding prose explaining *why* to do research was trimmed.

#### 4. Progressive disclosure for all templates (Best Practice: "Keep SKILL.md under 500 lines")

At ~356 lines, sculptor was within limits but all four inline templates (research, idea, spec, plan) are reference material only needed during their respective phases. Extracted each to a separate file with links from the main SKILL.md:
- `sculptor/RESEARCH-TEMPLATE.md` — research document structure (Phase 2)
- `sculptor/APPENDIX-TEMPLATE.md` — appendix file format for deep research topics (Phase 2)
- `sculptor/IDEA-TEMPLATE.md` — idea document structure, scaling guidance, deferred features tips (Phase 3)
- `sculptor/SPEC-TEMPLATE.md` — spec template + quality checklist + appendix cross-referencing guidance (Phase 5)
- `sculptor/PLAN-TEMPLATE.md` — plan template + quality rules (Phase 5)

This keeps the main file focused on workflow and frees ~140 lines for future learnings growth.

### Not Changed (Considered but left alone)

- **Phase count (7 phases)**: While lengthy, each phase is distinct and the approval gates are important. Collapsing would lose clarity.
- **Naming ("sculptor" vs gerund "sculpting-ideas")**: The best practices suggest gerund form but list noun phrases as "acceptable alternatives." The current name is memorable and clear.
- **HARD-GATE XML tag**: Custom XML tags work fine for emphasis in Claude Code skills.

---

## beadflow/SKILL.md

### What's Working Well

- **`allowed-tools` frontmatter** restricts tool access appropriately
- **Batch-first principle** and command chaining guidance saves tokens at runtime
- **Execution loop** is well-structured with clear decision branches
- **Anti-patterns section** is comprehensive and specific
- **Dependency argument order warnings** prevent a real, common mistake
- **`--json` flag emphasis** is practical for agent consumption

### Issues & Changes Made

#### 1. Name/title mismatch (Best Practice: "Use consistent terminology")

The frontmatter says `name: beadflow` but the H1 title says "TaskFlow." This is confusing for both discovery and conversation. Aligned the H1 to match the frontmatter name.

**Before:** `# TaskFlow - Autonomous Planning & Execution with Beads`
**After:** `# BeadFlow - Autonomous Planning & Execution with Beads`

#### 2. Description improvements (Best Practice: "Be specific and include key terms")

Added more trigger terms and clarified third-person voice.

**Before:** `Autonomous task management using Beads. Use when working on multi-step projects, breaking down PRDs, or managing complex implementations. Tracks all work in Beads issue graph.`

**After:** `Autonomous task planning and execution using Beads (bd). Use when working on multi-step projects, breaking down PRDs or specs into tasks, managing complex implementations, or tracking progress on development work. Creates and manages issues in the Beads issue graph.`

#### 3. Progressive disclosure: Command Reference extracted (Best Practice: "Keep SKILL.md under 500 lines")

At 454 lines, beadflow was close to the 500-line limit. The Command Reference (~100 lines) and Markdown File Format (~80 lines) are reference material that Claude needs when executing specific commands, not when understanding the overall workflow. Extracted to:
- `beadflow/COMMANDS.md` — full command reference
- `beadflow/PLAN-FORMAT.md` — markdown file format for `bd create -f`

This brings the main SKILL.md to ~280 lines, leaving room for future learnings.

#### 4. Environment Setup section removed (Best Practice: "Only add context Claude doesn't already have")

The Environment Setup section (verify runtime version, install deps, create stubs, use modern idioms) is generic development advice that Claude already follows. It's not specific to Beads task management. Removed it from the skill — if needed, this guidance belongs in a project's CLAUDE.md or in a separate dev-setup skill.

#### 5. Redundant anti-patterns trimmed

Several anti-patterns repeated guidance already covered in earlier sections (e.g., "use `bd create -f` instead" was stated in both the command reference and anti-patterns). Kept the anti-patterns list but removed entries that were exact duplicates of inline guidance.

---

## Summary of Changes

| File | Change | Rationale |
|------|--------|-----------|
| `sculptor/SKILL.md` | Improved description with trigger terms | Better skill discovery |
| `sculptor/SKILL.md` | Fixed "sesnse" typo | Correctness |
| `sculptor/SKILL.md` | Trimmed verbose research guidance | Claude already knows this |
| `sculptor/SKILL.md` | Extracted all 4 templates to separate files | Progressive disclosure |
| `sculptor/RESEARCH-TEMPLATE.md` | New file: research document template | Referenced from Phase 2 |
| `sculptor/APPENDIX-TEMPLATE.md` | New file: appendix file format for deep-dive topics with sample data guidance | Referenced from Phase 2, cross-referenced from SPEC-TEMPLATE |
| `sculptor/IDEA-TEMPLATE.md` | New file: idea document template + scaling/deferred features guidance | Referenced from Phase 3 |
| `sculptor/SPEC-TEMPLATE.md` | New file: spec template + quality checklist | Referenced from Phase 5 |
| `sculptor/PLAN-TEMPLATE.md` | New file: plan template + quality rules | Referenced from Phase 5 |
| `beadflow/SKILL.md` | Fixed title to match name ("BeadFlow") | Consistency |
| `beadflow/SKILL.md` | Improved description with trigger terms | Better skill discovery |
| `beadflow/SKILL.md` | Extracted command reference to COMMANDS.md | Progressive disclosure |
| `beadflow/SKILL.md` | Extracted plan format to PLAN-FORMAT.md | Progressive disclosure |
| `beadflow/SKILL.md` | Removed generic Environment Setup section | Not skill-specific |
| `beadflow/COMMANDS.md` | New file: full command reference | Referenced from main skill |
| `beadflow/PLAN-FORMAT.md` | New file: markdown file format for bd create -f | Referenced from main skill |

# Plan: Create the `sculptor` Skill

## Context

We need a new skill for collaborative idea polishing — helping users turn vague ideas into fully-formed, well-structured concepts through natural dialogue and iterative annotation cycles. The approach is adapted from Boris Tane's Claude Code workflow (Research → Plan → Annotate → Todo list) but scoped to **ideation only** — no scaffolding, no implementation actions.

The core insight from the blog (reinforced by HN discussion): markdown files as shared mutable state between human and AI. The user annotates at their own pace in their editor, Claude addresses notes, repeat until polished. Phase separation (thinking vs. typing) is the real value.

## Files to Create/Modify

1. **`sculptor/SKILL.md`** — Primary skill definition (NEW)
2. **`AGENTS.md`** — Add sculptor to the skill catalog
3. **`README.md`** — Add sculptor to the available skills table
4. **Delete `brainstorm.md`** from repo root (draft; the skill replaces it)

## SKILL.md Design

### Frontmatter

```yaml
---
name: sculptor
description: Collaborative idea polishing through structured dialogue and annotation cycles. Use when exploring, refining, or formalizing ideas into specs, PRDs, or implementation plans.
---
```

### Workflow Phases

**Phase 1: INTAKE**
- User presents their idea (can be vague, a sentence, a paragraph, anything)
- Skill asks probing questions to understand intent, context, constraints, and desired outcome
- Determine what research sources are available (existing project? web resources? docs?)
- Name the idea and create directory: `{idea-name}/`

**Phase 2: RESEARCH**
- Gather context from any available source:
  - Existing codebase (files, docs, recent commits)
  - Web resources (competitor analysis, prior art, technical landscape)
  - User-provided documents or links
  - Back-and-forth dialogue to extract domain knowledge from the user
- Write findings to `{idea-name}/research.md`
- User reviews research before proceeding

**Phase 3: DRAFT**
- Structure the idea into a polished document
- Write to `{idea-name}/idea.md`
- Propose 2-3 approaches where relevant (all at once, not sequentially)
- Code snippets and pseudo-code are welcome where they add value to the idea
- Sections scaled to complexity:
  - Simple idea → Problem, Solution, Rationale (few paragraphs)
  - Complex idea → Problem, Context, Proposed Solutions (2-3), Trade-offs, Open Questions, Recommended Approach
- Present design in sections, get user approval after each major section

**Phase 4: ANNOTATE (repeat 1-6x)**
- Tell user: "Open `{idea-name}/idea.md` in your editor and add inline notes wherever you have feedback, corrections, or constraints. Tell me when you're done."
- User adds inline annotations (any format — comments, notes, markers, plain text insertions)
- User signals completion (e.g., "I've annotated" or "address my notes")
- Claude reads the file, identifies all annotations, addresses each one
- Updates the document with changes
- Guard: stay in ideation — no scaffolding or implementation actions
- Repeat until user approves the document

**Phase 5: FINALIZE**
- Clean up the document — remove annotation markers, polish prose
- Final version of the polished idea document
- Ask user if they want to escalate

**Phase 6: ESCALATE (optional)**
- User can request additional artifacts:
  - **PRD** → `{idea-name}/prd.md` (user stories, acceptance criteria, scope, constraints)
  - **Technical Spec** → `{idea-name}/spec.md` (architecture, data models, APIs, integrations)
  - **Implementation Plan** → `{idea-name}/plan.md` (phased tasks with todo checklist)
- For implementation plans: check if a `writing-plans` skill is available and invoke it; otherwise create the plan internally
- Each escalation artifact goes through its own annotation cycle if the user wants

### Hard Gate

```
<HARD-GATE>
This skill NEVER scaffolds projects, creates source code files, or takes implementation actions.
Output is exclusively markdown documents. Code snippets within documents are fine when they
clarify the idea.
</HARD-GATE>
```

### Anti-Pattern: "Too Simple To Design"

Every idea goes through this process. A todo list, a utility function, a config change — all of them. The design can be short (a few sentences), but it MUST be presented and approved.

### Anti-Patterns List

- Skipping research ("I already know what this needs")
- Proposing only one approach (always offer alternatives where reasonable)
- Annotating on behalf of the user (user annotates, Claude addresses)
- Moving to implementation before the idea is approved
- Making the document longer than it needs to be (scale to complexity)

### Session Continuity

- All state lives in `{idea-name}/` directory
- Files survive context compaction
- A new session can resume by reading the directory contents and detecting which phase the idea is in (which files exist, whether they contain unaddressed annotations)

## AGENTS.md Updates

Add sculptor to the Workflow & Process Skills table and the Detailed Skill Information section with:
- Category: Workflow
- Activation triggers: idea exploration, brainstorming, concept refinement, PRD creation, spec writing, "I have an idea", "let's think through this", "help me design"

## README.md Updates

Add sculptor to the Workflow Skills table with description and "when to use" column.

## Verification

1. Review the SKILL.md for completeness and consistency with the beadflow skill pattern
2. Verify AGENTS.md and README.md are updated consistently
3. Manual test: invoke the skill with a vague idea and walk through intake → research → draft → annotate → finalize

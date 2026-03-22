# Plan: Convert review-system.md into a Skill

## Context

`scratch/review-system.md` contains a two-phase code review system originally designed for a two-agent handoff (Phase 1 generates a `review-prompt.md`, Phase 2 reads it in a fresh context window). As a skill, that handoff is unnecessary — the agent has codebase access and can explore, select checks, review, and report in one continuous flow.

The report has two distinct sections: spec deviations (if a spec exists) and code quality findings, clearly separated.

## Skill Structure

**Directory**: `reviewer/`

```
reviewer/
├── SKILL.md                 # Core workflow: frontmatter + single-phase flow + anti-patterns (~280 lines)
├── CHECKLIST-CATALOG.md     # All checklist modules with selection matrix (~180 lines)
└── REPORT-TEMPLATE.md       # Standard output report structure (~90 lines)
```

**Why 3 files**: The checklist catalog (~180 lines) and report template (~90 lines) would push SKILL.md over the 500-line limit. Both are reference material loaded at specific moments — progressive disclosure applies.

## Files to Create

### `reviewer/SKILL.md`

```yaml
---
name: reviewer
description: Conducts a comprehensive code review by exploring the codebase, selecting tech-stack-specific checklist modules, and producing a structured report with spec deviation findings and code quality findings in separate sections. Use when asked to review a codebase, audit code quality, check spec compliance, or assess production readiness.
---
```

Body sections (in order):
1. **Rules** (5 items): explore before reviewing, read-only, select relevant modules only, spec deviations and code quality are separate report sections, anti-patterns must reference specific files
2. **Step 1: Discovery**
   - Detect language/framework (go.mod, package.json, pyproject.toml, Cargo.toml, etc.)
   - Map project structure and entry points
   - Search for spec/requirements (SPEC.md, PRD.md, docs/plan.md, README.md, ADRs, etc.)
   - Identify config/deploy artifacts and CI/CD
   - Detect architecture patterns and external integrations
   - Note project conventions (CLAUDE.md, CONTRIBUTING.md, etc.)
   - Read 10-15 representative files minimum before proceeding
3. **Step 2: Checklist Selection**
   - Always include Universal modules (U, T, P, A, D)
   - Add language modules based on detected stack
   - Add framework/infra modules if applicable
   - Reference `CHECKLIST-CATALOG.md` for all module IDs and the selection matrix
4. **Step 3: Spec Traceability** (if spec found)
   - Read spec completely
   - Map each spec section to implementation file(s)
   - Build traceability matrix (spec section → file:line)
   - Skip this step and note it if no spec found
5. **Step 4: Code Review**
   - Read bottom-up: domain/models → services → handlers/controllers → tests
   - Evaluate each selected checklist item
   - Record findings with file:line, severity, expected vs actual
6. **Step 5: Report**
   - Use structure from `REPORT-TEMPLATE.md`
   - Spec Deviations section: populated from traceability matrix + spec checks; omit if no spec
   - Code Quality section: populated from checklist evaluation
   - Adjust scorecard category weights based on project type
7. **Anti-Patterns (DO NOT DO)** (~10 items): skipping discovery, including all checklist modules regardless of stack, mixing spec deviations into code quality findings, generic anti-patterns not tied to specific files, guessing file:line, leaving report placeholders unfilled, not adjusting scorecard weights
8. **Reference Files** — small pointer table (when to load each supporting file)

### `reviewer/CHECKLIST-CATALOG.md`

- TOC at top (file exceeds 100 lines → required per best-practices)
- All modules verbatim from source: Universal (U1-U14, T1-T8, P1-P7, A1-A5, D1-D5), Language (GO1-GO10, TS1-TS8, PY1-PY8, RS1-RS8, JV1-JV6), Framework (TW1-TW15, FE1-FE6), Infrastructure (DB1-DB6, API1-API7)
- Module Selection Matrix at bottom: detected signal → modules to add

### `reviewer/REPORT-TEMPLATE.md`

With TOC added:
- Header (title, date, codebase stats)
- Executive Summary (overall assessment, severity table, top findings)
- **Spec Deviations** (traceability matrix, deviations, missing features) — omit section entirely if no spec
- **Code Quality Findings** (per-finding format: SEVERITY / ID / File / Issue / Expected / Actual / Recommendation, grouped by checklist module)
- Test Coverage Map (package-level table)
- Summary Scorecard (categories, weights, weighted scores, total/5.00 — spec compliance weight redistributed if no spec)
- Scoring Rubric + Category Weights
- Appendix A: Files Reviewed, B: Anti-Patterns Checked, C: Prioritized Recommendations

## Files to Update

### `README.md`
Add row to Workflow Skills table:
```
| [reviewer](./reviewer/SKILL.md) | Comprehensive code review with tech-stack-specific checklists, spec deviation tracking, and structured report | Codebase audits, spec compliance checks, production readiness assessment, code quality reviews |
```

### `AGENTS.md`
1. Add row to Workflow & Process Skills catalog table
2. Add Detailed Skill Information entry (Category, Description, When to Activate, Key Capabilities, Entry Point, File Location)
3. Update "Total Skills" count (2 → 3)

## Key Design Decisions

- **Single phase**: The two-phase design was for the two-agent handoff pattern. In a skill, the agent explores and reviews in one continuous flow — no `review-prompt.md` intermediate file.
- **Separate report sections**: Spec deviations and code quality findings are in distinct sections. Spec section is omitted entirely (not just empty) when no spec exists.
- **Name `reviewer`**: Simple, unambiguous. Covers both spec compliance and general code quality.
- **Checklist at runtime**: SKILL.md describes selection logic; agent reads CHECKLIST-CATALOG.md during Step 2 only.

## Verification

1. `reviewer/SKILL.md` is under 500 lines
2. All SKILL.md references are one level deep
3. Description is third-person with when-to-use triggers
4. CHECKLIST-CATALOG.md has a TOC (>100 lines)
5. README.md and AGENTS.md updated consistently; AGENTS.md total count updated

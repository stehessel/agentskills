# Universal Code Review System — Two-Phase Approach

This document contains two prompts that work together:
1. **Phase 1 (Analyzer)**: Explores any codebase and generates a specialized review prompt
2. **Phase 2 (Reviewer)**: The generated prompt that performs the actual review

Copy each phase into a separate file or use them inline with your AI agent tooling.

---

# Phase 1: Codebase Analyzer

> Copy everything below this line through the "END PHASE 1" marker.

---

## PHASE 1 PROMPT: CODEBASE ANALYSIS & REVIEW PROMPT GENERATION

You are a senior software architect tasked with analyzing a codebase and producing a specialized code review prompt. You will explore the project, understand its architecture, identify its tech stack, locate its spec/requirements, and generate a comprehensive, project-specific review prompt that another agent can execute.

**This is a READ-ONLY task. Do not modify any files except the output file specified at the end.**

### Step 1: Project Discovery

Explore the codebase to determine:

1. **Language & Framework**
   - Primary language(s) and version (check go.mod, package.json, pyproject.toml, Cargo.toml, etc.)
   - Key frameworks (web, ORM, testing, async runtime, etc.)
   - Build system (Make, Gradle, Cargo, npm, etc.)

2. **Project Structure**
   - List all source directories and their purposes
   - Count files and approximate LOC per directory
   - Identify entry point(s) (main, index, app)
   - Identify test files and test framework

3. **Spec / Requirements**
   - Search for: `docs/spec.md`, `docs/requirements.md`, `SPEC.md`, `PRD.md`, `docs/plan.md`, `docs/design.md`, `docs/architecture.md`, `README.md`, any `*.spec.*` or `*.requirements.*` files
   - Also check: Jira links, GitHub issues referenced in code, ADRs (`docs/adr/`), RFCs
   - If no formal spec exists, note this — the review will focus on code quality only

4. **Configuration & Deployment**
   - Config files (YAML, JSON, TOML, env)
   - Dockerfile, docker-compose, Helm charts, Terraform
   - CI/CD (.github/workflows, .gitlab-ci.yml, Jenkinsfile, .circleci)
   - Linter config (.eslintrc, .golangci.yml, .rubocop.yml, pyproject.toml [tool.ruff], etc.)

5. **Architecture Patterns**
   - Identify the architecture style: monolith, microservices, event-driven, workflow-based, CLI, library, etc.
   - Identify key patterns: dependency injection, repository pattern, CQRS, actor model, middleware, plugin system, etc.
   - Identify external system integrations (APIs, databases, message queues, cloud services)
   - Map the dependency direction between packages/modules

6. **Project-Specific Conventions**
   - Check CLAUDE.md, CONTRIBUTING.md, .editorconfig, code style guides
   - Note any project-specific patterns, naming conventions, or architectural rules

### Step 2: Tech-Stack-Specific Checklist Selection

Based on what you discovered, select the relevant checklist modules from the catalog below. Every project gets the **Universal** module. Then add language-specific and framework-specific modules.

#### Universal Module (always included)

**U: Code Quality**
| ID | Check | Severity |
|----|-------|----------|
| U1 | Error/exception handling: errors are not swallowed silently; errors include context/stack info | High |
| U2 | Resource cleanup: files, connections, handles are closed/released (defer, finally, using, context managers, RAII) | High |
| U3 | Input validation at system boundaries (user input, API requests, config values, file contents) | High |
| U4 | No hardcoded secrets, credentials, API keys, or tokens in source code | Critical |
| U5 | No SQL injection, command injection, XSS, path traversal, or other injection vulnerabilities | Critical |
| U6 | Consistent naming conventions (casing, prefixes, verb forms) across the codebase | Low |
| U7 | Functions/methods have reasonable length (<50 lines guideline) and cognitive complexity (<15) | Medium |
| U8 | No dead code: unused imports, unreachable branches, commented-out code blocks, unused variables/functions | Low |
| U9 | Constants/enums used instead of magic numbers/strings scattered through code | Medium |
| U10 | Dependency direction is acyclic; no circular imports/dependencies between modules | High |
| U11 | Single responsibility: each file/module/class has one coherent purpose | Low |
| U12 | DRY: no significant code duplication (>10 lines repeated 3+ times) | Medium |
| U13 | Logging is structured (key-value, JSON) not string-interpolated; log levels used appropriately | Medium |
| U14 | Configuration centralized in one module; no scattered env var reads or hardcoded URLs | Medium |

**T: Testing**
| ID | Check | Severity |
|----|-------|----------|
| T1 | Test files exist for all non-trivial source files — list coverage gaps by package/module | High |
| T2 | Tests cover both success AND error/edge-case paths | High |
| T3 | Tests are isolated: no shared mutable state, no test ordering dependencies | Medium |
| T4 | Mocks/stubs are specific (not overly permissive catch-alls) | Medium |
| T5 | Test helpers use framework conventions for accurate error reporting (t.Helper in Go, custom assertions in pytest, etc.) | Low |
| T6 | Tests run with race/thread-safety detection enabled (if applicable to language) | High |
| T7 | Integration vs unit tests are clearly separated (different directories, tags, or naming) | Low |
| T8 | Critical business logic paths have thorough test coverage | High |

**P: Production Readiness**
| ID | Check | Severity |
|----|-------|----------|
| P1 | Health/readiness endpoints or probes defined (if deployed as service) | Medium |
| P2 | Metrics/observability: key operations are instrumented (latency, error rates, throughput) | Medium |
| P3 | Graceful shutdown: signal handling, drain connections, complete in-flight work | Medium |
| P4 | Container security: non-root user, minimal base image, no unnecessary tools in runtime | High |
| P5 | CI pipeline: lint + test + build + (security scan if applicable) | Medium |
| P6 | Dependencies are pinned to specific versions (lockfile exists and committed) | Medium |
| P7 | Dockerfile multi-stage build separates build dependencies from runtime | Low |

**A: Architecture**
| ID | Check | Severity |
|----|-------|----------|
| A1 | Clear separation of concerns: presentation/API layer, business logic, data access, external integrations | Medium |
| A2 | Dependency direction flows inward: domain/models have no outward dependencies | High |
| A3 | External systems accessed through abstraction layer (client/adapter/gateway), not directly from business logic | Medium |
| A4 | Configuration and secrets management separated from business logic | Medium |
| A5 | Extensibility: adding a new integration or feature doesn't require modifying unrelated code | Low |

**D: Documentation & Understandability**
| ID | Check | Severity |
|----|-------|----------|
| D1 | Exported/public APIs have doc comments explaining purpose, parameters, and return values | Low |
| D2 | Complex algorithms or non-obvious logic have explanatory comments | Medium |
| D3 | No redundant comments that merely restate the code | Info |
| D4 | TODOs/FIXMEs are tracked — list all with their locations | Info |
| D5 | README exists with: what the project does, how to build, how to run, how to test | Low |

#### Go Module

| ID | Check | Severity |
|----|-------|----------|
| GO1 | Errors wrapped with `fmt.Errorf("context: %w", err)` — never bare `return err` without added context | Medium |
| GO2 | `context.Context` is the first parameter of functions that do I/O, and is propagated (not ignored) | High |
| GO3 | Long-running operations check `ctx.Done()` / `ctx.Err()` for cancellation | Medium |
| GO4 | Interfaces defined by the consumer (not the implementer) and kept small | Medium |
| GO5 | Exported types/functions have godoc comments starting with the name | Low |
| GO6 | `defer` used for cleanup (file close, mutex unlock, response body close) | High |
| GO7 | No goroutine leaks: spawned goroutines have shutdown paths via context or channels | High |
| GO8 | `sync.Mutex` / `sync.RWMutex` used correctly; no data races (verified by `-race` flag) | High |
| GO9 | Table-driven tests with `t.Run(name, ...)` subtests | Low |
| GO10 | `filepath.Join` used instead of string concatenation for file paths | Low |

#### TypeScript/JavaScript Module

| ID | Check | Severity |
|----|-------|----------|
| TS1 | Strict TypeScript enabled (`"strict": true` in tsconfig) | High |
| TS2 | No `any` type usage except where genuinely unavoidable (count instances) | Medium |
| TS3 | Async/await used consistently (no mixing callbacks and promises unnecessarily) | Medium |
| TS4 | Promise rejections always handled (no unhandled promise rejections) | High |
| TS5 | Nullability handled: optional chaining, nullish coalescing, or explicit checks | Medium |
| TS6 | Dependencies in correct section (dependencies vs devDependencies) | Low |
| TS7 | ESLint/Biome configured and CI enforces it | Medium |
| TS8 | No `console.log` in production code (use structured logger) | Low |

#### Python Module

| ID | Check | Severity |
|----|-------|----------|
| PY1 | Type hints used on function signatures and enforced by mypy/pyright | Medium |
| PY2 | Virtual environment / dependency management (poetry, pip-tools, uv) with lockfile | Medium |
| PY3 | Context managers (`with` statements) used for resource management | High |
| PY4 | Exception handling: specific exceptions caught (not bare `except:` or `except Exception`) | High |
| PY5 | No mutable default arguments (e.g., `def f(x=[])`) | High |
| PY6 | Async code: no blocking I/O in async functions; `asyncio.to_thread` for CPU-bound | Medium |
| PY7 | Ruff/flake8/black configured and CI enforces it | Medium |
| PY8 | Tests use pytest with fixtures, not unittest.TestCase (unless legacy) | Low |

#### Rust Module

| ID | Check | Severity |
|----|-------|----------|
| RS1 | `unwrap()` / `expect()` only used where panic is acceptable (tests, infallible cases); production code uses `?` or match | High |
| RS2 | `Clone` not used to work around borrow checker when references would work | Medium |
| RS3 | Error types implement `std::error::Error` with proper `source()` chaining | Medium |
| RS4 | Lifetimes explicit only when necessary; elision used where possible | Low |
| RS5 | `clippy` configured and CI enforces it with `-D warnings` | Medium |
| RS6 | No `unsafe` blocks unless justified with safety comments | High |
| RS7 | Async runtime (tokio) used correctly: no blocking in async context | High |
| RS8 | Cargo.toml: features used for optional dependencies; no unnecessary feature flags | Low |

#### Java/Kotlin Module

| ID | Check | Severity |
|----|-------|----------|
| JV1 | Null safety: `Optional` or `@Nullable`/`@NonNull` annotations (Java); null safety enforced (Kotlin) | High |
| JV2 | Resources closed with try-with-resources (Java) or `.use {}` (Kotlin) | High |
| JV3 | Exceptions: checked exceptions not abused; runtime exceptions have context messages | Medium |
| JV4 | Dependency injection framework configured correctly (Spring, Guice, Dagger, Koin) | Medium |
| JV5 | Thread safety: concurrent collections, synchronized blocks, or immutable objects where shared | High |
| JV6 | Logging via SLF4J/Logback (not System.out.println) with parameterized messages | Medium |

#### Temporal Workflow Module (for projects using Temporal)

| ID | Check | Severity |
|----|-------|----------|
| TW1 | **No `time.Now()` / `Date.now()` / system clock in workflow code** — must use `workflow.Now(ctx)` or SDK equivalent. Trace ALL code paths reachable from workflow functions, including helpers | Critical |
| TW2 | **No goroutines/threads in workflow code** — use `workflow.Go()` / SDK async primitives | Critical |
| TW3 | **No `time.Sleep()` / `Thread.sleep()` in workflow code** — use `workflow.Sleep(ctx, duration)` | Critical |
| TW4 | **No map/dict iteration for ordering in workflow code** — use sorted/ordered collections | Critical |
| TW5 | **No I/O in workflow code** — all file, network, database operations must be in activities | Critical |
| TW6 | **ContinueAsNew for infinite/long-running loops** — workflows that loop with sleep must call ContinueAsNew after N iterations to prevent unbounded history growth (~50K event limit) | Critical |
| TW7 | Activity timeouts always set: every ExecuteActivity has explicit StartToCloseTimeout or ScheduleToCloseTimeout | Critical |
| TW8 | ScheduleToCloseTimeout >= StartToCloseTimeout (both set consistently) | High |
| TW9 | Heartbeat timeout set on long-running activities; activities call RecordHeartbeat periodically | High |
| TW10 | Retry policy: non-idempotent mutations have MaxAttempts=1; reads/queries allow retries | High |
| TW11 | Child workflow IDs are deterministic and unique | Medium |
| TW12 | Query handlers registered at workflow start, before any blocking calls | High |
| TW13 | Workflow state size bounded — no unbounded list/log growth in serialized state | High |
| TW14 | Non-retryable errors marked with `temporal.NewNonRetryableApplicationError` or equivalent | High |
| TW15 | Workflow versioning (`GetVersion`) used for changes to in-flight workflows | Medium |

#### React/Frontend Module

| ID | Check | Severity |
|----|-------|----------|
| FE1 | Components follow single-responsibility (not god components with 500+ lines) | Medium |
| FE2 | State management: no prop drilling beyond 2 levels; context/store used appropriately | Medium |
| FE3 | Effects have correct dependency arrays (no missing deps, no unnecessary re-renders) | High |
| FE4 | User input sanitized before rendering (XSS prevention) | Critical |
| FE5 | Accessibility: semantic HTML, ARIA labels, keyboard navigation | Medium |
| FE6 | Bundle size: no giant dependencies imported for minor utilities | Low |

#### Database/ORM Module

| ID | Check | Severity |
|----|-------|----------|
| DB1 | Parameterized queries used (no string concatenation for SQL) | Critical |
| DB2 | Migrations are reversible and idempotent | Medium |
| DB3 | Indexes exist for frequently queried columns and foreign keys | Medium |
| DB4 | Connection pooling configured with reasonable limits | High |
| DB5 | Transactions used for multi-step mutations; isolation level appropriate | High |
| DB6 | N+1 query patterns avoided (eager loading or batching) | Medium |

#### API/HTTP Module

| ID | Check | Severity |
|----|-------|----------|
| API1 | Authentication/authorization on all non-public endpoints | Critical |
| API2 | Rate limiting configured for public-facing endpoints | High |
| API3 | Request validation: size limits, type checks, required fields | High |
| API4 | Error responses don't leak internal details (stack traces, SQL errors) | High |
| API5 | CORS configured restrictively (not `*` in production) | Medium |
| API6 | Timeouts set on HTTP clients and servers | High |
| API7 | Pagination on list endpoints (no unbounded result sets) | Medium |

### Step 3: Spec Compliance Setup

If a spec/requirements document was found:

1. Read it completely
2. For each section/requirement, identify the expected code artifact(s)
3. Build a **Spec Traceability Matrix** mapping spec sections to implementation files
4. Add spec-specific checklist items (e.g., "Spec 4.3 requires RC loop to increment counter — verify")

If no spec was found, skip this section and note in the output that review is code-quality-only.

### Step 4: Anti-Pattern Discovery

Based on the tech stack and architecture, identify project-specific anti-patterns to watch for. Look for:

1. **Known risks from the framework** (e.g., Temporal determinism, React stale closures, Django N+1)
2. **Patterns you spotted during exploration** (e.g., manual polling with magic numbers, incomplete stubs, nil dereference risks)
3. **Integration risks** (e.g., missing retry logic for external APIs, no circuit breaker, unbounded polling)

List 5-15 specific anti-patterns with:
- What to look for
- Where it's likely to appear (specific files/directories)
- Why it matters
- Example of correct vs incorrect code (if useful)

### Step 5: Generate the Review Prompt

Produce the specialized review prompt as a single markdown document. Use the template structure below, filling in all project-specific details.

**Output the generated prompt to: `{project_root}/review-prompt.md`** (or another path if the user specifies one).

---

### Generated Review Prompt Template

The output prompt MUST follow this structure:

```markdown
# {Project Name} — Code Review Prompt

You are a senior {language} engineer conducting a comprehensive code review.
This is a READ-ONLY review. Do not modify any files.

## Project Context
{Brief description, scale (files/LOC/tests), tech stack, architecture style}

## Spec Reference
{Path to spec document, or "No formal spec — code-quality review only"}

## Review Sequence
{Ordered list of files/directories to read, organized by dependency layer — bottom-up}

## Checklist
{Selected modules from the catalog, customized with project-specific details:
- Universal module (always)
- Language module(s)
- Framework module(s)
- Spec compliance items (if spec exists)}

## Anti-Pattern Watchlist
{5-15 project-specific anti-patterns with file hints}

## Spec Compliance Protocol (if applicable)
{3-pass verification: mapping → field comparison → behavioral trace}

## Output Report Template
{The standard report template — see below}

## Scoring & Instructions
{Scoring rubric and review instructions}
```

### Standard Output Report Template (include verbatim in generated prompt)

````markdown
# {Project Name} — Code Review Report

**Generated**: {date}
**Codebase**: {file_count} files, ~{loc} LOC, {test_count} test files

---

## Executive Summary

**Overall Assessment**: {PASS | PASS WITH CONCERNS | NEEDS WORK | FAIL}

| Severity | Count |
|----------|-------|
| Critical | {n} |
| High     | {n} |
| Medium   | {n} |
| Low      | {n} |
| Info     | {n} |

### Top Findings (by Impact)
1. ...
2. ...
3. ...

---

## Findings by Category

For each finding:

### [{SEVERITY}] {ID}: {Title}
- **File**: {path}:{line}
- **Issue**: {description}
- **Expected**: {correct pattern}
- **Actual**: {what code does}
- **Recommendation**: {specific fix}

{Organize findings under category headers matching the checklist modules used}

---

## Spec Compliance Report (if applicable)

### Traceability Matrix
| Spec Section | Status | Implementation File(s) | Notes |
|-------------|--------|----------------------|-------|
| ... | PASS/PARTIAL/MISSING | file:line | ... |

### Deviations
{List each with spec ref, expected, actual, severity}

### Missing Features
{Spec requirements with no implementation}

---

## Test Coverage Map

| Package/Module | Source Files | Test Files | Untested Areas | Gap Severity |
|---------------|-------------|------------|----------------|-------------|
| ... | ... | ... | ... | ... |

---

## Summary Scorecard

| Category | Score (1-5) | Weight | Weighted Score |
|----------|-------------|--------|----------------|
| {category} | {score} | {weight}% | {weighted} |
| ... | ... | ... | ... |
| **Overall** | | **100%** | **{total}/5.00** |

### Scoring Rubric
- **5 — Exemplary**: No issues or only Info-level notes
- **4 — Good**: Minor issues only (Low severity)
- **3 — Adequate**: Some Medium issues, no Critical/High
- **2 — Needs Work**: High severity issues present
- **1 — Critical Gaps**: Critical issues or major spec deviations

### Category Weights (adjust based on project)
- Spec Compliance: 25% (0% if no spec)
- Language Best Practices: 20%
- Framework Patterns: 15% (0% if no framework-specific checks)
- Production Readiness: 15%
- Test Quality & Coverage: 15%
- Architecture: 10%
- Understandability: 5% (redistributed from spec if no spec)

---

## Appendix A: Files Reviewed
{Complete list with line counts}

## Appendix B: Anti-Patterns Checked
{Each anti-pattern with FOUND / NOT FOUND status}

## Appendix C: Prioritized Recommendations
{All findings ordered by: Critical first, then quick wins, then high-impact}
````

---

## Final Instructions for Phase 1 Agent

1. Explore the codebase thoroughly before generating — read at least 10-15 representative files
2. Select ONLY the relevant checklist modules (don't include Python checks for a Go project)
3. Customize checklist items with project-specific details (file paths, function names, config keys)
4. The generated prompt must be SELF-CONTAINED — the Phase 2 reviewer should not need this meta-prompt
5. Include the complete output report template verbatim in the generated prompt
6. The anti-pattern watchlist should reference SPECIFIC files and patterns you discovered, not generic advice
7. If a spec exists, the spec compliance section should have CONCRETE items (not "check if spec is met" but "spec section 3.2 requires field X of type Y — verify in model/release.go")
8. Adjust category weights based on what matters for this project (e.g., a library needs API design weight; a service needs production readiness weight; a spec-driven project needs compliance weight)

--- END PHASE 1 ---

---

# Phase 2: Execution

Phase 2 is the **generated prompt** from Phase 1. It is project-specific and self-contained.

To execute:
1. Run Phase 1 against your codebase → produces `review-prompt.md`
2. Give `review-prompt.md` to a fresh agent as its prompt
3. The agent reads all files, evaluates the checklist, and produces the structured report

### Tips for Best Results

- **Use a capable model** (Opus-class) for both phases — the review requires deep code understanding
- **Give the Phase 2 agent enough context window** — it needs to read the spec + all source files + produce a long report
- **Run Phase 2 multiple times** if your codebase is very large — split by package/module and merge reports
- **The Phase 1 output is reusable** — re-run Phase 2 after making fixes to track improvement
- **Adjust weights** in the scorecard to match your priorities (e.g., bump test coverage weight if that's your focus)

### Agent Tool Invocation Example

```
# Phase 1: Generate specialized review prompt
Agent(prompt=<contents of Phase 1 prompt>, subagent_type="general-purpose")

# Phase 2: Execute the review
Agent(prompt=<contents of generated review-prompt.md>, subagent_type="general-purpose")
```

Or with Claude Code:
```bash
# Phase 1
cat config/templates/review-system.md | # extract Phase 1 section
claude --prompt "$(cat phase1-prompt.md)"

# Phase 2
claude --prompt "$(cat review-prompt.md)"
```

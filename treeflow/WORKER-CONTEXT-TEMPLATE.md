# {Plan Name} — Worker Context

> Sent to all workers. Do not include Worker Registry or Skill Routing — those are orchestrator-only (worker-registry.md).
> Remove this header line before writing the file.

## Overview

{1-2 sentence description of what is being built and why}

## Tech Stack

- **Language/Runtime**: {e.g., TypeScript, Go, Python}
- **Framework**: {e.g., WXT, Next.js, Gin}
- **Key libraries**: {e.g., React, Fuse.js, xterm.js}
- **Testing**: {e.g., Vitest, Go test}
- **Build**: {e.g., Vite, esbuild}

## Repo Structure

```
{paste the relevant directory tree — focus on where workers will be writing}
```

## Coding Conventions

- {e.g., Conventional commits: feat:, fix:, chore:}
- {e.g., Each command implements the Command interface}
- {e.g., All state in chrome.storage — no module-level globals}
- {e.g., Shadow DOM: use px only, not rem}

## Key Specs

- Full spec: `{path/to/spec.md}`
- {Other relevant docs with paths}

## Known Gotchas

{Empty at session start. Orchestrator appends entries as workers discover recurring issues.}

<!-- Example entry format:
- **{Issue}**: {Explanation and what to do}
  e.g. "TS `Cannot find name 'chrome'` diagnostics are LSP false positives in WXT projects — the build still passes, ignore them."
-->

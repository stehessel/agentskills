# APM Installation Guide

This repository supports installation via [APM (Agent Package Manager)](https://microsoft.github.io/apm/), which provides automatic skill deployment across multiple AI coding tools.

## Quick Start

### Install APM

**macOS/Linux:**
```bash
curl -sSL https://aka.ms/apm-unix | sh
```

**Windows (PowerShell):**
```powershell
irm https://aka.ms/apm-windows | iex
```

Verify installation:
```bash
apm --version
```

### Install Skills

**Install all skills from this collection:**
```bash
apm install stehessel/agentskills
```

**Install individual skills:**
```bash
apm install stehessel/agentskills/beadflow
apm install stehessel/agentskills/reviewer
apm install stehessel/agentskills/sculptor
apm install stehessel/agentskills/treeflow
apm install stehessel/agentskills/session-viewer
```

**Install a specific version:**
```bash
apm install stehessel/agentskills#v1.0.0
```

## What Happens During Installation

When you run `apm install`, APM performs these steps:

1. **Downloads** the package to `apm_modules/stehessel/agentskills/`
2. **Deploys** skills to agent-specific directories:
   - `.github/skills/` (GitHub Copilot)
   - `.claude/skills/` (Claude Code)
   - `.cursor/skills/` (Cursor)
   - `.opencode/skills/` (OpenCode)
   - `.codex/skills/` (OpenAI Codex)
3. **Creates** `apm.lock.yaml` to pin exact commits for team consistency
4. **Updates** your `apm.yml` with the new dependency

## Version Control

**Commit these files:**
- `apm.yml` (manifest)
- `apm.lock.yaml` (lockfile)
- `.github/`, `.claude/`, `.cursor/`, `.opencode/`, `.codex/` (deployed skills)

**Ignore these:**
- `apm_modules/` (rebuilt from lockfile)

Add to `.gitignore`:
```
apm_modules/
```

## Team Workflow

New team members get the same configuration automatically:

```bash
git clone <your-repo>
cd <your-repo>
apm install
```

APM reads `apm.lock.yaml` and deploys the exact same skill versions to all agent directories.

## Available Skills

| Skill | Description |
|-------|-------------|
| [beadflow](./beadflow/SKILL.md) | Autonomous task management using Beads issue tracker |
| [sculptor](./sculptor/SKILL.md) | Collaborative idea polishing through dialogue and annotation cycles |
| [reviewer](./reviewer/SKILL.md) | Comprehensive code review with tech-stack-specific checklists |
| [treeflow](./treeflow/SKILL.md) | Orchestrated parallel execution with background AI workers |
| [session-viewer](./session-viewer/SKILL.md) | Parse and display Claude Code session JSONL files |

## Updating Skills

**Update to latest version:**
```bash
apm update stehessel/agentskills
```

**Update to specific version:**
```bash
apm install stehessel/agentskills#v2.0.0
```

After updating, commit the changed `apm.lock.yaml` and deployed files.

## Removing Skills

**Remove all skills:**
```bash
apm uninstall stehessel/agentskills
```

**Remove a specific skill:**
```bash
apm uninstall stehessel/agentskills/beadflow
```

## Alternative: Manual Installation

If you prefer not to use APM, you can still install skills manually using Make:

```bash
git clone https://github.com/stehessel/agentskills ~/agentskills
cd ~/agentskills
make install-all-global
```

See the [README](./README.md) for full manual installation instructions.

## Learn More

- [APM Documentation](https://microsoft.github.io/apm/)
- [APM GitHub Repository](https://github.com/microsoft/apm)
- [agentskills.io Specification](https://agentskills.io/specification)
- [Skills Guide](https://microsoft.github.io/apm/guides/skills/)

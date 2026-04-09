# Agent Skills Collection

A curated collection of skills for AI coding agents (Claude Code, Cursor, OpenAI Codex, etc.) following the [agentskills.io specification](https://agentskills.io/specification). Skills define specialized workflows, processes, and capabilities that enhance how AI agents approach development tasks.

## Quick Start

### Using APM (Recommended)

[APM (Agent Package Manager)](https://microsoft.github.io/apm/) is the recommended way to install and manage skills across multiple AI coding tools.

1. Install APM:
   ```bash
   # macOS/Linux
   curl -sSL https://aka.ms/apm-unix | sh

   # Windows (PowerShell)
   irm https://aka.ms/apm-windows | iex
   ```

2. Install skills to your project:
   ```bash
   # Install all skills from this collection
   apm install stehessel/agentskills

   # Or install individual skills
   apm install stehessel/agentskills/beadflow
   apm install stehessel/agentskills/reviewer
   apm install stehessel/agentskills/sculptor
   apm install stehessel/agentskills/treeflow
   apm install stehessel/agentskills/session-viewer
   ```

3. Skills are automatically deployed to `.github/`, `.claude/`, `.cursor/`, `.opencode/`, and `.codex/` directories.

4. Commit `apm.yml` and `apm.lock.yaml` to version control (ignore `apm_modules/`).

### Manual Installation (Claude Code)

If you prefer manual installation without APM:

1. Clone this repository:
   ```bash
   git clone https://github.com/stehessel/agentskills ~/agentskills
   cd ~/agentskills
   ```

2. Install skills using Make:
   ```bash
   # Install all skills globally
   make install-all-global

   # Install a single skill to a project
   make install SKILL=reviewer TARGET=~/myproject

   # Copy instead of symlink (standalone, won't track updates)
   make copy SKILL=reviewer TARGET=~/myproject
   ```

3. Skills are discovered from `~/.claude/skills/` or `<project>/.claude/skills/` on startup.

4. Run `make help` to see all available targets and skills.

### For Other Agents

Skills following the agentskills.io specification can be used with any compatible AI coding agent. Refer to your agent's documentation for how to configure custom skill directories.

## Available Skills

### Workflow Skills

| Name | Description | When to Use |
|------|-------------|-------------|
| [beadflow](./beadflow/SKILL.md) | Autonomous task management using Beads issue tracker | Multi-step projects, breaking down PRDs, managing complex implementations with dependency tracking |
| [sculptor](./sculptor/SKILL.md) | Collaborative idea polishing through dialogue and annotation cycles | Exploring vague ideas, refining concepts, creating PRDs, specs, or implementation plans |
| [reviewer](./reviewer/SKILL.md) | Comprehensive code review with tech-stack-specific checklists and structured report | Codebase audits, spec compliance checks, production readiness assessment, code quality reviews |
| [treeflow](./treeflow/SKILL.md) | Orchestrated parallel execution with background AI workers | Large projects, parallel implementation, distributing work across multiple agents |

### Utility Skills

| Name | Description | When to Use |
|------|-------------|-------------|
| [session-viewer](./session-viewer/SKILL.md) | Parse and display Claude Code session JSONL files in multiple formats | Viewing, inspecting, analyzing, or debugging Claude Code sessions |

## How Skills Work

Skills are automatically discovered and activated by AI agents when relevant to the current task:

1. **Discovery**: Agents scan skill descriptions at startup
2. **Activation**: When you mention a skill by name or describe a matching task, the agent loads the full skill instructions
3. **Execution**: The agent follows the skill's defined workflow and best practices
4. **Progressive Loading**: Skills use structured references to load additional documentation only when needed

You can also manually trigger a skill in Claude Code using:
```
/skill-name
```

Or by explicitly mentioning it in conversation:
```
"Use the beadflow skill to plan this feature"
```

## Adding New Skills

Want to contribute a skill? Here's how:

1. **Create a skill directory** with a descriptive name (lowercase, hyphens only):
   ```
   your-skill-name/
   └── SKILL.md
   ```

2. **Write SKILL.md** following the [agentskills.io specification](https://agentskills.io/specification):
   ```yaml
   ---
   name: your-skill-name
   description: What this skill does and when to use it
   ---

   # Your Skill Instructions

   [Step-by-step instructions, examples, guidelines...]
   ```

3. **Test your skill** with an AI agent to verify it works as intended

4. **Submit a pull request** with:
   - Your skill directory
   - Updated README.md (add to the appropriate table above)
   - Updated AGENTS.md (add to the catalog)

### Skill Best Practices

- **Clear activation triggers**: Make it obvious when your skill should be used
- **Focused scope**: One skill, one responsibility
- **Progressive disclosure**: Put core instructions in SKILL.md, detailed references in separate files
- **Examples**: Show concrete usage examples
- **Validation**: Test with real AI agents before submitting

See the [agentskills.io specification](https://agentskills.io/specification) for complete formatting requirements.

## Repository Structure

This repository is structured as an APM monorepo collection, where each skill is a subdirectory that can be installed individually or as a complete set. See [APM.md](./APM.md) for detailed APM installation and usage instructions.

```
.
├── README.md              # This file (for humans)
├── AGENTS.md              # Agent guidance (for AI)
├── apm.yml                # APM package manifest
├── Makefile               # Manual install/uninstall/copy (alternative to APM)
├── ref/                   # Skill authoring reference docs
├── beadflow/              # Task management skill
│   └── SKILL.md
├── sculptor/              # Idea polishing skill
│   └── SKILL.md
├── treeflow/              # Orchestrated parallel execution skill
│   ├── SKILL.md
│   ├── tf.py              # Python state manager (deterministic coordination)
│   ├── COMMANDS.md
│   ├── CONTEXT-MANAGEMENT.md
│   ├── PLAN-FORMAT.md
│   ├── SCULPTOR-IMPORT.md
│   ├── WORKER-PROMPT.md
│   ├── WORKER-CONTEXT-TEMPLATE.md
│   └── WORKER-REGISTRY-TEMPLATE.md
├── reviewer/              # Code review skill
│   ├── SKILL.md
│   ├── CHECKLIST-CATALOG.md
│   └── REPORT-TEMPLATE.md
├── session-viewer/        # Session viewer skill
│   ├── SKILL.md
│   ├── SCHEMA.md
│   └── claude_session.py
└── your-skill/            # Your skills here
    ├── SKILL.md
    └── ...
```

## Contributing

Contributions are welcome! Please:

1. Follow the [agentskills.io specification](https://agentskills.io/specification)
2. Test your skill with at least one AI agent
3. Update both README.md and AGENTS.md
4. Keep skills focused and well-documented
5. Include clear activation triggers in the description
6. Ensure skill names follow APM conventions (lowercase, hyphens only, 1-64 chars)

### Publishing Skills

Skills in this repository can be installed via APM:

```bash
# Install a specific skill
apm install stehessel/agentskills/your-skill-name

# Install all skills
apm install stehessel/agentskills
```

Skills are automatically deployed to the appropriate directories for Claude Code, GitHub Copilot, Cursor, OpenCode, and other compatible agents.

## License

See individual skill directories for their specific licenses. Skills without explicit licenses default to the repository license.

---

**For AI Agents**: See [AGENTS.md](./AGENTS.md) for the structured skill catalog and usage guidelines.

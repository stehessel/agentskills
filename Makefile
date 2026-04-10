# ==============================================================================
#  agentskills — Claude Code skill collection
# ==============================================================================

.PHONY: help install install-global uninstall uninstall-global \
        install-all install-all-global uninstall-all uninstall-all-global \
        copy copy-global copy-all copy-all-global list

# ── Config ───────────────────────────────────────────────────────────────────

# All skill directories (auto-detected from SKILL.md presence in .apm/skills/)
SKILLS := $(patsubst .apm/skills/%/SKILL.md,%,$(wildcard .apm/skills/*/SKILL.md))

# ── Colors ───────────────────────────────────────────────────────────────────

RESET  := \033[0m
BOLD   := \033[1m
DIM    := \033[2m
GREEN  := \033[32m
RED    := \033[31m
YELLOW := \033[33m
CYAN   := \033[36m

.DEFAULT_GOAL := help

# ── Help ─────────────────────────────────────────────────────────────────────

help: ## Show this help
	@printf "\n  $(BOLD)agentskills$(RESET) — Claude Code skill collection\n\n"
	@printf "  $(CYAN)Usage:$(RESET)\n"
	@printf "    make install        SKILL=<name> TARGET=<project-dir>  $(DIM)# project-level$(RESET)\n"
	@printf "    make install-global SKILL=<name>                       $(DIM)# ~/.claude/skills/$(RESET)\n"
	@printf "    make install-all    TARGET=<project-dir>               $(DIM)# all skills, project-level$(RESET)\n"
	@printf "    make install-all-global                                $(DIM)# all skills, global$(RESET)\n"
	@printf "    make copy           SKILL=<name> TARGET=<project-dir>  $(DIM)# copy to project$(RESET)\n"
	@printf "    make copy-global    SKILL=<name>                       $(DIM)# copy to ~/.claude/skills/$(RESET)\n"
	@printf "\n"
	@printf "  $(CYAN)Targets:$(RESET)\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ \
	  { printf "    $(GREEN)%-22s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n"
	@printf "  $(CYAN)Available skills:$(RESET)\n"
	@for s in $(SKILLS); do printf "    $(DIM)•$(RESET) $$s\n"; done
	@printf "\n"

# ── List ─────────────────────────────────────────────────────────────────────

list: ## List available skills
	@for s in $(SKILLS); do printf "  $(GREEN)•$(RESET) $$s\n"; done

# ── Install (single skill) ───────────────────────────────────────────────────

install: ## Install a skill to a project (SKILL=name TARGET=dir)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make install SKILL=<name> TARGET=<dir>\n" && exit 1
endif
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make install SKILL=<name> TARGET=<dir>\n" && exit 1
endif
	@if [ ! -d "$(CURDIR)/.apm/skills/$(SKILL)" ] || [ ! -f "$(CURDIR)/.apm/skills/$(SKILL)/SKILL.md" ]; then \
	  printf "  $(RED)✗$(RESET) Skill '$(SKILL)' not found\n" && exit 1; \
	fi
	@mkdir -p "$(TARGET)/.claude/skills"
	@if [ -L "$(TARGET)/.claude/skills/$(SKILL)" ]; then rm "$(TARGET)/.claude/skills/$(SKILL)"; fi
	@ln -s "$(CURDIR)/.apm/skills/$(SKILL)" "$(TARGET)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) $(BOLD)$(SKILL)$(RESET) → $(DIM)$(TARGET)/.claude/skills/$(SKILL)$(RESET)\n"

install-global: ## Install a skill globally (SKILL=name)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make install-global SKILL=<name>\n" && exit 1
endif
	@if [ ! -d "$(CURDIR)/.apm/skills/$(SKILL)" ] || [ ! -f "$(CURDIR)/.apm/skills/$(SKILL)/SKILL.md" ]; then \
	  printf "  $(RED)✗$(RESET) Skill '$(SKILL)' not found\n" && exit 1; \
	fi
	@mkdir -p "$(HOME)/.claude/skills"
	@if [ -L "$(HOME)/.claude/skills/$(SKILL)" ]; then rm "$(HOME)/.claude/skills/$(SKILL)"; fi
	@ln -s "$(CURDIR)/.apm/skills/$(SKILL)" "$(HOME)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) $(BOLD)$(SKILL)$(RESET) → $(DIM)~/.claude/skills/$(SKILL)$(RESET)\n"

# ── Uninstall (single skill) ─────────────────────────────────────────────────

uninstall: ## Remove a skill from a project (SKILL=name TARGET=dir)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make uninstall SKILL=<name> TARGET=<dir>\n" && exit 1
endif
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make uninstall SKILL=<name> TARGET=<dir>\n" && exit 1
endif
	@rm -f "$(TARGET)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) Removed $(BOLD)$(SKILL)$(RESET) from $(DIM)$(TARGET)/.claude/skills/$(RESET)\n"

uninstall-global: ## Remove a skill globally (SKILL=name)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make uninstall-global SKILL=<name>\n" && exit 1
endif
	@rm -f "$(HOME)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) Removed $(BOLD)$(SKILL)$(RESET) from $(DIM)~/.claude/skills/$(RESET)\n"

# ── Install/Uninstall all ────────────────────────────────────────────────────

install-all: ## Install all skills to a project (TARGET=dir)
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make install-all TARGET=<dir>\n" && exit 1
endif
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory install SKILL=$$s TARGET=$(TARGET); \
	done

install-all-global: ## Install all skills globally
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory install-global SKILL=$$s; \
	done

uninstall-all: ## Remove all skills from a project (TARGET=dir)
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make uninstall-all TARGET=<dir>\n" && exit 1
endif
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory uninstall SKILL=$$s TARGET=$(TARGET); \
	done

uninstall-all-global: ## Remove all skills globally
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory uninstall-global SKILL=$$s; \
	done

# ── Copy (single skill) ─────────────────────────────────────────────────────

copy: ## Copy a skill to a project (SKILL=name TARGET=dir)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make copy SKILL=<name> TARGET=<dir>\n" && exit 1
endif
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make copy SKILL=<name> TARGET=<dir>\n" && exit 1
endif
	@if [ ! -d "$(CURDIR)/.apm/skills/$(SKILL)" ] || [ ! -f "$(CURDIR)/.apm/skills/$(SKILL)/SKILL.md" ]; then \
	  printf "  $(RED)✗$(RESET) Skill '$(SKILL)' not found\n" && exit 1; \
	fi
	@mkdir -p "$(TARGET)/.claude/skills"
	@rm -rf "$(TARGET)/.claude/skills/$(SKILL)"
	@cp -R "$(CURDIR)/.apm/skills/$(SKILL)" "$(TARGET)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) $(BOLD)$(SKILL)$(RESET) copied → $(DIM)$(TARGET)/.claude/skills/$(SKILL)$(RESET)\n"

copy-global: ## Copy a skill globally (SKILL=name)
ifndef SKILL
	@printf "  $(RED)✗$(RESET) SKILL is required. Usage: make copy-global SKILL=<name>\n" && exit 1
endif
	@if [ ! -d "$(CURDIR)/.apm/skills/$(SKILL)" ] || [ ! -f "$(CURDIR)/.apm/skills/$(SKILL)/SKILL.md" ]; then \
	  printf "  $(RED)✗$(RESET) Skill '$(SKILL)' not found\n" && exit 1; \
	fi
	@mkdir -p "$(HOME)/.claude/skills"
	@rm -rf "$(HOME)/.claude/skills/$(SKILL)"
	@cp -R "$(CURDIR)/.apm/skills/$(SKILL)" "$(HOME)/.claude/skills/$(SKILL)"
	@printf "  $(GREEN)✓$(RESET) $(BOLD)$(SKILL)$(RESET) copied → $(DIM)~/.claude/skills/$(SKILL)$(RESET)\n"

# ── Copy all ─────────────────────────────────────────────────────────────────

copy-all: ## Copy all skills to a project (TARGET=dir)
ifndef TARGET
	@printf "  $(RED)✗$(RESET) TARGET is required. Usage: make copy-all TARGET=<dir>\n" && exit 1
endif
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory copy SKILL=$$s TARGET=$(TARGET); \
	done

copy-all-global: ## Copy all skills globally
	@for s in $(SKILLS); do \
	  $(MAKE) --no-print-directory copy-global SKILL=$$s; \
	done

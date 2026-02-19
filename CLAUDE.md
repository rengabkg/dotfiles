# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal macOS/Linux dotfiles repository managed with [chezmoi](https://www.chezmoi.io/). It provisions a development environment including shell config (zsh + oh-my-zsh + Powerlevel10k), editor config (vim/neovim), terminal config (Kitty), Homebrew packages, and macOS system defaults and more. The primary goal of maintaining dotfiles like in this repository is to avoid setting up everything from scratch again during device upgrades (buying a new laptop or desktop).

## Key Commands

```bash
# Apply all dotfiles and run scripts
chezmoi apply

# Preview what would change
chezmoi diff

# Add a new dotfile to be managed
chezmoi add ~/.some_config

# Edit a managed file (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Jump to the chezmoi source directory
chezmoi cd

# Test a template expression
chezmoi execute-template '{{ .chezmoi.os }}'

# Re-run ALL run_onchange scripts (clears all script state)
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## Architecture

### Chezmoi Naming Conventions

Files use chezmoi's naming scheme — understanding these prefixes is essential:
- `dot_` → `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `exact_` → directory contents are exactly managed (extra files removed)
- `run_onchange_before_` → runs before file sync, re-runs when template content changes
- `run_onchange_after_` → runs after file sync, re-runs when template content changes
- `.tmpl` suffix → chezmoi Go template, rendered before use

### External Dependencies (.chezmoiexternal.toml)

Oh-my-zsh, Powerlevel10k, and zsh plugins are pulled as external archives — not stored in this repo. They refresh weekly via `refreshPeriod`.

### Script Execution Order

All run scripts are macOS-conditional (`{{ if eq .chezmoi.os "darwin" }}`):

1. `run_onchange_before_00-install-packages-macos.sh.tmpl` — `brew bundle` from two Brewfiles
2. `run_onchange_after_00-setup-macos-defaults.sh.tmpl` — applies macOS `defaults` + Stats.app plist
3. `run_onchange_after_01-setup-pipx-binaries.sh.tmpl` — installs Python tools via pipx

Scripts embed SHA256 checksums of their data files as template comments. When a Brewfile or plist changes, the checksum changes, which triggers chezmoi to re-run the script.

### Package Management Split

- `macos/brew/common.brewfile` — everyday apps (browsers, media, utilities, Mac App Store apps via `mas`)
- `macos/brew/dev.brewfile` — development tools (Docker, Go, Node, Python, VS Code, gcloud, tfenv, buf)
- `macos/defaults/stats.plist` — Stats menu bar app preferences

### Ignored by Chezmoi

The `macos/` directory is in `.chezmoiignore` — its contents are only consumed by run scripts, not synced to `$HOME`.

### Gotchas

- `CLAUDE.md` must be listed in `.chezmoiignore` — otherwise `chezmoi apply` will copy it to `$HOME`.
- Adding a new run script? Use `chezmoi execute-template` to verify template logic before applying.
- The checksum trick only works with `run_onchange_` scripts. A plain `run_` script runs on every `chezmoi apply`.

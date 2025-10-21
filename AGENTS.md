# Dotfiles Repository - Agent Guidelines

## Architecture
This is a **chezmoi-managed dotfiles repository** for cross-platform configuration (macOS/Linux/Windows). The repository uses:
- **chezmoi** for dotfile templating and state management
- **Brewfile** (macOS) and **Scoopfile.json** (Windows) for package management
- **Template files** (`.tmpl` extension) with Go templating for cross-platform configs
- **Platform-specific scripts** in `.chezmoiscripts/{darwin,linux,windows}/` for OS-specific setup

## Key Commands
- **Apply changes**: `chezmoi apply <target_path>...` for specific files (non-interactive). Can accept multiple paths. NEVER run `chezmoi apply` without arguments (interactive). Always specify target file paths when applying.
- **Preview changes**: `chezmoi diff` (see what would change before applying)
- **Test template**: `chezmoi execute-template <file>` or `chezmoi cat <target_path>`
- **Add new file**: `chezmoi add ~/.config/newfile` (imports file into source directory)
- **Verify status**: `chezmoi status` (shows modified/added/deleted files)
- **Install packages**: NEVER run package managers directly. Remind user to run `brew bundle --global` or `scoop import Scoopfile.json`

## File Structure & Conventions
- `dot_*` → `.filename` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_*` → mode 0600 files (e.g., `private_dot_hgrc.tmpl` → `~/.hgrc`)
- `.tmpl` suffix → Go templates processed with chezmoi data
- `run_once_*` → Scripts executed once
- `run_onchange_*` → Scripts re-executed when content changes
- Platform-specific configs use `{{ if eq .chezmoi.os "darwin" }}` conditionals

## Code Style & Best Practices
- Shell scripts: Follow existing patterns in `.chezmoiscripts/`, use `set -e`, prefer `command -v` for checks
- Zsh config: Use `(( $+commands[tool] ))` for command checks, prefer lazy-loading with `zinit ice lucid wait`
- Templates: Keep platform logic minimal, prefer `.chezmoiignore` for excluding files per-OS
- Naming: Use lowercase with hyphens for files/dirs; follow existing alias patterns (e.g., `l`, `ll`, `lg`)

## Neovim Configuration (`dot_config/nvim/`)
- **Plugin Manager**: Uses `lazy.nvim` with lazy loading patterns (`event`, `cmd`, `keys`, `ft`)
- **Structure**: `init.lua` (entry point) → `lua/options.lua` (settings) → `lua/plugins/` (plugin specs) → `lua/config/` (complex configs)
- **Formatting**: Use `stylua` with config in `.stylua.toml` (2-space indent, single quotes, no call parens)
- **LSP/Completion**: Uses `blink.cmp` with LuaSnip, multiple AI providers (Copilot, Minuet with Codestral/Gemini)
- **Key Plugins**: Telescope (fuzzy finder), Treesitter, which-key, neo-tree, gitsigns, trouble.nvim, flash.nvim
- **Conventions**: Leader = `<space>`, use descriptive key groups (`[C]ode`, `[S]earch`, etc.), lazy-load with events
- **Testing**: Use `:checkhealth` to verify plugin health, `:Lazy` to check plugin status/updates


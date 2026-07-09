# Dotfiles Repo Notes

## Chezmoi Workflow
- This is a chezmoi source repo; root `README.md` and `AGENTS.md` are ignored by `.chezmoiignore` and are not applied to `$HOME`.
- Use chezmoi target paths when validating rendered output: `chezmoi cat ~/.zshrc`, `chezmoi cat ~/.gitconfig`, or `chezmoi diff ~/.config/nvim/init.lua`.
- Apply only explicit targets with `chezmoi apply <target_path>...`; do not run bare `chezmoi apply` from an agent session.
- Use `chezmoi status` to inspect managed target drift. `chezmoi diff AGENTS.md` is expected to fail because `AGENTS.md` is not managed.
- Add files from the live home directory with `chezmoi add <target_path>`; edit existing managed files in this source tree using chezmoi naming (`dot_*`, `private_*`, `symlink_*`, `create_*`).

## Platform And Package Gotchas
- `.chezmoiignore` excludes non-current OS script directories via `.chezmoiscripts/*/**` plus `!.chezmoiscripts/{{ .chezmoi.os }}/**`; put OS-specific setup under the matching OS directory.
- macOS package state lives in `dot_Brewfile` and is wired to `.chezmoiscripts/darwin/run_onchange_brew-bundle.sh.tmpl`; Windows package state lives in `Scoopfile.json` and `.chezmoiscripts/windows/run_once_import-scoopfile.ps1`.
- Do not run Homebrew or Scoop package installs directly unless the user asks; update the managed package files/scripts instead.
- `.chezmoiexternal.toml` downloads zinit, TPM, vim-plug, LazyVim starter, themes, and Linux fonts; keep external paths compatible with `.chezmoiignore`.
- Templates already use `lookPath`, `stat`, `.chezmoi.os`, and `.chezmoi.homeDir`; prefer those over hard-coded host checks. `.chezmoidata.toml.tmpl` sets `msys2Path` for Windows.

## Shell Config
- `dot_zshrc` assumes zinit from `.chezmoiexternal.toml` and uses `(( $+commands[tool] ))` guards for optional tools.
- Keep Powerlevel10k instant prompt setup near the top of `dot_zshrc`; avoid adding code above it unless it must prompt before instant prompt loads.
- Follow the existing alias style (`l`, `ll`, `lg`, `j`, `jg`) and lazy zinit style (`zinit ice lucid wait` where plugins can load later).

## Neovim Config
- Neovim entrypoint is `dot_config/nvim/init.lua`; it bootstraps `lazy.nvim` and imports plugin specs from `lua/kickstart/plugins` and `lua/plugins`.
- Lua formatting is Stylua with `dot_config/nvim/.stylua.toml`: 2 spaces, Unix endings, `AutoPreferSingle`, `call_parentheses = "None"`, column width 160.
- Completion/LSP uses `blink.cmp`, `mason.nvim`, `mason-lspconfig`, and `conform.nvim`; Lua/sh formatting is managed by conform with `stylua` and `shfmt`.
- The repo includes `xvzc/chezmoi.nvim`; files under `~/.local/share/chezmoi/*` are watched by the plugin when opened in Neovim.

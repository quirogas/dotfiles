# Quirogas' Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [mise](https://mise.jdx.dev/). Optimized for **macOS** and **gLinux / Debian / Ubuntu**.

## Quick Start / Bootstrap

To bootstrap a new machine (macOS or gLinux):

```bash
# 1. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply quirogas
```

### What this automatically sets up:
1. **Oh-My-Zsh & Plugins**: Installs Oh-My-Zsh and clones `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-vi-mode` declaratively into `~/.oh-my-zsh/custom/`.
2. **Package Provisioning**:
   - **macOS**: Installs Homebrew (if not present) and bundles formula & casks via `~/.Brewfile`.
   - **gLinux / Linux**: Installs base essential packages via `apt-get`.
3. **Mise Tools & Runtimes**: Installs `mise` and provisions pinned CLI tools and runtimes:
   - `neovim`, `ripgrep`, `fd`, `fzf`
   - `node`, `python`, `go`, `rust`, `cargo`, `lua`, `ruff`, `stylua`
4. **MesloLGS Nerd Fonts**: Automatically downloads MesloLGS NF fonts to `~/Library/Fonts` (macOS) or `~/.local/share/fonts` (Linux).
5. **Neovim Configuration**: Cloned as a standalone git repository to `~/.config/nvim` from `git@github.com:quirogas/nvim.git`.

---

## Daily Workflow & Maintenance

### Dotfiles
```bash
# Edit dotfiles
chezmoi edit ~/.zshrc

# Check pending changes
chezmoi diff

# Apply changes
chezmoi apply

# Commit and push changes
chezmoi cd
git commit -am "Update shell aliases"
git push
```

### Neovim (`~/.config/nvim`)
Neovim is managed as its own dedicated git repository:
```bash
cd ~/.config/nvim
git status
git commit -am "Update LSP configuration"
git push
```

### Mise Tools (`~/.config/mise/config.toml`)
```bash
# Add a new global tool
mise use -g eza@latest

# Upgrade all tools
mise upgrade
```

# Dotfiles Modernization Architecture

## Context
The previous dotfiles setup relied on a macOS-heavy Ansible configuration, making cross-platform maintenance (e.g., across macOS and gLinux) cumbersome, monolithic, and difficult to bootstrap cleanly.

## Decision
Migrate dotfiles to a modular, cross-platform architecture utilizing:
* **Chezmoi**: Centralized cross-platform dotfile management and templating.
* **Mise**: Universal CLI tool and runtime version management (`neovim`, `node`, `python`, `go`, `ripgrep`, `fd`).
* **Native Package Managers**: Platform-specific OS package management via Homebrew (`Brewfile`) on macOS and `apt` on gLinux.
* **Chezmoi Externals (`.chezmoiexternal.toml`)**: Declarative management and tracking of external Zsh plugins and themes.
* **Standalone Neovim Repository**: Decoupled Neovim configuration maintained independently in [`github.com/quirogas/nvim`](https://github.com/quirogas/nvim).

## Consequences
* **Cross-Platform Compatibility**: Consistent environment and toolchain parity across macOS and gLinux workstations.
* **Separation of Concerns**: Distinct boundaries between system packages (Homebrew/apt), CLI runtime versions (Mise), shell plugins (`.chezmoiexternal.toml`), and editor configurations.
* **Independent Editor Lifecycle**: Neovim configurations can be developed, tested, and synced independently of core dotfiles.
* **Lightweight Bootstrapping**: Removes Ansible runtime dependencies in favor of native, standalone binaries.

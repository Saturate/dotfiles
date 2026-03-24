# dotfiles

Personal dotfiles for macOS, Linux, and Windows.

## Structure

```
common/          Shared configs (git, starship, ghostty, editorconfig)
macos/           macOS setup (Brewfile, zsh, AeroSpace, install script)
linux/           Linux extras (see below)
windows/         Windows setup (WIP)
```

## macOS

One-command setup:

```bash
./macos/install.sh
```

Installs Homebrew packages, shell config, AeroSpace (tiling WM), Ghostty, Starship prompt, and modern CLI tools.

## Linux

**Primary setup: [Omarchy](https://github.com/basecamp/omarchy)** — handles Hyprland, Ghostty, Starship, bash, and system config out of the box.

The `linux/` directory is for:
- Non-Omarchy installs (servers, minimal VMs, WSL)
- Custom overrides on top of Omarchy

## Windows

WIP — needs rewrite from legacy BoxStarter to WinGet + PowerShell.

## Shared tools

These configs live in `common/` and work across all OSes:

| Tool | What | Config |
|------|------|--------|
| [Starship](https://starship.rs) | Cross-platform prompt | `common/starship.toml` |
| [Ghostty](https://ghostty.org) | Terminal | `common/ghostty/config` |
| [delta](https://github.com/dandyleone/delta) | Git diff pager | `common/.gitconfig` |
| Git | 1Password SSH signing, rebase-on-pull | `common/.gitconfig` |

## Git signing

Commits are signed via 1Password SSH. The shared `.gitconfig` enables signing — 1Password sets the `gpg.ssh.program` path per OS automatically when you enable it in the app.

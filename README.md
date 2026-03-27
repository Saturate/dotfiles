# dotfiles

Personal dotfiles for macOS, Linux, and Windows.

## Structure

```
common/          Shared configs (git, starship, ghostty, editorconfig, neovim)
macos/           macOS setup (Brewfile, zsh, AeroSpace, install script)
linux/           Linux extras (see below)
windows/         Windows setup (WinGet, PowerShell profile, install script)
```

## macOS

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Saturate/dotfiles/master/macos/install.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/Saturate/dotfiles.git ~/code/github/dotfiles
cd ~/code/github/dotfiles && ./macos/install.sh
```

Installs Homebrew packages, shell config, AeroSpace (tiling WM), Ghostty, Starship prompt, and modern CLI tools.

## Linux

**Primary setup: [Omarchy](https://github.com/basecamp/omarchy)** for full desktop (Hyprland, Ghostty, Starship, bash).

The `linux/` directory is for:
- Non-Omarchy installs (servers, minimal VMs, WSL)
- Custom overrides on top of Omarchy

## Windows

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://raw.githubusercontent.com/Saturate/dotfiles/master/windows/install.ps1 | iex
```

Or clone and run locally:

```powershell
git clone https://github.com/Saturate/dotfiles.git $env:USERPROFILE\code\github\dotfiles
& "$env:USERPROFILE\code\github\dotfiles\windows\install.ps1"
```

Installs apps via WinGet, sets up PowerShell profile with Starship, modern CLI aliases (eza, bat, fd, rg, zoxide), and deploys shared configs.

## Claude Code

Claude Code config (CLAUDE.md, settings, skills) lives in a [separate repo](https://github.com/Saturate/claude) and is cloned + installed automatically during setup.

## Shared tools

These configs live in `common/` and work across all OSes:

| Tool | What | Config |
|------|------|--------|
| [Starship](https://starship.rs) | Cross-platform prompt | `common/starship.toml` |
| [Ghostty](https://ghostty.org) | Terminal | `common/ghostty/config` |
| [LazyVim](https://www.lazyvim.org) | Neovim IDE | `common/nvim/` |
| [delta](https://github.com/dandavison/delta) | Git diff pager | `common/.gitconfig` |
| Git | 1Password SSH signing, rebase-on-pull | `common/.gitconfig` |

## Git signing

Commits are signed via 1Password SSH. The shared `.gitconfig` enables signing. 1Password sets the `gpg.ssh.program` path per OS automatically when you enable it in the app.

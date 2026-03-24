# Linux

## With Omarchy (primary)

Install [Omarchy](https://github.com/basecamp/omarchy) first — it handles Hyprland, Ghostty, Starship, bash config, and system setup.

Then apply shared configs on top:

```bash
# Starship prompt (Omarchy has its own, use this to override)
cp ../common/starship.toml ~/.config/starship.toml

# Git config
cp ../common/.gitconfig ~/.gitconfig

# Ghostty (Omarchy has its own, use this to override)
cp ../common/ghostty/config ~/.config/ghostty/config
```

## Without Omarchy (servers, VMs, WSL)

Use `.bash_profile` for a minimal but usable shell on headless boxes:

```bash
cp .bash_profile ~/.bash_profile
source ~/.bash_profile
```

# macOS Dotfiles

Simple setup script for macOS development environment.

## Installation

**Remote:**

```bash
curl -fsSL https://raw.githubusercontent.com/Saturate/dotfiles/master/macos/install.sh | bash
```

**Local:**

```bash
git clone https://github.com/Saturate/dotfiles.git
cd dotfiles/macos
./install.sh
```

## What it does

1. Installs Xcode CLI tools
2. Installs Homebrew
3. Installs packages from Brewfile
4. Installs dotfiles to your home directory

Existing files are backed up with timestamps.

## Customization

The script will offer to let you edit the Brewfile before installation.

Edit dotfiles directly in your home directory (`~/.zshrc`, `~/.aliases`, etc).

## Next Steps

After installation:

```bash
source ~/.zshrc
p10k configure
```

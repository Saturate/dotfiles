#!/bin/bash
#
# Simple macOS Setup Script
# One-command installation: ./install.sh
#
# This script:
# - Installs Xcode CLI tools (if needed)
# - Installs Homebrew (if needed)
# - Optionally lets you edit the Brewfile
# - Installs all packages from macos/Brewfile
# - Links dotfiles to your home directory
# - Deploys shared configs (git, starship, ghostty)
#

set -e

# =============================================================================
# Colors and Logging
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# =============================================================================
# Script Directory Detection
# =============================================================================

GITHUB_REPO="https://github.com/Saturate/dotfiles.git"

# Detect if running from local repo or remote (curl pipe)
if [[ -n "${BASH_SOURCE[0]}" && -f "${BASH_SOURCE[0]}" ]]; then
    LOCAL_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    REPO_ROOT="$(cd "$LOCAL_REPO/.." && pwd)"
else
    # Running from curl - clone to temp dir and re-run from there
    header "Bootstrapping"

    TMPDIR="$(mktemp -d)"
    info "Cloning dotfiles to $TMPDIR..."
    git clone --depth 1 "$GITHUB_REPO" "$TMPDIR/dotfiles"

    info "Re-running install from cloned repo..."
    exec bash "$TMPDIR/dotfiles/macos/install.sh" "$@"
fi

BREWFILE="$LOCAL_REPO/Brewfile"

# =============================================================================
# Preflight Checks
# =============================================================================

check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This script is only for macOS"
        exit 1
    fi
}

# =============================================================================
# Xcode CLI Tools
# =============================================================================

install_xcode_cli() {
    header "Xcode Command Line Tools"

    if xcode-select -p &>/dev/null; then
        info "Xcode CLI tools already installed"
    else
        info "Installing Xcode CLI tools..."
        xcode-select --install

        echo ""
        warn "Please wait for the Xcode CLI tools installation to complete"
        echo "Press any key when the installation is complete..."
        read -n 1 -s </dev/tty
        echo ""
    fi
}

# =============================================================================
# Homebrew
# =============================================================================

install_homebrew() {
    header "Homebrew Package Manager"

    if command -v brew &>/dev/null; then
        info "Homebrew already installed"
        info "Updating Homebrew..."
        brew update
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for this session
        if [[ $(uname -m) == "arm64" ]]; then
            # Apple Silicon
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            # Intel
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        info "Homebrew installed successfully"
    fi
}

# =============================================================================
# Brewfile Editing
# =============================================================================

offer_brewfile_edit() {
    header "Brewfile Configuration"

    if [[ ! -f "$BREWFILE" ]]; then
        error "Brewfile not found at: $BREWFILE"
        exit 1
    fi

    echo "The Brewfile contains all packages and apps that will be installed."
    echo "Location: $BREWFILE"
    echo ""
    read -p "Would you like to review/edit the Brewfile before installing? (y/n) " -n 1 -r </dev/tty
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local editor="${EDITOR:-nano}"

        if ! command -v "$editor" &>/dev/null; then
            editor="nano"
        fi

        if ! command -v "$editor" &>/dev/null; then
            editor="vi"
        fi

        info "Opening Brewfile in $editor..."
        "$editor" "$BREWFILE"
        echo ""
        info "Continuing with installation..."
    else
        info "Proceeding with default Brewfile"
    fi
}

# =============================================================================
# Package Installation
# =============================================================================

install_packages() {
    header "Installing Packages"

    info "Running: brew bundle install --file=$BREWFILE"
    echo ""

    if brew bundle install --file="$BREWFILE"; then
        echo ""
        info "All packages installed successfully"
    else
        echo ""
        error "Some packages failed to install"
        warn "You can run 'brew bundle install --file=$BREWFILE' manually later"
    fi
}

# =============================================================================
# Dotfile Installation
# =============================================================================

install_dotfiles() {
    header "Installing Dotfiles"

    # Shell dotfiles -> home directory
    local shell_files=(".zshrc" ".zprofile" ".aliases" ".functions" ".aerospace.toml")

    for file in "${shell_files[@]}"; do
        local target="$HOME/$file"

        # Backup existing file
        if [[ -f "$target" ]]; then
            local backup="$target.backup.$(date +%Y%m%d%H%M%S)"
            info "Backing up existing $file to ${backup##*/}"
            mv "$target" "$backup"
        fi

        local source="$LOCAL_REPO/$file"
        if [[ ! -f "$source" ]]; then
            warn "Source file not found: $source (skipping)"
            continue
        fi
        info "Copying $file..."
        cp "$source" "$target"

        info "Installed $file"
    done
}

install_shared_configs() {
    header "Installing Shared Configs"

    local common_dir="$REPO_ROOT/common"

    # Starship prompt config
    local starship_dir="$HOME/.config"
    mkdir -p "$starship_dir"
    if [[ -f "$common_dir/starship.toml" ]]; then
        cp "$common_dir/starship.toml" "$starship_dir/starship.toml"
        info "Installed starship.toml"
    fi

    # Ghostty terminal config
    local ghostty_dir="$HOME/.config/ghostty"
    mkdir -p "$ghostty_dir"
    if [[ -f "$common_dir/ghostty/config" ]]; then
        cp "$common_dir/ghostty/config" "$ghostty_dir/config"
        info "Installed ghostty config"
    fi

    # Git config
    if [[ -f "$common_dir/.gitconfig" ]]; then
        cp "$common_dir/.gitconfig" "$HOME/.gitconfig"
        info "Installed .gitconfig"

        # Check if 1Password SSH signing is configured
        if ! git config --global gpg.ssh.program &>/dev/null; then
            warn "1Password SSH signing not configured"
            warn "Open 1Password → Settings → Developer → enable 'Sign Git commits with SSH'"
        fi
    fi

    # Neovim (LazyVim)
    if [[ ! -d "$HOME/.config/nvim" ]]; then
        info "Bootstrapping LazyVim..."
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
    else
        info "Neovim config already exists (skipping LazyVim bootstrap)"
    fi
    # Apply custom options on top of LazyVim
    if [[ -f "$common_dir/nvim/lua/config/options.lua" ]]; then
        cp "$common_dir/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
        info "Installed nvim custom options"
    fi

    # EditorConfig
    if [[ -f "$common_dir/.editorconfig" ]]; then
        cp "$common_dir/.editorconfig" "$HOME/.editorconfig"
        info "Installed .editorconfig"
    fi
}

# =============================================================================
# macOS Defaults
# =============================================================================

offer_macos_defaults() {
    local defaults_script="$LOCAL_REPO/macos-defaults.sh"
    if [[ ! -f "$defaults_script" ]]; then
        return
    fi

    header "macOS System Defaults"

    echo "This will apply opinionated macOS defaults (Dock, Finder, screenshots, etc.)"
    echo ""
    read -p "Apply macOS defaults? (y/n) " -n 1 -r </dev/tty
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$defaults_script"
        info "macOS defaults applied"
    else
        info "Skipped macOS defaults"
    fi
}

# =============================================================================
# Claude Code Config
# =============================================================================

install_agent_config() {
    header "Agent Configuration"

    local agents_repo="$HOME/code/github/agents"

    if [[ ! -d "$agents_repo" ]]; then
        info "Cloning agents config repo..."
        mkdir -p "$HOME/code/github"
        git clone https://github.com/Saturate/agents.git "$agents_repo"
    else
        info "Agents config repo already exists, pulling latest..."
        git -C "$agents_repo" pull
    fi

    if [[ -f "$agents_repo/install.sh" ]]; then
        info "Running agents config install..."
        bash "$agents_repo/install.sh" --force
    fi
}

# =============================================================================
# Completion Message
# =============================================================================

show_completion() {
    header "Setup Complete!"

    echo ""
    echo "Your Mac is now set up with all packages and dotfiles!"
    echo ""

    info "Next steps:"
    echo ""
    echo "  1. Restart your terminal (or run: source ~/.zshrc)"
    echo "  2. Sign into 1Password and enable SSH agent + git signing"
    echo "  3. Sign into your accounts (iCloud, Dropbox, etc.)"
    echo ""
    warn "Some changes may require a logout/restart to take effect"
    echo ""
}

# =============================================================================
# Main
# =============================================================================

main() {
    clear

    echo ""
    echo "=========================================="
    echo "     Simple macOS Setup Script"
    echo "=========================================="
    echo ""
    echo "This script will:"
    echo "  • Install Xcode CLI tools"
    echo "  • Install Homebrew"
    echo "  • Install packages from Brewfile"
    echo "  • Install dotfiles to your home directory"
    echo "  • Deploy shared configs (git, starship, ghostty)"
    echo ""

    read -p "Press Enter to continue or Ctrl+C to cancel..." </dev/tty
    echo ""

    check_macos
    install_xcode_cli
    install_homebrew
    offer_brewfile_edit
    install_packages
    install_dotfiles
    install_shared_configs
    offer_macos_defaults
    install_agent_config
    show_completion
}

main "$@"

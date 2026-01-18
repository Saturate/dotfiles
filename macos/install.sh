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

GITHUB_RAW="https://raw.githubusercontent.com/Saturate/dotfiles/master/macos"

# Detect if running from local repo or remote curl
if [[ -n "${BASH_SOURCE[0]}" && -f "${BASH_SOURCE[0]}" ]]; then
    # Local execution
    LOCAL_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    BREWFILE="$LOCAL_REPO/Brewfile"
    REMOTE_MODE=false
else
    # Running from curl
    BREWFILE="$HOME/Brewfile"
    REMOTE_MODE=true

    header "Downloading files"

    info "Fetching Brewfile..."
    curl -fsSL "$GITHUB_RAW/Brewfile" -o "$BREWFILE"

    info "Files downloaded"
fi

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

    local files=(".zshrc" ".zprofile" ".aliases" ".functions")

    for file in "${files[@]}"; do
        local target="$HOME/$file"

        # Backup existing file
        if [[ -f "$target" ]]; then
            local backup="$target.backup.$(date +%Y%m%d%H%M%S)"
            info "Backing up existing $file to ${backup##*/}"
            mv "$target" "$backup"
        fi

        if [[ "$REMOTE_MODE" == true ]]; then
            # Download directly to home directory
            info "Downloading $file..."
            curl -fsSL "$GITHUB_RAW/$file" -o "$target"
        else
            # Copy from local repo
            local source="$LOCAL_REPO/$file"
            if [[ ! -f "$source" ]]; then
                warn "Source file not found: $source (skipping)"
                continue
            fi
            info "Copying $file..."
            cp "$source" "$target"
        fi

        info "Installed $file"
    done
}

# =============================================================================
# Completion Message
# =============================================================================

show_completion() {
    header "Setup Complete!"

    echo ""
    echo "Your Mac is now set up with all packages and dotfiles!"
    echo ""

    if [[ "$REMOTE_MODE" == true ]]; then
        info "Brewfile saved to: ~/Brewfile"
        echo ""
    fi

    info "Next steps:"
    echo ""
    echo "  1. Restart your terminal (or run: source ~/.zshrc)"
    echo "  2. Configure Powerlevel10k prompt: p10k configure"
    echo "  3. Sign into your accounts (iCloud, 1Password, etc.)"
    echo "  4. Generate SSH keys: ssh-keygen -t ed25519 -C \"your_email@example.com\""
    echo "  5. Configure Git:"
    echo "     git config --global user.name \"Your Name\""
    echo "     git config --global user.email \"your_email@example.com\""
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
    echo ""

    read -p "Press Enter to continue or Ctrl+C to cancel..." </dev/tty
    echo ""

    check_macos
    install_xcode_cli
    install_homebrew
    offer_brewfile_edit
    install_packages
    install_dotfiles
    show_completion
}

main "$@"

#!/bin/bash
#
# AKJ's macOS Setup Script
# Interactive wizard for setting up a new Mac
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Helpers
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# =============================================================================
# Pre-flight Checks
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

        echo "Press any key when the installation is complete..."
        read -n 1 -s
    fi
}

# =============================================================================
# Homebrew
# =============================================================================

install_homebrew() {
    header "Homebrew"

    if command -v brew &>/dev/null; then
        info "Homebrew already installed, updating..."
        brew update
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for this session
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

# =============================================================================
# Package Installation
# =============================================================================

install_core_packages() {
    header "Core CLI Tools"
    info "Installing core packages..."

    brew install git gh
    brew install node nvm bun deno
    brew install go python@3.13 rust
    brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
    brew install coreutils p7zip onefetch htop jq tree wget

    info "Core packages installed!"
}

install_dev_apps() {
    header "Development Apps"
    info "Installing development apps..."

    brew install --cask visual-studio-code
    brew install --cask iterm2
    brew install --cask github

    read -p "Install Docker Desktop? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install --cask docker
    fi

    info "Development apps installed!"
}

install_browsers() {
    header "Browsers"
    info "Installing browsers..."

    brew install --cask firefox@developer-edition

    read -p "Install Google Chrome? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install --cask google-chrome
    fi

    info "Browsers installed!"
}

install_productivity_apps() {
    header "Productivity Apps"
    info "Installing productivity apps..."

    brew install --cask dropbox
    brew install --cask obsidian
    brew install --cask raycast
    brew install --cask 1password

    info "Productivity apps installed!"
}

install_entertainment_apps() {
    header "Entertainment Apps"
    info "Installing entertainment apps..."

    brew install --cask spotify
    brew install --cask notunes

    info "Entertainment apps installed!"
}

install_fonts() {
    header "Fonts"
    info "Installing fonts..."

    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
    brew install --cask font-jetbrains-mono
    brew install --cask font-meslo-lg-nerd-font

    info "Fonts installed!"
}

# =============================================================================
# Dotfiles Setup
# =============================================================================

setup_dotfiles() {
    header "Dotfiles"
    info "Setting up dotfiles..."

    # Backup existing configs
    for file in .zshrc .zprofile .aliases .functions; do
        if [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]]; then
            info "Backing up existing $file"
            mv "$HOME/$file" "$HOME/$file.backup.$(date +%Y%m%d%H%M%S)"
        fi
    done

    # Create symlinks
    ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$SCRIPT_DIR/.zprofile" "$HOME/.zprofile"
    ln -sf "$SCRIPT_DIR/.aliases" "$HOME/.aliases"
    ln -sf "$SCRIPT_DIR/.functions" "$HOME/.functions"

    # Link common editorconfig if it exists
    if [[ -f "$SCRIPT_DIR/../common/.editorconfig" ]]; then
        ln -sf "$SCRIPT_DIR/../common/.editorconfig" "$HOME/.editorconfig"
    fi

    info "Dotfiles linked!"
}

# =============================================================================
# macOS Defaults
# =============================================================================

configure_macos() {
    header "macOS Preferences"

    read -p "Configure macOS developer defaults? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source "$SCRIPT_DIR/macos-defaults.sh"
    else
        info "Skipping macOS defaults"
    fi
}

# =============================================================================
# VS Code Extensions
# =============================================================================

install_vscode_extensions() {
    header "VS Code Extensions"

    if ! command -v code &>/dev/null; then
        warn "VS Code CLI not found, skipping extensions"
        return
    fi

    read -p "Install recommended VS Code extensions? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Skipping VS Code extensions"
        return
    fi

    info "Installing VS Code extensions..."

    # Core
    code --install-extension esbenp.prettier-vscode
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension editorconfig.editorconfig

    # Git
    code --install-extension eamodio.gitlens

    # Themes & Icons
    code --install-extension vscode-icons-team.vscode-icons

    # AI
    code --install-extension github.copilot
    code --install-extension github.copilot-chat

    # Languages
    code --install-extension rust-lang.rust-analyzer
    code --install-extension denoland.vscode-deno
    code --install-extension ms-python.python
    code --install-extension golang.go

    info "VS Code extensions installed!"
}

# =============================================================================
# Interactive Wizard
# =============================================================================

show_menu() {
    echo ""
    echo "=========================================="
    echo "       AKJ's macOS Setup Wizard"
    echo "=========================================="
    echo ""
    echo "What would you like to install?"
    echo ""
    echo "  1) Core CLI tools only"
    echo "  2) Core + Development apps"
    echo "  3) Core + Productivity apps"
    echo "  4) Full setup (everything)"
    echo "  5) Custom selection"
    echo "  6) Exit"
    echo ""
}

run_wizard() {
    show_menu

    read -p "Enter your choice [1-6]: " choice

    case $choice in
        1)
            install_core_packages
            install_fonts
            ;;
        2)
            install_core_packages
            install_dev_apps
            install_browsers
            install_fonts
            ;;
        3)
            install_core_packages
            install_productivity_apps
            install_fonts
            ;;
        4)
            install_core_packages
            install_dev_apps
            install_browsers
            install_productivity_apps
            install_entertainment_apps
            install_fonts
            ;;
        5)
            install_core_packages

            read -p "Install development apps? (y/n) " -n 1 -r; echo
            [[ $REPLY =~ ^[Yy]$ ]] && install_dev_apps

            read -p "Install browsers? (y/n) " -n 1 -r; echo
            [[ $REPLY =~ ^[Yy]$ ]] && install_browsers

            read -p "Install productivity apps? (y/n) " -n 1 -r; echo
            [[ $REPLY =~ ^[Yy]$ ]] && install_productivity_apps

            read -p "Install entertainment apps? (y/n) " -n 1 -r; echo
            [[ $REPLY =~ ^[Yy]$ ]] && install_entertainment_apps

            install_fonts
            ;;
        6)
            info "Exiting..."
            exit 0
            ;;
        *)
            error "Invalid choice"
            run_wizard
            ;;
    esac
}

# =============================================================================
# Main
# =============================================================================

main() {
    check_macos

    echo ""
    echo "=========================================="
    echo "       AKJ's macOS Setup Script"
    echo "=========================================="
    echo ""

    install_xcode_cli
    install_homebrew

    run_wizard

    setup_dotfiles
    configure_macos
    install_vscode_extensions

    header "Setup Complete!"
    echo ""
    info "Next steps:"
    echo "  1. Restart your terminal (or run: source ~/.zshrc)"
    echo "  2. Run 'p10k configure' to set up Powerlevel10k prompt"
    echo "  3. Sign into your accounts (iCloud, 1Password, etc.)"
    echo "  4. Set up SSH keys: ssh-keygen -t ed25519"
    echo ""
    info "Some changes may require a logout/restart to take effect."
}

main "$@"

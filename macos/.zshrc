# .zshrc - AKJ's Zsh Configuration

# =============================================================================
# Path to dotfiles (optional, for local development)
# =============================================================================
if [[ -d "$HOME/code/github/dotfiles" ]]; then
    export DOTFILES="$HOME/code/github/dotfiles"
elif [[ -d "$HOME/dotfiles" ]]; then
    export DOTFILES="$HOME/dotfiles"
fi

# =============================================================================
# PATH Configuration
# =============================================================================
# Homebrew paths (Apple Silicon vs Intel)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Add custom paths
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

# =============================================================================
# Shell Options
# =============================================================================
setopt AUTO_CD              # cd by typing directory name
setopt CORRECT              # Command correction
setopt HIST_IGNORE_DUPS     # Ignore duplicate history entries
setopt HIST_IGNORE_SPACE    # Ignore commands starting with space
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands immediately
setopt EXTENDED_HISTORY     # Save timestamp

# =============================================================================
# History Configuration
# =============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR="code --wait"
export VISUAL="code --wait"
export PAGER="less"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# =============================================================================
# Completions
# =============================================================================
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu-style completion
zstyle ':completion:*' menu select

# =============================================================================
# Prompt (Starship - cross-platform, shared config)
# =============================================================================
eval "$(starship init zsh)"

# =============================================================================
# Plugin Loading (Homebrew-installed)
# =============================================================================
# Zsh syntax highlighting
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Zsh autosuggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# =============================================================================
# Tool Initializations
# =============================================================================
# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fzf keybindings and completion
source <(fzf --zsh)

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Bun
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# =============================================================================
# Source Additional Files
# =============================================================================
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# Local overrides (not in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

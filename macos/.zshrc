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

# .NET
export DOTNET_ROOT=/opt/homebrew/opt/dotnet@8/libexec
export PATH="/opt/homebrew/opt/dotnet@8/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Rancher Desktop (docker CLI)
export PATH="$HOME/.rd/bin:$PATH"

# =============================================================================
# 1Password SSH Agent
# =============================================================================
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

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

# Conda (lazy-loaded to avoid ~540ms startup penalty)
_lazy_conda_init() {
    unfunction conda activate deactivate 2>/dev/null
    local __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
conda() { _lazy_conda_init && conda "$@" }
activate() { _lazy_conda_init && conda activate "$@" }
deactivate() { _lazy_conda_init && conda deactivate "$@" }

# =============================================================================
# Source Additional Files
# =============================================================================
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# Local overrides (not in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

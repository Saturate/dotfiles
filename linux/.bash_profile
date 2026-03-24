# Minimal bash profile for servers, VMs, and WSL (non-Omarchy installs)
# For full desktop setup, use Omarchy: https://github.com/basecamp/omarchy

umask 022

# Prompt — Starship if available, fallback to a simple colored prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
else
    export PS1='\[\033[01;36m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;33m\]\w \[\033[01;35m\]\$ \[\033[00m\]'
fi

# History
export HISTFILESIZE=999999999
export HISTSIZE=999999999
export HISTCONTROL="ignoreboth"

# Editor
export EDITOR="vim"

# Colors
eval "$(dircolors 2>/dev/null)"

# Modern CLI tools if available, fallback to defaults
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -lh --icons'
    alias la='eza -lah --icons'
else
    alias ls='ls --color=auto -h'
    alias ll='ls -lh'
    alias la='ls -lAh'
fi

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# Git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# SSH
alias s='ssh -l root'

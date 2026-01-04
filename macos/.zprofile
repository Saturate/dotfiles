# .zprofile - Login shell settings
# This file is sourced by login shells before .zshrc

# Homebrew initialization (Apple Silicon vs Intel)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Set default umask
umask 022

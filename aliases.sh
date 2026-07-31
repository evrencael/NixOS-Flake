#!/usr/bin/env bash

# ========================================
# CONSTANTS
# ========================================

HOSTNAMES=("EvTop" "EvBook")

# ========================================
# AUTOCOMPLETION
# ========================================

_rebuild_completions() {
    local CUR="${COMP_WORDS[COMP_CWORD]}"
    local HOSTS="${HOSTNAMES[*]}"

    # Case-insensitive substring matching against hostnames
    local MATCHES=()
    local LOWER_CUR="${CUR,,}" # lowercase the input
    for HOST in ${HOSTS}; do
        local LOWER_HOST="${HOST,,}" # lowercase the hostname
        # Match if input is a case-insensitive substring of the hostname
        if [[ "$LOWER_HOST" == *"$LOWER_CUR"* ]]; then
            MATCHES+=("$HOST")
        fi
    done

    COMPREPLY=("${MATCHES[@]}")
}

complete -F _rebuild_completions rebuild rb
complete -W "-a 1d 7d 30d" tidy

# ========================================
# SYSTEM
# ========================================

alias cls="clear" # tehehe
alias cmat="cmatrix -s -b -u 6"
alias hl="hyprland-start"
alias la="ls -A --color=auto"
alias ll="ls -la --color=auto"
alias rs="echo 'Restarting . . .'; sudo shutdown -r now"
alias sd="echo 'Shutting down . . .'; sudo shutdown -h now"
alias firefox="firefox-safe"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ========================================
# CLOUDFLARE WARP
# ========================================

alias won="warp-cli connect"
alias woff="warp-cli disconnect"
alias wreg="warp-cli registration new"
alias wstat="warp-cli status"

# ========================================
# GIT
# ========================================

gacp() {
    if [ -z "$1" ]; then
        echo "Please provide a commit message."; return 1
    elif [ -z "$2" ]; then
        echo "Please provide a file to add."; return 1
    else
        git add "${@:2}" # allow multiple files
        git commit -m "$1"
        git push && git status
    fi
}

gc() {
    if [ -z "$1" ]; then
        echo "Please provide a commit message."
        return 1
    else
        git commit -m "$1"
        git push
    fi
}

alias ga="git add"
alias gd="git diff"
alias gpl="git pull"
alias gps="git push"
alias grs="git restore --staged ."
alias gs="git status"

# ========================================
# NIX
# ========================================

rebuild() {
    if [ -z "$1" ]; then
        local target_host="$HOSTNAME"
        echo "Rebuilding for host: $target_host"
    else
        local target_host="$1"
    fi

    if sudo nixos-rebuild switch --flake $HOME/flake#$target_host; then
        rm -f $HOME/.cache/tofi-drun # get tofi to recognise new apps
        cls
        echo "Rebuild successful :)"
    else
        echo "Rebuild failed :("
        return 1
    fi
}

tidy() {
    if [ -z "$1" ]; then
        nix-collect-garbage --delete-older-than 7d
    elif [ "$1" == "-a" ]; then
        nix-collect-garbage --delete-old
    else
        nix-collect-garbage --delete-older-than "$1"
    fi
}

alias up="sudo nix flake update"
alias rb="rebuild"

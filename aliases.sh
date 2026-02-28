#!/usr/bin/env bash

# ============================================
# CONSTANTS
# ============================================

SPOTIFY_APP="com.spotify.Client"
HOSTNAMES=("EvTop" "EvBook")

# ============================================
# AUTOCOMPLETION
# ============================================

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

# ============================================
# SYSTEM
# ============================================

alias cls="clear" # tehehe
alias cmat="cmatrix -s -b -u 6"
alias hl="hyprland"
alias la="ls -A --color=auto"
alias ll="ls -la --color=auto"
alias rs="echo 'Restarting . . .'; sudo shutdown -r now"
alias sd="echo 'Shutting down . . .'; sudo shutdown -h now"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ============================================
# CLOUDFLARE WARP
# ============================================

alias won="warp-cli connect"
alias woff="warp-cli disconnect"
alias wreg="warp-cli registration new"
alias wstat="warp-cli status"

# ============================================
# FLATPAK
# ============================================

flatpak_reinstall() {
    flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

    flatpak install flathub $SPOTIFY_APP -y
}

flatpak_uninstall_all() {
    flatpak uninstall --all -y
    flatpak remote-delete flathub
}

alias flatup="flatpak update -y"
alias flatre="flatpak_reinstall"
alias flatun="flatpak_uninstall_all"
alias spotify="flatpak run $SPOTIFY_APP"


# ============================================
# GIT
# ============================================

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

# ============================================
# NIX
# ============================================

rebuild() {
    if [ -z "$1" ]; then
        echo "Usage: rebuild [device name]"
        return 1
    else
        if sudo nixos-rebuild switch --flake $HOME/flake#$1; then
            rm -f $HOME/.cache/tofi-drun # get tofi to recognise new apps
            cls
            echo "Rebuild successful :)"
        else
            echo "Rebuild failed :("
            return 1
        fi
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
alias nosleep="pkill hypridle && echo 'Auto-sleep disabled'"
alias sleep-on="hypridle & echo 'Auto-sleep enabled'"

#!/usr/bin/env bash

# constants
SPOTIFY_APP="com.spotify.Client"


# simple aliases
alias cls="clear" # tehehe
alias hl="hyprland"
alias sd="echo 'Shutting down . . .'; sudo shutdown -h now"
alias rs="echo 'Restarting . . .'; sudo shutdown -r now"

alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'

alias cmat='cmatrix -s -b -u 6'

# Cloudflare WARP
alias won='warp-cli connect'
alias woff='warp-cli disconnect'
alias wstat='warp-cli status'


# nix aliases
rebuild() {
    if [ -z "$1" ]; then
        echo "Usage: rebuild [device name]"
        return 1
    else
        if sudo nixos-rebuild switch --flake $HOME/flake#$1; then
            rm -f $HOME/.cache/tofi-drun # get tofi to recognise new apps
            cls
            echo "Rebuild successful :)"
            return 0
        else
            echo "Rebuild failed :("
            return 1
        fi
    fi
}

tidy() {
    if [ -z "$1" ]; then
        nix-collect-garbage --delete-older-than 7d

    elif [ "$1" == "all" ]; then
        nix-collect-garbage --delete-old
    else
        nix-collect-garbage --delete-older-than "$1"
        return 1
    fi
}

alias up="sudo nix flake update && rebuild"
alias rb="rebuild"


# flatpak
flatpak_reinstall() {
    flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

    # packages, hopefully won't end up with more here
    flatpak install flathub $SPOTIFY_APP -y
}

alias flatup="flatpak update -y"
alias flatre="flatpak_reinstall"
alias spotify="flatpak run $SPOTIFY_APP"


# git
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
alias grs='git restore --staged .'

gc() {
    if [ -z "$1" ]; then
        echo "Please provide a commit message."
        return 1

    else
        git commit -m "$1"
        git push
    fi
}

gd() {
    if [ -z "$1" ]; then
        git diff

    else
        git diff "$@"

    fi
}

ga() {
    if [ -z "$1" ]; then
        git add .

    else
        git add "$@"

    fi
}

gacp() {
    if [ -z "$1" ]; then
        echo "Please provide a commit message."
        return 1

    elif [ -z "$2" ]; then
        echo "Please provide a file to add."
        return 1

    else
        git add "${@:2}" # allow multiple files
        git commit -m "$1"
        git push
        git status
    fi
}

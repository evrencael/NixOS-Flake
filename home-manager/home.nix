{ inputs, pkgs, config, ... }:
{
  imports = [
    ./modules
    inputs.catppuccin.homeModules.catppuccin
  ];

  home = {
    username = "evren";
    homeDirectory = "/home/evren";
  };

  home.packages = with pkgs; [
    btop
    tofi

    firefox-unwrapped
    cloudflare-warp
    prismlauncher

    vscode
    evtest
    sqlite

    python3
    python312Packages.pygame
    nodejs

    gh
    nixfmt
    nixfmt-tree
    hyprpolkitagent

    #neofetch
    cmatrix

    pavucontrol # GUI audio control
    playerctl # Media player control
    unzip

    numbat

    _1password-gui

    hyprpaper

    spotify

    # fonts
    noto-fonts-color-emoji
    nerd-fonts.geist-mono
    nerd-fonts.fira-code
    fira-code-symbols

    # cursor
    bibata-cursors

    # screenshots
    grim
    slurp
    wl-clipboard

    brightnessctl

    # spotify mute toggle
    (writeShellScriptBin "spotify-mute-toggle" ''

      SVOL="/tmp/spotify_volume_level"
      CVOL=$(playerctl -p spotify volume)

      if [ "$CVOL" = "0.000000" ]; then

        if [ -f "$SVOL" ]; then
            playerctl -p spotify volume $(cat "$SVOL")
        else
            playerctl -p spotify volume 0.5
        fi

      else
          echo "$CVOL" > "$SVOL"
          playerctl -p spotify volume 0.0
      fi

    '')

    # toggle spotify focus or launch
    (writeShellScriptBin "spotify-focus-toggle" ''
      CURRENT_CLASS=$(hyprctl activewindow -j | grep -o '"class": "[^"]*"' | cut -d'"' -f4)

      if [ "$CURRENT_CLASS" = "spotify" ]; then
        hyprctl dispatch focuscurrentorlast
      else
        hyprctl dispatch focuswindow class:spotify || spotify
      fi
    '')

    # launch the working Firefox binary directly
    (writeShellScriptBin "firefox-safe" ''
      exec ${pkgs.firefox-unwrapped}/bin/firefox "$@"
    '')

  ];

  # vesktop config
  programs.vesktop.enable = true;

  # alacritty config
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      #window.opacity = 0.8;
    };
  };

  # mako config
  services.mako = {
    enable = true;
    settings = {
      "app-name=Spotify" = {
        hidden = true;
      };
    };
  };
  # Bash aliases & functions
  programs.bash = {
    enable = true;
    initExtra = ''
      source /home/evren/flake/aliases.sh
    '';
  };

  # Get tofi to recognise firefox
  xdg.desktopEntries.firefox = {
    name = "Firefox";
    comment = "Web Browser";
    exec = "${pkgs.firefox-unwrapped}/bin/firefox %U";
    icon = "firefox";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  # config for catppuccin
  catppuccin = {
    flavor = "mocha";

    # manually enable all apps
    alacritty.enable = true;
    waybar.enable = false; # enable once to download theme
    #vesktop.enable = true;
    btop.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    mako.enable = true;

    tofi.enable = true; # disabled for opacity override
  };

  home.stateVersion = "25.05";

}

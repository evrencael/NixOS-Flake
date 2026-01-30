{ inputs, pkgs, ... }:
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
    mako

    firefox
    cloudflare-warp
    prismlauncher


    vscode
    evtest
    sqlite

    python3

    gh

    neofetch
    cmatrix

    pavucontrol  # GUI audio control
    playerctl    # Media player control
    unzip

    numbat

    _1password-gui

    hyprpaper

    # fonts
    noto-fonts-emoji
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

      if [ "$CURRENT_CLASS" = "Spotify" ]; then
        hyprctl dispatch focuscurrentorlast
      else
        hyprctl dispatch focuswindow class:Spotify || flatpak run com.spotify.Client
      fi
    '')
  ];


  # get tofi to recognise spotify, that was a bit annoying
  # Not sure I need this, I think it works fine without,
  # was causing a problem. prolly useful just in case
  #
  #home.file.".local/share/applications/com.spotify.Client.desktop".source =
  #  "${pkgs.writeShellScriptBin "resolve-flatpak-path" ''
  #    echo /var/lib/flatpak/exports/share/applications/com.spotify.Client.desktop
  #  ''}";

  # vesktop config
  programs.vesktop.enable = true;

  # alacritty config
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      #general.import = [ pkgs.alacritty-theme.nightfox ];
      #window.opacity = 0.8;
    };
  };

  # Bash aliases & functions
  programs.bash = {
    enable = true;
    initExtra = ''
      source /home/evren/flake/aliases.sh
    '';
  };


  # config for catppuccin
  catppuccin = {
    flavor = "mocha";

    # manually enable all apps
    alacritty.enable = true;
    waybar.enable = false;
    #vesktop.enable = true;
    btop.enable = true;
    firefox.enable = true;
    hyprland.enable = true;
    mako.enable = true;

    tofi.enable = true; # disabled for opacity override
  };

  home.stateVersion = "25.05";

}

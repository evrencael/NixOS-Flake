{
  programs.waybar.settings.topbar = {
    modules-right = [
      "privacy"
      "custom/lock"
      "wireplumber"
      "battery"
      "clock"
    ];

    modules-center = [ "hyprland/window" ];

    modules-left = [
      "hyprland/workspaces"
      "memory"
      "cpu"
      "disk"
    ];

    height = 36;
    margin = "5 5 0 5";

    "hyprland/window" = {
      format = "{title}";
      separate-outputs = true;
      rewrite = {
        "" = "󱄅";
        "(.*) — Mozilla Firefox" = "󰈹  $1";                    # firefox
        "^[•]? ?Discord \\| #(.+?) \\| (.+)$" = "  $1 - $2";  # secondary discord
        "^[•]? ?Discord \\| (.*)$" = "  $1";                  # discord
        "Spotify Premium" = "󰓇  Spotify";                      # spotify
        "(.*) - Visual Studio Code$" = "󰨞  $1";                # vs code
        "^(.+)@(.+): (.*)$" = "  $1@$2: $3";                  # terminal windows
        "^(?!.*(󰨞|󰈹||))(.+?) - (.+)$" = "󰓇  $2 - $3";        # add 󰓇 to songs
      };
    };

    "hyprland/workspaces" = {
      all-outputs = true;
    };

    "cpu" = {
      format = "  {usage}%";
    };
    "memory" = {
      format = "  {percentage}%";
    };
    "disk" = {
      format = "󰋊  {percentage_used}%";
    };

    "wireplumber" = {
      format = "  {volume}%";
      format-muted = "󰖁 {volume}%";
      on-click = "pavucontrol";
      scroll-step = 2;
    };

    "custom/lock" = {
      format = " Lock";
      on-click = "hyprlock";
      tooltip = false;
    };

    "upower" = {
      icon-size = 20;
      hide-if-empty = true;
      tooltip = true;
    };

    "clock" = {
      format = "{:%H:%M:%S %a %d %b}";
      interval = 1;
    };
  };
}

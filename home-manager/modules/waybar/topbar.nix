{
  programs.waybar.settings.topbar = {
    modules-left = [
      "hyprland/workspaces"
      "memory"
      "cpu"
      "disk"
    ];

    modules-center = [ "hyprland/window" ];

    modules-right = [
      "privacy"
      "upower"
      "custom/warp"
      "custom/lock"
      "wireplumber"
      "battery"
      "clock"
    ];

    height = 38;
    margin = "5 5 0 5";

    "hyprland/window" = {
      format = "{title}";
      separate-outputs = true;
      rewrite = {
        "" = "󱄅";
        "(.*) — Mozilla Firefox" = "󰈹 $1";                     # firefox
        "^[•]? ?Discord \\| #(.+?) \\| (.+)$" = " $1 - $2";   # secondary discord
        "^[•]? ?Discord \\| (.*)$" = " $1";                   # discord
        "Spotify Premium" = "󰓇 Spotify";                       # spotify
        "(.*) - Visual Studio Code$" = "󰨞 $1";                 # vs code
        "^(.+)@(.+): (.*)$" = " $1@$2: $3";                   # terminal windows
        "^(?!.*(󰨞|󰈹||))(.+?) - (.+)$" = "󰓇 $2 - $3";         # add 󰓇 to songs
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
      format = "󰋊 {percentage_used}%";
    };

    "wireplumber" = {
      format = "  {volume}%";
      format-muted = " {volume}%";
      on-click = "pavucontrol";
      scroll-step = 2;
    };

    "custom/lock" = {
      format = " Lock";
      on-click = "hyprlock";
      tooltip = false;
    };

    "custom/warp" = {
      format = "{}";
      return-type = "json";
      exec = "/home/evren/flake/home-manager/modules/waybar/warp-status.sh";
      interval = 1;
      on-click = "/home/evren/flake/home-manager/modules/waybar/warp-toggle.sh";
      tooltip = false;
    };

    "upower" = {
      icon-size = 20;
      hide-if-empty = true;
      tooltip = true;
    };

    "clock" = {
      format = "{:%a %d %b}";
      interval = 60;
    };
  };
}

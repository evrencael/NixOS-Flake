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
      exec = "/home/evren/flake/home-manager/modules/waybar/scripts/warp-status.sh";
      interval = 1;
      on-click = "/home/evren/flake/home-manager/modules/waybar/scripts/warp-toggle.sh";
      tooltip = false;
    };

    "clock" = {
      format = "{:%a %d %b}";
      interval = 60;
    };

    "battery" = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon}  {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = "󰚥 {capacity}%";
      format-full = "󰁹 {capacity}%";
      format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      tooltip-format = "{timeTo}\n{power}W";
      tooltip-format-charging = "󰂄 {timeTo}\n+{power}W charging";
      tooltip-format-discharging = "󰁾 {timeTo}\n-{power}W discharging";
      tooltip-format-full = "󰁹 Fully charged";
      tooltip-format-plugged = "󰚥 Plugged in\n{power}W";
    };

    "custom/brightness" = {
      format = "{}";
      return-type = "json";
      exec = "/home/evren/flake/home-manager/modules/waybar/scripts/brightness-status.sh";
      interval = 2;
      tooltip = true;
    };
  };
}

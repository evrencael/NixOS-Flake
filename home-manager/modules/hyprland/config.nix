{ hostname, ...}:
{
  # hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      monitor = if hostname == "evren"
        then ",preferred,auto,1.5" # zoom in on retina display
        else ",preferred,auto,1.0";

      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "tofi-drun | xargs hyprctl dispatch exec --";

      exec-once = [
        "mako"
        "waybar"
        "hyprctl dispatch exec '[workspace 1 silent] code'"
        "hyprctl dispatch exec '[workspace 2 silent] firefox'"
        "hyprctl dispatch exec '[workspace 3 silent] flatpak run com.spotify.Client'"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      cursor = {
        no_warps = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;


        "col.active_border" = "rgba(139cffee) rgba(c144ffee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 12;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow.render_power = 1;

        dim_inactive = false;
        #dim_strength = 0.1;

        blur = {
          passes = 3;
          size = 2;
        };
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # hide wallpaper text
      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = -1;
      };
    };
  };
}

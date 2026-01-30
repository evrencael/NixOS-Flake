{ hostname, ...}:
let
  # Common binds for all devices
  commonBinds = [
    "$mainMod, Space, exec, $menu"
    "$mainMod, T, exec, $terminal"
    "$mainMod, C, killactive"
    "$mainMod, L, exec, hyprlock"

    # move windows around
    "$mainMod, LEFT, swapwindow, l"
    "$mainMod, RIGHT, swapwindow, r"
    "$mainMod, UP, swapwindow, u"
    "$mainMod, DOWN, swapwindow, d"

    "$mainMod, F, togglefloating"  # fullscreen

    # switch workspaces
    "$mainMod, 1, exec, hyprctl dispatch workspace 1"
    "$mainMod, 2, exec, hyprctl dispatch workspace 2"
    "$mainMod, 3, exec, hyprctl dispatch workspace 3"
    "$mainMod, 4, exec, hyprctl dispatch workspace 4"
    "$mainMod, 5, exec, hyprctl dispatch workspace 5"
    "$mainMod, 6, exec, hyprctl dispatch workspace 6"
    "$mainMod, 7, exec, hyprctl dispatch workspace 7"
    "$mainMod, 8, exec, hyprctl dispatch workspace 8"
    "$mainMod, 9, exec, hyprctl dispatch workspace 9"
    "$mainMod, 0, exec, hyprctl dispatch workspace 10"

    # move windows between workspaces
    "$mainMod+SHIFT, 1, movetoworkspace, 1"
    "$mainMod+SHIFT, 2, movetoworkspace, 2"
    "$mainMod+SHIFT, 3, movetoworkspace, 3"
    "$mainMod+SHIFT, 4, movetoworkspace, 4"
    "$mainMod+SHIFT, 5, movetoworkspace, 5"
    "$mainMod+SHIFT, 6, movetoworkspace, 6"
    "$mainMod+SHIFT, 7, movetoworkspace, 7"
    "$mainMod+SHIFT, 8, movetoworkspace, 8"
    "$mainMod+SHIFT, 9, movetoworkspace, 9"
    "$mainMod+SHIFT, 0, movetoworkspace, 10"
  ];
  commonBindl = [];


  # Device-specific binds
  deviceBinds = {
    EvTop = [
      # media control
      "SHIFT, F1, exec, spotify-focus-toggle"

      # screenshot
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
    ];
    EvBook = [
      # screenshot
      "$mainMod+P, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mainMod+SHIFT, P, exec, grim -g \"$(slurp)\" ~/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
    ];
  };


  # Device-specific lock binds
  deviceBindl = {
    EvTop = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%+"  # increases by 5% for some reason
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2.5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      "SHIFT, F2, exec, playerctl -p spotify volume 0.05-"
      "SHIFT, F3, exec, playerctl -p spotify volume 0.05+"
      "SHIFT, F4, exec, spotify-mute-toggle"

      "SHIFT, F6, exec, playerctl -p spotify previous"
      "SHIFT, F7, exec, playerctl -p spotify play-pause"
      "SHIFT, F8, exec, playerctl -p spotify next"
    ];
    EvBook = [
      "SHIFT, F12, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "SHIFT, F11, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "SHIFT, F10, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      "SHIFT, F9, exec, playerctl -p spotify next"
      "SHIFT, F8, exec, playerctl -p spotify play-pause"
      "SHIFT, F7, exec, playerctl -p spotify previous"

      "SHIFT, F6, exec, brightnessctl -d '*::kbd_backlight' set +10%"
      "SHIFT, F5, exec, brightnessctl -d '*::kbd_backlight' set 10%-"

      "SHIFT, F2, exec, brightnessctl set +10%"
      "SHIFT, F1, exec, brightnessctl set 10%-"
    ];
  };
in
{
  wayland.windowManager.hyprland.settings = {
    bind = commonBinds ++ (deviceBinds.${hostname} or []);
    bindl = commonBindl ++ (deviceBindl.${hostname} or []);

    binds = {
      drag_threshold = 10;
    };

    bindm = [
      "$mainMod, mouse:272, movewindow"
    ];
  };
}

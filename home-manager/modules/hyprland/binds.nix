{ hostname, ... }:
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

    # fullscreen toggle
    "$mainMod, F, fullscreen"

    # switch workspaces
    "$mainMod, 1, workspace, 1" # LG
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"

    "$mainMod+CTRL, 1, workspace, 11" # Titan
    "$mainMod+CTRL, 2, workspace, 12"
    "$mainMod+CTRL, 3, workspace, 13"
    "$mainMod+CTRL, 4, workspace, 14"
    "$mainMod+CTRL, 5, workspace, 15"


    # move windows between workspaces
    "$mainMod+SHIFT, 1, movetoworkspace, 1" # LG
    "$mainMod+SHIFT, 2, movetoworkspace, 2"
    "$mainMod+SHIFT, 3, movetoworkspace, 3"
    "$mainMod+SHIFT, 4, movetoworkspace, 4"
    "$mainMod+SHIFT, 5, movetoworkspace, 5"

    "$mainMod+SHIFT+CTRL, 1, movetoworkspace, 11" # Titan
    "$mainMod+SHIFT+CTRL, 2, movetoworkspace, 12"
    "$mainMod+SHIFT+CTRL, 3, movetoworkspace, 13"
    "$mainMod+SHIFT+CTRL, 4, movetoworkspace, 14"
    "$mainMod+SHIFT+CTRL, 5, movetoworkspace, 15"
  ];

  commonBindl = [ ];

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
      ", XF86AudioRaiseVolume, exec, headset-volume-step up"
      ", XF86AudioLowerVolume, exec, headset-volume-step down"
      #", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      "SHIFT, F2, exec, playerctl -p spotify volume 0.05-"
      "SHIFT, F3, exec, playerctl -p spotify volume 0.05+"
      "SHIFT, F4, exec, spotify-mute-toggle"

      "SHIFT, F6, exec, playerctl -p spotify previous"
      "SHIFT, F7, exec, playerctl -p spotify play-pause"
      "SHIFT, F8, exec, playerctl -p spotify next"
    ];

    EvBook = [
      # volume control
      "SHIFT, F12, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "SHIFT, F11, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "SHIFT, F10, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # media control
      "SHIFT, F9, exec, playerctl -p spotify next"
      "SHIFT, F8, exec, playerctl -p spotify play-pause"
      "SHIFT, F7, exec, playerctl -p spotify previous"

      # kb backlight control
      "SHIFT, F6, exec, brightnessctl -d 'spi::kbd_backlight' set +10%"
      "SHIFT, F5, exec, brightnessctl -d 'spi::kbd_backlight' set 10%-"

      # screen brightness control
      "SHIFT, F2, exec, brightnessctl -d acpi_video0 set +10%"
      "SHIFT, F1, exec, brightnessctl -d acpi_video0 set 10%-"
    ];
  };
in
{
  wayland.windowManager.hyprland.settings = {
    bind = commonBinds ++ (deviceBinds.${hostname} or [ ]);
    bindl = commonBindl ++ (deviceBindl.${hostname} or [ ]);

    binds = {
      drag_threshold = 10;
    };

    bindm = [
      "$mainMod, mouse:272, movewindow"
    ];
  };
}

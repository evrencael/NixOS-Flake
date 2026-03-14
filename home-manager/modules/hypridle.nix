{
  hostname,
  pkgs,
  ...
}:
let
  isLaptop = hostname == "EvBook";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # lock screen after: 5 mins on EvBook, 10 mins on EvTop
        {
          timeout = if isLaptop then 300 else 600;
          on-timeout = "loginctl lock-session";
        }

        # turn off display after: 10 mins on EvBook, 20 mins on EvTop
        {
          timeout = if isLaptop then 600 else 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ]
      # shutdown after 60 mins on EvTop (EvBook uses logind suspend)
      ++ (if !isLaptop then [{
        timeout = if isLaptop then 900 else 3600;
        on-timeout = "systemctl poweroff";
      }] else []);
    };
  };

  # ensure brightnessctl doesn't need sudo on EvBook for dpms resume
  home.packages = with pkgs; [ hypridle ];
}

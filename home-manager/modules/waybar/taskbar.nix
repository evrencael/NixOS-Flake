{
  programs.waybar.settings.taskbar = {

    modules-left = [
      "mpris"
    ];

    modules-center = [
      "wlr/taskbar"
    ];

    modules-right = [
      "clock"
    ];

    "mpris" = {
      format = "󰓇  {dynamic} | {position}/{length}";
      format-paused = "{status_icon} <i>{dynamic} | {position}/{length}</i>";
      player = "spotify";
      status-icons = {
        paused = "⏸";
        stopped = "⏹";
      };

      dynamic-order = ["title" "artist"];
      dynamic-len = 45;
      dynamic-separator = " | ";

      interval = 1;
      tooltip = false;
    };


    "wlr/taskbar" = {
      icon-size = 24;
      on-click = "activate";
      tooltip = false;
    };

    "clock" = {
      format = "{:%H:%M:%S}";
      interval = 1;
      tooltip = false;
    };

    height = 50;
    margin = "0 5 5 5";
    position = "bottom";
  };
}

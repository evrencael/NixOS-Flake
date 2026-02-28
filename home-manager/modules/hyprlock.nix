{
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
				hidecursor = true;
				grace = 3;
        no_fade_in = true;
        no_fade_out = true;
			};

			background = [{
				monitor = "";
				path = "screenshot";
				blur_passes = 2;
				blur_size = 7;
			}];
    };
  };
}

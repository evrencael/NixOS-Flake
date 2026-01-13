{
  programs.tofi.enable = true;
  programs.tofi.settings = {
    font = "Fira Code";
    anchor = "center";
    background-color = "#1e1e2e99"; # Overrides catppuccin for opacity

    border-width = 0;
    outline-width = 0;
    prompt-text = "Open: ";

    corner-radius = 12;
    margin-top = 10;
    exclusive-zone = 0;
  };
}

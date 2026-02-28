# Base configuration
{
  config,
  pkgs,
  hostname,
  ...
}:
{
  # ============================================
  # BOOTLOADER
  # ============================================
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = if hostname == "EvBook" then 5 else 10;
    efi.canTouchEfiVariables = true;
  };

  # ============================================
  # KERNEL MODULES
  # ============================================
  boot.kernelModules = [ "snd-usb-audio" ];


  # ============================================
  # DEVICE IDENTITY
  # ============================================
  networking.hostName = hostname;


  # ============================================
  # NETWORKING
  # ============================================
  networking.networkmanager.enable = true;

  # ============================================
  # LOCALE & TIMEZONE
  # ============================================
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  # ============================================
  # KEYBOARD
  # ============================================
  services.xserver.xkb = {
    layout = "nz";
    variant = "";
  };

  # ============================================
  # USER ACCOUNT
  # ============================================
  users.users.evren = {
    isNormalUser = true;
    description = "Evren Packard";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
  };

  # ============================================
  # SECURITY & PERMISSIONS
  # ============================================
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  # ============================================
  # DESKTOP ENVIRONMENT
  # ============================================
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  # ============================================
  # APPLICATIONS
  # ============================================
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "evren" ];
  };

  # ============================================
  # NIX SETTINGS
  # ============================================
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ============================================
  # SERVICES
  # ============================================
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.cloudflare-warp.enable = true;

  # ============================================
  # AUDIO (PipeWire)
  # ============================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pulseaudio.enable = false; # Disable bc of PipeWire

  # ============================================
  # SYSTEM PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    wget
    git
    alacritty
    tofi
  ];

  # ============================================
  # WAYLAND ENVIRONMENT VARIABLES
  # ============================================
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    SDL_VIDEODRIVER = "x11";
  };

  # ============================================
  # SYSTEM VERSION
  # ============================================

  # DO NOT CHANGE
  system.stateVersion = "25.05";

  # graphical login, maybe one day
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};
}

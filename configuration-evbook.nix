{
  config,
  pkgs,
  ...
}:
{
  imports = [
      ./hardware-configuration-evbook.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.kernelModules = [ "snd-usb-audio" "snd-hda-intel" ];

  networking = {
    hostName = "EvBook"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # time zone & locale
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "nz";
    variant = "";
  };

  # User account
  users.users.evren = {
    isNormalUser = true;
    description = "Evren Packard";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  # allow sudo without password & unfree packages
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  # enable hyprland
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  # enable 1password & config
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "evren" ];
  };


  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # enable ssh, flatpak, & warp
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.cloudflare-warp.enable = true;

  # Enable sound with pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # more sound stuff :(
  security.rtkit.enable = true;
  hardware.enableAllFirmware = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto probe_mask=1
  '';

  # Disable PulseAudio bc of PipeWire
  services.pulseaudio.enable = false;


  # === Power Management ===

  # Enable TLP for power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 75;  # Limit CPU speed on battery

      START_CHARGE_THRESH_BAT0 = 75;  # Start charging
      STOP_CHARGE_THRESH_BAT0 = 80;   # Stop charging to preserves battery health
    };
  };

  # Auto-suspend when idle
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=suspend
      IdleActionSec=15min
    '';
  };

  # additional power tuning
  powerManagement.powertop.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    alacritty
    tofi
    powertop
    acpi

    alsa-utils
  ];


  # DO NOT CHANGE
  system.stateVersion = "25.05";


  # graphical login
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};

  # hopefully fix error on rebuild
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

}

# Base configuration
{
  config,
  pkgs,
  hostname,
  ...
}:
let
  scpPlymouthTheme = pkgs.stdenv.mkDerivation {
    name = "plymouth-theme-scp";
    src = pkgs.fetchFromGitHub {
      owner = "TechCiel";
      repo = "plymouth-theme-scp";
      rev = "master";
      sha256 = "sha256-o8YC6kn481ErrdBBUo+0c2BL7ekyRASpVEuEEn3c//k="; # replace after first failed build
    };
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/scp
      cp -r * $out/share/plymouth/themes/scp/
    '';
  };

  scpBootSplash = pkgs.stdenv.mkDerivation {
    name = "scp-boot-splash";
    src = pkgs.fetchFromGitHub {
      owner = "s-ankur";
      repo = "scp-boot-splash";
      rev = "master";
      sha256 = "sha256-KWmCPzFGeRStf1dFlHrktIQQtiePl9iwHHPmYo9SjJs="; # replace `pkgs.lib.fakeSha256` after first failed build
    };
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/scp-boot-splash
      cp -r * $out/share/plymouth/themes/scp-boot-splash/
    '';
  };

  greetdScript = pkgs.writeShellScript "tuigreet-launch" ''
    exec ${pkgs.greetd.tuigreet}/bin/tuigreet \
      --time \
      --asterisks \
      --greeting "$(cat /etc/greetd/greeting.txt)" \
      --theme "border=#00ff41;text=#00ff41;prompt=#00ff41;time=#00cc33;action=#00ff41;button=#003300;container=#0a0a0a;input=#00ff41" \
      --width 120 \
      --cmd Hyprland
  '';
in
{
  # ============================================
  # GREETD GREETING
  # ============================================
  environment.etc."greetd/greeting.txt".text = ''
███████╗ ██████╗██████╗     ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██╔════╝██╔══██╗    ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
███████╗██║     ██████╔╝    █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
╚════██║██║     ██╔═══╝     ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
███████║╚██████╗██║         ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
╚══════╝ ╚═════╝╚═╝         ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

Secure | Contain | Protect

— [ ACCESS PORTAL: SCiPNET TERMINAL ] —
  '';

  # ============================================
  # BOOT CONFIG
  # ============================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = if hostname == "EvBook" then 5 else 10;
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "snd-usb-audio" ];
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    plymouth = {
      enable = true;
      theme = "scp-boot-splash";
      themePackages = [ scpBootSplash ];

      extraConfig = ''
        ShowDelay=0
      '';
    };

    initrd = {
      systemd.enable = true;
      kernelModules = [ "i915" ];
    };
  };


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
  # DISPLAY MANAGER
  # ============================================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${greetdScript}";
        user = "greeter";
      };
    };
  };

  # Let plymouth play
  systemd.services.greetd.serviceConfig = {
    ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
  };


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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };


  # ============================================
  # SERVICES
  # ============================================
  services.openssh.enable = true;
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
  # SYSTEM VERSION (DO NOT CHANGE)
  # ============================================
  system.stateVersion = "25.05";
}

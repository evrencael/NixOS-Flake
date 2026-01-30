{ config, pkgs, ... }:
{
  # ============================================
  # IMPORTS
  # ============================================
  imports = [
    ../common/base.nix
    ./hardware-configuration.nix
  ];


  # ============================================
  # DEVICE IDENTITY
  # ============================================
  networking.hostName = "EvBook";


  # ============================================
  # KERNEL MODULES & AUDIO FIXES
  # ============================================
  boot.kernelModules = [ "snd-usb-audio" "snd-hda-intel" ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto probe_mask=1
  '';


  # ============================================
  # AUDIO FIXES
  # ============================================
  security.rtkit.enable = true;
  hardware.enableAllFirmware = true;


  # ============================================
  # POWER MANAGEMENT
  # ============================================

  # TLP - Advanced power management daemon
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

  # Lid and power button actions
  services.logind = {
    lidSwitch = "suspend";            # Suspend on lid close
    lidSwitchExternalPower = "lock";  # but lock when on external power
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=suspend
      IdleActionSec=15min
    '';
  };

  # PowerTOP auto-tuning for power savings ++
  powerManagement.powertop.enable = true;


  # ============================================
  # ADDITIONAL SYSTEM PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    powertop
    acpi
    alsa-utils
  ];
}

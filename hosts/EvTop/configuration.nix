{
  config,
  ...
}:
{
  # ============================================
  # NVIDIA GRAPHICS
  # ============================================
  services.xserver.videoDrivers = [ "nvidia" ]; # Use NVIDIA drivers

  hardware.nvidia = {
    modesetting.enable = true;

    # Power management - disable for desktop
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true; # use open-source NVIDIA kernel modules
    nvidiaSettings = true; # install nvidia-settings GUI tool

    # use stable drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}

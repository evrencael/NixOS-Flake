{
  config,
  ...
}:
{
  # ========================================
  # NVIDIA GRAPHICS
  # ========================================
  services.xserver.videoDrivers = [ "nvidia" ]; # Use NVIDIA drivers

  hardware.nvidia = {
    modesetting.enable = true;

    # Power management - disable for desktop
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false; # use open-source NVIDIA kernel modules
    nvidiaSettings = true; # install nvidia-settings GUI tool

    # use stable drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "video=efifb:off"                                    # disables EFI framebuffer
    "initcall_blacklist=simpledrm_platform_driver_init"  # belt-and-suspenders
  ];
  boot.plymouth.extraConfig = ''
    DeviceScale=1
  '';

}

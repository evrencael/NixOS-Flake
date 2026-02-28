{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
  ];
}

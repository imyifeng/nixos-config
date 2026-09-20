# The beryllium machine: graphical desktop host.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop-env.nix
  ];

  networking.hostName = "beryllium";

  # UEFI boot through systemd-boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allows managing network connections via NetworkManager.
  users.users.yifeng.extraGroups = [ "networkmanager" ];

  # Stateful-service compatibility level, fixed at installation time.
  system.stateVersion = "26.05";

  home-manager.users.yifeng = {
    imports = [
      ../../users/yifeng
      ../../modules/home/gui.nix
      ../../modules/home/niri.nix
    ];
  };
}

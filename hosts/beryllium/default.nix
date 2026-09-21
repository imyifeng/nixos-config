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

  # zram swap doubles the effective memory for heavy parallel builds on
  # this 8 GB machine. memoryPercent defaults to 50, which would cap the
  # devices at 4 GB.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };

  # Stateful-service compatibility level, fixed at installation time.
  system.stateVersion = "26.05";

  home-manager.users.yifeng = {
    imports = [
      ../../users/yifeng
      ../../modules/home/foot.nix
      ../../modules/home/gui.nix
      ../../modules/home/niri.nix
    ];
  };
}

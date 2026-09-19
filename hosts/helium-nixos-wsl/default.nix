# The helium-nixos-wsl machine: NixOS-WSL guest on the helium host.
# The NixOS-WSL module is wired up in flake.nix.
{ ... }:

{
  imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/wsl.nix
  ];

  networking.hostName = "helium-nixos-wsl";

  # Stateful-service compatibility level, fixed at installation time.
  system.stateVersion = "26.05";

  home-manager.users.yifeng = {
    imports = [ ../../users/yifeng ];
  };
}

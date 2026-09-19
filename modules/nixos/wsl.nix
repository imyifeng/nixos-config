# WSL guest settings. Requires the NixOS-WSL module, wired up in flake.nix.
{ ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "yifeng";
}

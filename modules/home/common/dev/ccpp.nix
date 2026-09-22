# C / C++ toolchain. Third-party libraries are best provided per project
# through a nix-shell/mkShell environment instead of globally.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    gdb
    pkg-config
  ];
}

# Command-line applications.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mcp-nixos
    fastfetch
  ];
}

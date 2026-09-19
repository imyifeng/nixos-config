# Command-line applications.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    mcp-nixos
  ];
}

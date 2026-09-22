# Command-line applications without module-level configuration. When an
# app gains real settings, graduate it into its own file next to this
# one.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    mcp-nixos
    opencode
  ];
}

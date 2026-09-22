# Niri compositor session. Registers the niri session and sets up
# portals and polkit, plus the authentication agent that niri does not
# start by itself (required for pkexec prompts).
{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs.polkit_gnome
  ];
}

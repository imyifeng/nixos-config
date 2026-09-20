# Graphical applications. Imported only by hosts with a desktop session.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    # Wayland terminal emulator, bound to Mod+T in the niri config.
    foot
  ];
}

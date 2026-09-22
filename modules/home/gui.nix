# Graphical applications. Imported only by hosts with a desktop session.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    localsend
  ];
}

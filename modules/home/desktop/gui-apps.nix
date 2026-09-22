# Graphical applications without module-level configuration.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    localsend
  ];
}

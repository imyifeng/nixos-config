# Graphical applications without module-level configuration.
{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = with pkgs; [
    google-chrome
    localsend
    obsidian
    pkgs-unstable.folia-major
    (callPackage ../../../pkgs/zcode/package.nix { })
  ];
}

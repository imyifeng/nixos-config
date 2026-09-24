# Graphical applications without module-level configuration.
#
# qq and wechat come from the unstable pin: upstream only serves the
# latest release, so version-pinned older downloads disappear.
{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = with pkgs; [
    google-chrome
    localsend
    pkgs-unstable.wechat
    pkgs-unstable.qq
    obsidian
    pkgs-unstable.folia-major
    (callPackage ../../../pkgs/zcode/package.nix { })
  ];
}

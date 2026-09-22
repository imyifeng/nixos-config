# Fonts for the desktop: CJK-friendly packages and fallback ordering
# for the generic families. Not needed by the headless WSL host.
{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  # Rendered as strong-binding prefer aliases in the system fontconfig
  # configuration.
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Alibaba PuHuiTi 3.0"
      "Noto Sans CJK SC"
      "Noto Sans"
    ];
    serif = [
      "Noto Serif CJK SC"
      "Noto Serif"
    ];
    monospace = [
      "Maple Mono NF CN"
      "Noto Sans Mono CJK SC"
      "Noto Sans Mono"
    ];
  };

  fonts.packages = [
    (pkgs.callPackage ../../../pkgs/alibaba-puhuiti/package.nix { })
    pkgs.maple-mono.NF-CN
    pkgs.noto-fonts
  ];
}

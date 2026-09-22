# Font packages and fallback ordering for the generic families.
{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  # Per-user defaults for the generic families; home-manager renders them
  # as strong-binding prefer aliases in conf.d/52-hm-default-fonts.conf.
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

  home.packages = with pkgs; [
    (callPackage ../../../pkgs/alibaba-puhuiti/package.nix { })
    maple-mono.NF-CN
    noto-fonts
  ];
}

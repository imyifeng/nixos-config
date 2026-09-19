# System-level settings shared by every host.
{ ... }:

{
  # Home Manager integration: hosts declare per-user configs through
  # `home-manager.users.<name>`.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # Existing dotfiles are kept as `<file>.backup` instead of failing the switch.
  home-manager.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;

  # Binary cache: USTC mirror first, official cache as fallback.
  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  services.openssh.enable = true;

  # Runtime linker fallback for prebuilt binaries shipped without nix support.
  programs.nix-ld.enable = true;

  # nh: rebuild and garbage-collection helper; NH_FLAKE points at this repo.
  programs.nh = {
    enable = true;
    flake = "/home/yifeng/nixos-config";
    clean.enable = true;
    clean.dates = "weekly";
  };

  users.users.yifeng = {
    isNormalUser = true;
    description = "YiFENG";
    extraGroups = [ "wheel" ];
  };
}

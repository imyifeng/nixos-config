# Home Manager entry for user yifeng. Hosts import this file and add
# host-specific modules (e.g. modules/home/gui.nix) alongside it.
{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/dev.nix
    ../../modules/home/git.nix
  ];

  home.username = "yifeng";
  home.homeDirectory = "/home/yifeng";
  home.stateVersion = "26.05";

  # Provides the `home-manager` command for this user.
  programs.home-manager.enable = true;
}

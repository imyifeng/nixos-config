# XDG user directories with English names, so paths are easy to type
# in a shell. The Chinese directories from the initial desktop session
# were empty and have been removed.
{ config, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";

    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/Projects";
    };
  };
}

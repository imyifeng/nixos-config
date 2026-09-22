# Thunar file manager with the desktop services it leans on: gvfs for
# trash, removable drives and phone mounts, tumbler for thumbnails.
{ ... }:

{
  programs.thunar.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}

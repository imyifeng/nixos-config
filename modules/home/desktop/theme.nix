# System look: Papirus icons for GTK apps and the Bibata Modern Ice
# cursor theme, published both as XCURSOR_* session variables (Wayland
# compositors, Qt) and as the GTK/dconf cursor theme.
{ pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
  };
}

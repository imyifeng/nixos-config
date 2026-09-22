# System look: adw-gtk3 theme and Papirus icons for GTK apps and the
# Bibata Modern Ice cursor theme, published both as XCURSOR_* session
# variables (Wayland compositors, Qt) and as the GTK/dconf cursor
# theme.
{ pkgs, ... }:

{
  gtk = {
    enable = true;
    # Makes GTK3 apps match the libadwaita look of GTK4 apps.
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
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

  # Qt apps follow the Noctalia palette through qtct: the shell
  # renders color schemes into ~/.config/{qt5ct,qt6ct}/colors and the
  # platform theme loads them. Papirus keeps the icons consistent with
  # the GTK side.
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings.Appearance = {
      color_scheme = "noctalia.conf";
      icon_theme = "Papirus";
    };
    qt6ctSettings.Appearance = {
      color_scheme = "noctalia.conf";
      icon_theme = "Papirus";
    };
  };
}

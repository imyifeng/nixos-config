# Foot terminal emulator, bound to Mod+T in the niri config. Each window
# reads the config at startup, so Noctalia theme changes apply to newly
# opened windows without restarting anything. Noctalia's foot template
# renders the active palette into ~/.config/foot/themes/noctalia, which
# main.include imports.
{ pkgs, ... }:

{
  home.packages = [ pkgs.maple-mono.NF-CN ];

  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "Maple Mono NF CN:size=12";
        pad = "10x10";
        include = "~/.config/foot/themes/noctalia";
      };

      csd.preferred = "none";

      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";

      # The Noctalia template owns the color keys; the background opacity
      # stays under our control.
      colors-dark.alpha = 0.8;
    };
  };
}

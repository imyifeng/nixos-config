# Fcitx5 input method with Rime: rime-ice + Wanxiang grammar model +
# moetype dictionary, bundled in pkgs/rime-data-wanxiang. The grammar
# model needs the octagram plugin, which nixpkgs compiles into librime.
{ pkgs, ... }:

let
  rimeData = pkgs.callPackage ../../../pkgs/rime-data-wanxiang/package.nix { };
in

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = [
      (pkgs.fcitx5-rime.override { rimeDataPkgs = [ rimeData ]; })
    ];

    # Pre-seed the profile so Rime is the active input method on first
    # launch, without a manual trip through the configuration UI.
    fcitx5.settings.inputMethod = {
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "rime";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "rime";
      GroupOrder."0" = "Default";
    };

    # Per https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland: keep only
    # XMODIFIERS (for XWayland apps) and let GTK/Qt talk to the Wayland
    # input method frontend via text-input-v3; the global IM module
    # variables cause candidate-window glitches. Apps that cannot do
    # text-input-v3 set QT_IM_MODULE=fcitx individually.
    fcitx5.waylandFrontend = true;
  };
}

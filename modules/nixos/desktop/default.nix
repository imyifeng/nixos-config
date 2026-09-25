# Graphical desktop system stack: session plumbing plus small services
# that have not earned their own file yet. Imported only by hosts that
# provide a graphical session.
{ pkgs-unstable, ... }:

{
  imports = [
    ./fcitx5.nix
    ./fonts.nix
    ./niri.nix
    ./noctalia.nix
    ./thunar.nix
    ./clash-party.nix
  ];

  # Expose the unstable pin to home-manager modules (e.g. gui-apps.nix);
  # NixOS modules already receive it through specialArgs.
  home-manager.extraSpecialArgs.pkgs-unstable = pkgs-unstable;

  networking.networkmanager.enable = true;

  # PipeWire handles audio capture and playback and exposes a
  # PulseAudio-compatible interface for desktop applications.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  # Flatpak runtime, driven interactively through the Bazaar app store.
  services.flatpak.enable = true;
}

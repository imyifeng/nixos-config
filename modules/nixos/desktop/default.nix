# Graphical desktop system stack: session plumbing plus small services
# that have not earned their own file yet. Imported only by hosts that
# provide a graphical session.
{ ... }:

{
  imports = [
    ./fcitx5.nix
    ./fonts.nix
    ./niri.nix
    ./noctalia.nix
    ./clash-party.nix
  ];

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
}

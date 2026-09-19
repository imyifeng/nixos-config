# Graphical desktop system stack: NetworkManager, GNOME, audio, printing.
# Imported only by hosts that provide a graphical session.
{ ... }:

{
  networking.networkmanager.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Keyboard layout for GDM and X11 sessions.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # PipeWire handles audio capture and playback and exposes a
  # PulseAudio-compatible interface for desktop applications.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}

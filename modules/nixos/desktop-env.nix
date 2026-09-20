# Graphical desktop system stack: niri + Noctalia, greeter, audio, printing.
# Imported only by hosts that provide a graphical session.
{
  noctalia,
  noctalia-greeter,
  ...
}:

{
  imports = [
    noctalia.nixosModules.default
    noctalia-greeter.nixosModules.default
  ];

  networking.networkmanager.enable = true;

  # Niri: scrollable-tiling Wayland compositor. Registers the niri session
  # and sets up portals and polkit.
  programs.niri.enable = true;

  # Noctalia desktop shell. recommendedServices enables NetworkManager,
  # Bluetooth, UPower and power-profiles-daemon for the status widgets.
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # Noctalia greeter for greetd. The module enables greetd, polkit and
  # accounts-daemon and starts noctalia-greeter-session by default.
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "niri";
      keyboard.layout = "us";
    };
  };

  # Noctalia publishes binaries keyed to its own nixpkgs pin (kept separate
  # in flake.nix), so the cache is required to avoid long source builds.
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
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

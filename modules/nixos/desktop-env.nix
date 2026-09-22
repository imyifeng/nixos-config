# Graphical desktop system stack: niri + Noctalia, greeter, audio, printing.
# Imported only by hosts that provide a graphical session.
{
  pkgs,
  lib,
  noctalia,
  noctalia-greeter,
  pkgs-unstable,
  ...
}:

let
  # Clash Party proxy GUI, packaged in pkgs/clash-party from the upstream deb.
  clashParty = pkgs.callPackage ../../pkgs/clash-party/package.nix { };
in
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

  # Clash Party TUN support. The Mihomo cores must run as root, but the
  # store is read-only, so the activation script materializes root-owned
  # setuid copies in /var/lib/clash-party/sidecar — the directory the
  # package symlinks into its resources/sidecar path.
  systemd.tmpfiles.rules = [
    "d /var/lib/clash-party 0755 root root -"
    "d /var/lib/clash-party/sidecar 0755 root root -"
  ];

  system.activationScripts.clashPartySidecars.text =
    lib.concatMapStrings (name: ''
      install -D -m 4755 -o root -g root \
        "${clashParty}/opt/clash-party/resources/nix-sidecar-store/${name}.real" \
        "/var/lib/clash-party/sidecar/${name}"
    '') [
      "mihomo"
      "mihomo-alpha"
      "mihomo-smart"
    ]
    + ''
      install -D -m 0644 -o root -g root \
        "${clashParty}/opt/clash-party/resources/nix-sidecar-store/sysproxy.linux-x64-gnu.node.real" \
        "/var/lib/clash-party/sidecar/sysproxy.linux-x64-gnu.node"
      # Leftover from the earlier two-copy layout.
      rm -f /var/lib/clash-party/sidecar/mihomo.bin \
        /var/lib/clash-party/sidecar/mihomo-alpha.bin \
        /var/lib/clash-party/sidecar/mihomo-smart.bin
    '';

  # Polkit authentication agent for pkexec prompts; niri does not start
  # one by itself.
  environment.systemPackages = [
    clashParty
    pkgs.polkit_gnome
  ];

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

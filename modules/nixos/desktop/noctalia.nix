# Noctalia desktop shell and greeter.
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
}

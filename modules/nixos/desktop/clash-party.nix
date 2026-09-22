# Clash Party proxy GUI, packaged in pkgs/clash-party from the upstream deb.
{
  pkgs,
  lib,
  ...
}:

let
  clashParty = pkgs.callPackage ../../../pkgs/clash-party/package.nix { };
in
{
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

  environment.systemPackages = [
    clashParty
  ];
}

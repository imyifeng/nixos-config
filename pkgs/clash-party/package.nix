# Clash Party (mihomo-party successor), packaged from the upstream .deb.
# Not in nixpkgs; the deb ships a prebuilt Electron tree that we relocate
# verbatim and patch against NixOS libraries.
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  gtk3,
  libdrm,
  libGL,
  libnotify,
  libsecret,
  libuuid,
  libxkbcommon,
  libXcomposite,
  libXdamage,
  libXrandr,
  libXScrnSaver,
  libXtst,
  mesa,
  nspr,
  nss,
  pango,
  vulkan-loader,
  wl-clipboard,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  pname = "clash-party";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/mihomo-party-org/clash-party/releases/download/v${version}/clash-party-linux-${version}-amd64.deb";
    hash = "sha256-pF7N7LqFtvNmKFGmAT0xh0rF4Pkd+FXcaLOa7EssRj0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups.lib
    gtk3
    libdrm
    libGL
    libnotify
    libsecret
    libuuid
    libxkbcommon
    libXcomposite
    libXdamage
    libXrandr
    libXScrnSaver
    libXtst
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    wl-clipboard
    xdg-utils
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    dpkg -x $src source
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share
    cp -r source/opt/clash-party $out/opt/clash-party

    # The setuid helper cannot work from the store; without it Electron
    # falls back to the unprivileged namespace sandbox.
    rm $out/opt/clash-party/chrome-sandbox

    # TUN needs the Mihomo cores to run as root, which the read-only store
    # cannot provide. The NixOS module materializes root-owned setuid
    # copies in /var/lib/clash-party/sidecar; point the app at that. The
    # sysproxy native binding ships in the same directory and must survive
    # the move: its loader only searches resources/sidecar.
    mkdir -p $out/opt/clash-party/resources/nix-sidecar-store
    for sidecar in mihomo mihomo-alpha mihomo-smart sysproxy.linux-x64-gnu.node; do
      mv $out/opt/clash-party/resources/sidecar/$sidecar \
        $out/opt/clash-party/resources/nix-sidecar-store/$sidecar.real
    done
    rm -rf $out/opt/clash-party/resources/sidecar
    ln -s /var/lib/clash-party/sidecar $out/opt/clash-party/resources/sidecar

    cp -r source/usr/share/{applications,icons,mime} $out/share/

    makeWrapper $out/opt/clash-party/mihomo-party $out/bin/clash-party \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils wl-clipboard ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          mesa
          libdrm
          vulkan-loader
        ]
      } \
      --set-default ELECTRON_OZONE_PLATFORM_HINT auto

    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace-fail "Exec=/opt/clash-party/mihomo-party %U" "Exec=$out/bin/clash-party %U"

    runHook postInstall
  '';

  meta = {
    description = "Another Mihomo GUI (Clash Party)";
    homepage = "https://github.com/mihomo-party-org/clash-party";
    license = lib.licenses.mit;
    mainProgram = "clash-party";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

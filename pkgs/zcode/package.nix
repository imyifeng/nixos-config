# ZCode desktop client (Electron), packaged from the official linux-x64
# deb. Not in nixpkgs. Build inputs were derived from `readelf -d` on the
# main binary plus the usual Electron dlopen set.
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
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libGL,
  libkrb5,
  libnotify,
  libsecret,
  libuuid,
  libxkbcommon,
  libxkbfile,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXScrnSaver,
  libXtst,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  wl-clipboard,
  xdg-utils,
  desktop-file-utils,
  shared-mime-info,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "zcode";
  version = "3.14.3";

  src = fetchurl {
    url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.deb";
    hash = "sha256-hRL7eIiWhsfs3JGmCahua0CCVaENsMmvug0+N3sLW08=";
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
    cups
    dbus
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libnotify
    libsecret
    libuuid
    libxkbcommon
    libxkbfile
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libXScrnSaver
    libXtst
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    vulkan-loader
    zlib
  ];

  # Bundled native modules may ship musl/aarch64 variants that cannot be
  # resolved on this platform; they are never loaded at runtime.
  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libc.musl-aarch64.so.1"
    "ld-musl-x86_64.so.1"
    "ld-musl-aarch64.so.1"
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    dpkg -x $src source
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r source/opt/ZCode $out/share/zcode

    # The setuid helper cannot work from the store; without it Electron
    # falls back to the unprivileged namespace sandbox. This also covers
    # the deep-link relaunch path, which runs the raw binary without the
    # wrapper's flags.
    rm -f $out/share/zcode/chrome-sandbox

    cp -r source/usr/share/{applications,icons,doc} $out/share/ 2>/dev/null || true

    makeWrapper $out/share/zcode/zcode $out/bin/zcode \
      --prefix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
          shared-mime-info
          wl-clipboard
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          mesa
          libdrm
          vulkan-loader
        ]
      } \
      --set-default ELECTRON_OZONE_PLATFORM_HINT auto

    substituteInPlace $out/share/applications/zcode.desktop \
      --replace-fail "Exec=/opt/ZCode/zcode %U" "Exec=$out/bin/zcode %U"

    runHook postInstall
  '';

  meta = {
    description = "ZCode desktop client (Electron app by Z.ai)";
    homepage = "https://zcode.z.ai/";
    license = lib.licenses.unfree;
    mainProgram = "zcode";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

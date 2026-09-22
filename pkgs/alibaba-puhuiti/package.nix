# Alibaba PuHuiTi 3.0 (阿里巴巴普惠体 3.0), packaged from the official
# zip. Not in nixpkgs. The download CDN enforces a referer ACL, so the
# fetch must carry an alibabafonts.com referer. Only the TTF weights are
# installed; the zip also ships otf/woff/eot variants.
{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "alibaba-puhuiti";
  version = "3.0";

  src = fetchurl {
    url = "https://fonts.alibabadesign.com/AlibabaPuHuiTi-3.zip";
    hash = "sha256-8l9zC2p2YbzVuXZNyY8F06wl7ncZd88Esx7V+6n0lqc=";
    curlOpts = "-e https://www.alibabafonts.com/";
  };

  nativeBuildInputs = [ unzip ];

  # The zip holds the font folder and a __MACOSX junk tree side by side;
  # enter the font folder so the junk never gets installed.
  sourceRoot = "AlibabaPuHuiTi-3";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    find . -name '*.ttf' -exec install -m 0444 -Dt $out/share/fonts/truetype {} +

    runHook postInstall
  '';

  meta = {
    description = "Alibaba PuHuiTi, a free CJK sans-serif typeface by Alibaba";
    homepage = "https://www.alibabafonts.com/";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
}

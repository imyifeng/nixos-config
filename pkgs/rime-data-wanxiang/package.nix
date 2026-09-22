# Rime shared data for fcitx5-rime: rime-ice (雾凇拼音) as the base
# scheme, the moetype dictionary (萌娘百科词条词库) mounted as an extra
# table, and the Wanxiang octagram grammar model. The custom yaml files
# next to this expression patch rime-ice. librime reads the bundle from
# fcitx5-rime's read-only data dir, so user dictionaries and deployment
# output stay in the writable per-user directory
# (~/.local/share/fcitx5/rime).
{
  lib,
  stdenvNoCC,
  fetchurl,
  rime-ice,
}:

let
  # Toneless variant: rime-ice spells full pinyin without tone marks.
  # The file declares dictionary name "moe", so it installs under that
  # name for rime_ice.dict.custom.yaml to reference.
  moetypeDict = fetchurl {
    url = "https://github.com/suiginko/moetype/releases/download/20260912/toneless_moe.dict.yaml";
    hash = "sha256-+AZuBSTGn57dT7ow+JLTG4656juQdL2/k7nqe1Jxu0o=";
  };

  grammarModel = fetchurl {
    url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
    hash = "sha256-aZ0EWhvpJqOf0M2j9w4VMyRUElnbOQ1wtb8BF3QuRFE=";
  };
in

stdenvNoCC.mkDerivation {
  pname = "rime-data-wanxiang";
  version = "2026.09.22";

  dontUnpack = true;

  env = {
    inherit moetypeDict grammarModel;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp -r ${rime-ice}/share/rime-data/. $out/share/rime-data/

    install -m 0444 $moetypeDict $out/share/rime-data/moe.dict.yaml
    install -m 0444 $grammarModel $out/share/rime-data/wanxiang-lts-zh-hans.gram

    install -m 0444 ${./default.custom.yaml} $out/share/rime-data/default.custom.yaml
    install -m 0444 ${./rime_ice.custom.yaml} $out/share/rime-data/rime_ice.custom.yaml

    # librime's dict compiler does not read *.custom.yaml patches, so the
    # table mount is edited into the dict file itself. The replaced line
    # is the extension hook documented in rime-ice's own dict file; the
    # grep below fails the build if upstream drops it.
    sed -i 's|^  # - mydict1.*$|  - moe|' $out/share/rime-data/rime_ice.dict.yaml
    grep -q '^  - moe$' $out/share/rime-data/rime_ice.dict.yaml

    # fcitx5-rime expects the file to exist; the schema list comes in
    # through default.custom.yaml instead.
    touch $out/share/rime-data/default.yaml

    runHook postInstall
  '';

  meta = {
    description = "Rime data: rime-ice with moetype dictionary and Wanxiang grammar model";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
}

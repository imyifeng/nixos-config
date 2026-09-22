# Python toolchain: the interpreter bundles pip; uv manages tools and
# environments outside the Nix store. Package indexes point at the USTC
# mirror.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
    uv
  ];

  xdg.configFile."uv/uv.toml".text = ''
    [[index]]
    url = "https://mirrors.ustc.edu.cn/pypi/simple"
    default = true
  '';

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirrors.ustc.edu.cn/pypi/simple
  '';
}

# Rust toolchain with crates.io served through rsproxy.cn.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustc
    cargo
  ];

  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = "rsproxy-sparse"

    [source.rsproxy-sparse]
    registry = "sparse+https://rsproxy.cn/index/"

    [registries.rsproxy]
    index = "sparse+https://rsproxy.cn/index/"

    [net]
    git-fetch-with-cli = true
  '';
}

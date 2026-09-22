# Development environment: language toolchains and shared dev tools.
# Project-specific environments belong in per-project devShells instead.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal AI coding agent.
    opencode

    # Python: the interpreter bundles pip; uv manages tools and
    # environments outside the Nix store.
    python3
    uv

    # JavaScript / TypeScript.
    nodejs
    pnpm

    # Go.
    go

    # Rust.
    rustc
    cargo

    # C / C++.
    gcc
    gnumake
    gdb
    pkg-config
  ];

  # Chinese package mirrors for the toolchains above (USTC PyPI,
  # goproxy.cn, rsproxy.cn, npmmirror).
  xdg.configFile."uv/uv.toml".text = ''
    [[index]]
    url = "https://mirrors.ustc.edu.cn/pypi/simple"
    default = true
  '';

  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirrors.ustc.edu.cn/pypi/simple
  '';

  xdg.configFile."go/env".text = ''
    GOPROXY=https://goproxy.cn,direct
  '';

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

  home.file.".npmrc".text = ''
    registry=https://registry.npmmirror.com
  '';
}

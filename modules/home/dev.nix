# Development environment: language toolchains and shared dev tools.
# Project-specific environments belong in per-project devShells instead.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal AI coding agent.
    opencode

    # Python: the interpreter bundles pip; uv and pipx manage tools and
    # environments outside the Nix store.
    python3
    uv
    pipx

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
}

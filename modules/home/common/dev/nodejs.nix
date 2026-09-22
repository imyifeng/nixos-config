# Node.js toolchain with packages served through npmmirror; pnpm reads
# the same .npmrc.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    pnpm
  ];

  home.file.".npmrc".text = ''
    registry=https://registry.npmmirror.com
  '';
}

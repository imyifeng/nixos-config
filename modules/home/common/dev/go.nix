# Go toolchain with modules served through goproxy.cn. The env file is
# managed here, so `go env -w` cannot be used to change it.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
  ];

  xdg.configFile."go/env".text = ''
    GOPROXY=https://goproxy.cn,direct
  '';
}

# Command-line applications.
{ pkgs, ... }:

{
  # Declarative git identity; enabling the module also installs the package.
  programs.git = {
    enable = true;
    settings.user = {
      name = "imyifeng";
      email = "imyifeng@163.com";
    };
  };

  home.packages = with pkgs; [
    mcp-nixos
  ];
}

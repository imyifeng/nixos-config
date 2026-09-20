# Git and GitHub CLI.
{ pkgs, ... }:

{
  # Declarative git identity; enabling the module also installs the package.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "imyifeng";
        email = "imyifeng@163.com";
      };
      # Git config is managed by home-manager and therefore read-only, so
      # gh's credential helper is declared here instead of by `gh auth login`.
      credential."https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  home.packages = with pkgs; [
    gh
  ];
}

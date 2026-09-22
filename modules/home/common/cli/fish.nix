# Fish shell. Home-manager generates shellAliases and
# interactiveShellInit inside a `status is-interactive` block, so the
# aliases below never apply to non-interactive fish (scripts, ssh
# commands) which keep the stock ls/cat behaviour.
{ ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      ll = "eza -lha --icons=always --group-directories-first";
      la = "eza -a --icons=always --group-directories-first";
      lt = "eza --tree --icons=always";
      cat = "bat";
    };
  };
}

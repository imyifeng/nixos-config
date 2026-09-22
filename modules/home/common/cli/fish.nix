# Fish shell and the tools serving its interactive experience: the
# starship prompt, eza as ls and bat as cat. All of it is
# interactive-only: home-manager generates shellAliases and
# interactiveShellInit inside a `status is-interactive` block, so
# non-interactive fish (scripts, ssh commands) keeps the stock
# commands.
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

  # Starship prompt. Its fish integration (enableInteractive defaults
  # to true) emits `starship init fish | source` into the interactive
  # shell init. Bash keeps its plain prompt.
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
  };

  # eza's own alias integration is disabled so it does not fight the
  # aliases above.
  programs.eza = {
    enable = true;
    enableFishIntegration = false;
  };

  # bat; wired up as `cat` through the alias above.
  programs.bat.enable = true;
}

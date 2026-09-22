# Starship prompt. Its fish integration (enableInteractive defaults to
# true) emits `starship init fish | source` into the interactive shell
# init, so the prompt only loads in interactive sessions.
{ ... }:

{
  programs.starship.enable = true;
}

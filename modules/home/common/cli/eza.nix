# eza, a modern ls replacement. The fish aliases (ls, ll, la, lt) live
# in fish.nix; the module's own alias integration is disabled so it
# does not fight them.
{ ... }:

{
  programs.eza = {
    enable = true;
    enableFishIntegration = false;
  };
}

# Bash, the login shell (TTY, ssh, WSL). Interactive terminals run
# fish instead (see foot.nix). Sessions override the system's Chinese
# locale with English so command output stays in English.
{ ... }:

{
  programs.bash = {
    enable = true;
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };
}

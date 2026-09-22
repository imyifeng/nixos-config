# Bash, the login shell (TTY, ssh, WSL). Interactive terminals run
# fish instead (see foot.nix). Interactive sessions override the
# system's Chinese locale with English. The exports go into .bashrc
# after its interactive-only guard, not into ~/.profile: greetd starts
# the session through the login shell, so profile exports would switch
# the whole desktop to English.
{ ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
    '';
  };
}

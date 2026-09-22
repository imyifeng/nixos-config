# Make Thunar the default handler for folders, so "open folder"
# actions in any application launch it.
{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
}

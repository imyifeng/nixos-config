# Niri compositor configuration with the Noctalia integrations from
# https://docs.noctalia.dev/noctalia/compositor-settings/niri/.
{ ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    // Start the Noctalia shell.
    spawn-at-startup "noctalia"

    // Fcitx5 input method daemon.
    spawn-at-startup "fcitx5"

    // Polkit authentication agent for pkexec prompts.
    spawn-at-startup "polkit-gnome-authentication-agent-1"

    // Rounded corners for all windows.
    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
    }

    // niri draws the focus ring as a solid rectangle behind the window,
    // which shows through foot's translucent background and makes it look
    // opaque while focused. Draw the ring around foot instead.
    window-rule {
        match app-id="^foot$"
        draw-border-with-background false
    }

    // Noctalia opens its settings UI as a fixed-size floating window.
    window-rule {
        match app-id="dev.noctalia.Noctalia"
        open-floating true
        default-column-width { fixed 1080; }
        default-window-height { fixed 920; }
    }

    // Lets Noctalia notification actions and window activation work.
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    // Show Noctalia's wallpaper behind the overview. Requires the
    // [niri/backdrop] section to be enabled in the Noctalia settings.
    layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
    }

    // Blur every app window; Noctalia publishes its own blur regions and
    // only needs xray turned off on its surfaces. Requires niri >= 26.04.
    window-rule {
        background-effect {
            blur true
            xray false
        }
    }

    layer-rule {
        match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
        background-effect {
            xray false
        }
    }

    layer-rule {
        match namespace="noctalia-window-switcher"
        background-effect {
            blur true
            xray false
        }
    }

    // Global blur tuning.
    blur {
        passes 2
        offset 3.0
        noise 0.03
        saturation 1.0
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Noctalia launcher, control center, settings and window switcher.
        Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+Comma { spawn-sh "noctalia msg settings-toggle"; }
        Alt+Tab { spawn-sh "noctalia msg window-switcher"; }

        // Volume and brightness keys.
        XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute { spawn-sh "noctalia msg volume-mute"; }
        XF86MonBrightnessUp { spawn-sh "noctalia msg brightness-up"; }
        XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }

        Mod+T { spawn "foot"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }

        // Focus.
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        // Move windows.
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End { focus-column-last; }
        Mod+Shift+Home { move-column-to-first; }
        Mod+Shift+End { move-column-to-last; }

        // Workspaces.
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Shift+U { move-window-to-workspace-down; }
        Mod+Shift+I { move-window-to-workspace-up; }
        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        Mod+F { fullscreen-window; }
        Mod+Shift+Space { toggle-window-floating; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
    }
  '';
}

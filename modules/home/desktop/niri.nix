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

    // Rounded corners for all windows. Draw the focus ring around the
    // window instead of behind it, so translucent backgrounds (e.g.
    // foot) stay see-through while focused.
    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
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

        // Noctalia shell surfaces: launcher, control center, settings,
        // window switcher, power menu, clipboard, lock and wallpaper.
        Alt+Space hotkey-overlay-title="Launcher" { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+N hotkey-overlay-title="Control center" { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+I hotkey-overlay-title="Settings" { spawn-sh "noctalia msg settings-toggle"; }
        Alt+Tab hotkey-overlay-title="Window switcher" { spawn-sh "noctalia msg window-switcher"; }
        Mod+Shift+P hotkey-overlay-title="Power menu" { spawn-sh "noctalia msg panel-toggle session"; }
        Mod+Alt+V hotkey-overlay-title="Clipboard history" { spawn-sh "noctalia msg panel-toggle clipboard"; }
        Mod+Alt+L hotkey-overlay-title="Lock screen" { spawn-sh "noctalia msg session lock"; }
        Mod+Alt+W hotkey-overlay-title="Wallpaper picker" { spawn-sh "noctalia msg panel-toggle wallpaper"; }
        Mod+F10 hotkey-overlay-title="Random wallpaper" { spawn-sh "noctalia msg wallpaper-random"; }

        // Volume and brightness keys.
        XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute { spawn-sh "noctalia msg volume-mute"; }
        XF86MonBrightnessUp { spawn-sh "noctalia msg brightness-up"; }
        XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }

        Mod+T hotkey-overlay-title="Terminal" { spawn "foot"; }
        Mod+Return hotkey-overlay-title="Terminal" { spawn "foot"; }
        Mod+B hotkey-overlay-title="Browser" { spawn "google-chrome"; }
        Mod+E hotkey-overlay-title="File manager" { spawn "thunar"; }

        Mod+O hotkey-overlay-title="Toggle overview" repeat=false { toggle-overview; }
        Mod+G repeat=false { toggle-overview; }
        Mod+Q hotkey-overlay-title="Close focused window" repeat=false { close-window; }
        Mod+MouseMiddle { close-window; }

        // Focus: arrows, vim keys, W/S and mouse side buttons.
        Mod+Left hotkey-overlay-title=null { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }
        Mod+W { focus-window-up; }
        Mod+S { focus-window-down; }
        Mod+MouseForward { focus-window-up; }
        Mod+MouseBack    { focus-window-down; }
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        // Move the focused column or window.
        Mod+Ctrl+Left hotkey-overlay-title=null { move-column-left; }
        Mod+Ctrl+Right hotkey-overlay-title=null { move-column-right; }
        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+J { move-window-down; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+L { move-column-right; }
        Mod+Ctrl+A { move-column-left; }
        Mod+Ctrl+D { move-column-right; }
        Mod+Ctrl+S { move-window-down; }
        Mod+Ctrl+W { move-window-up; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        // Monitor focus.
        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H { focus-monitor-left; }
        Mod+Shift+J { focus-monitor-down; }
        Mod+Shift+K { focus-monitor-up; }
        Mod+Shift+L { focus-monitor-right; }

        // Move the focused column across monitors.
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+A { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+S { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+W { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+D { move-column-to-monitor-right; }

        // Move the whole workspace to another monitor.
        Mod+Shift+Alt+W { move-workspace-to-monitor-up; }
        Mod+Shift+Alt+S { move-workspace-to-monitor-down; }
        Mod+Shift+Alt+D { move-workspace-to-monitor-right; }
        Mod+Shift+Alt+A { move-workspace-to-monitor-left; }
        Mod+Shift+Alt+K { move-workspace-to-monitor-up; }
        Mod+Shift+Alt+J { move-workspace-to-monitor-down; }
        Mod+Shift+Alt+L { move-workspace-to-monitor-right; }
        Mod+Shift+Alt+H { move-workspace-to-monitor-left; }
        Mod+Shift+Alt+Up    { move-workspace-to-monitor-up; }
        Mod+Shift+Alt+Down  { move-workspace-to-monitor-down; }
        Mod+Shift+Alt+Right { move-workspace-to-monitor-right; }
        Mod+Shift+Alt+Left  { move-workspace-to-monitor-left; }

        // Mouse wheel: Shift switches workspaces, Ctrl+Shift moves windows
        // across workspaces, plain moves column focus, Ctrl moves columns.
        Mod+Shift+WheelScrollDown hotkey-overlay-title="Change workspaces" cooldown-ms=150 { focus-workspace-down; }
        Mod+Shift+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+Shift+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
        Mod+WheelScrollDown hotkey-overlay-title="Change focus with wheel" { focus-column-right; }
        Mod+WheelScrollUp { focus-column-left; }
        Mod+Ctrl+WheelScrollDown { move-column-right; }
        Mod+Ctrl+WheelScrollUp { move-column-left; }

        // Merge the focused window into a neighboring column or expel it.
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+A hotkey-overlay-title="Move window left between columns" { consume-or-expel-window-left; }
        Mod+D hotkey-overlay-title="Move window right between columns" { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        Mod+Shift+A { consume-window-into-column; }
        Mod+Shift+D { expel-window-from-column; }

        // Tabbed display for the focused column.
        Mod+Shift+X { toggle-column-tabbed-display; }

        // Window sizing.
        Mod+R hotkey-overlay-title="Switch preset width" { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F hotkey-overlay-title="Maximize column" { maximize-column; }
        Mod+Alt+F hotkey-overlay-title="Fullscreen" { fullscreen-window; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }
        Mod+Minus { set-column-width "-5%"; }
        Mod+Equal { set-column-width "+5%"; }
        Mod+Shift+Minus { set-window-height "-5%"; }
        Mod+Shift+Equal { set-window-height "+5%"; }

        // Floating.
        Mod+V hotkey-overlay-title="Toggle floating" { toggle-window-floating; }
        Mod+Shift+V hotkey-overlay-title=null { switch-focus-between-floating-and-tiling; }
        Alt+grave hotkey-overlay-title=null { switch-focus-between-floating-and-tiling; }

        // Screenshots (hide the pointer in the captured image).
        Mod+Alt+A hotkey-overlay-title="Select area screenshot" { spawn-sh "niri msg action screenshot --show-pointer false"; }
        Mod+Ctrl+Alt+A hotkey-overlay-title="Focused window screenshot" { spawn-sh "niri msg action screenshot-window --show-pointer false"; }
        Mod+Ctrl+Shift+Alt+A hotkey-overlay-title="Monitor screenshot" { spawn-sh "niri msg action screenshot-screen --show-pointer false"; }
        Print hotkey-overlay-title=null { spawn-sh "niri msg action screenshot --show-pointer false"; }
        Ctrl+Print hotkey-overlay-title=null { spawn-sh "niri msg action screenshot-window --show-pointer false"; }
        Shift+Print hotkey-overlay-title=null { spawn-sh "niri msg action screenshot-screen --show-pointer false"; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Shift+E hotkey-overlay-title="Quit niri" { quit; }

        // Workspaces: numbers jump, PageUp/PageDown and the wheel navigate.
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }
    }

    // Marks every window as tiled, which makes GTK apps drop their
    // fallback client-side title bar (Thunar would draw one
    // otherwise). Niri itself draws no title bar.
    prefer-no-csd

    // Noctalia renders the active palette colors into noctalia.kdl;
    // its template hook expects the config to include it.
    include "~/.config/niri/noctalia.kdl"
  '';
}

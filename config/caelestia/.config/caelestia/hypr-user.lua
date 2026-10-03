-- Hyprland user configuration (Caelestia v2)
-- Deployed as a symlink from ~/dots/config by the dots Ansible playbook.
-- Loaded at the END of ~/.config/hyprland.lua, so every value here
-- overrides the Caelestia defaults.
--
-- API reference: https://vinitlee.github.io/hl-docs/
-- This file uses the global `hl` object provided by Hyprland's Lua runtime.

hl.config({
    input = {
        kb_layout = "de",
        kb_options = "ctrl:nocaps",
        repeat_rate = 40,
        repeat_delay = 600,
        numlock_by_default = true,
        touchpad = {
            scroll_factor = 0.4,
        },
    },
    cursor = {
        warp_on_change_workspace = 0,
        no_warps = true,
        inactive_timeout = 1,
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
        anr_missed_pings = 3,
        on_focus_under_fullscreen = 1,
    },
    binds = {
        hide_special_on_workspace_change = true,
    },
})

-- ── Navigation mit ALT ───────────────────────────────────────────────────────

-- Workspace wechseln (code:10..18 = Zahlentasten 1..9, layout-unabhängig)
hl.bind("ALT + code:10", hl.dsp.focus({ workspace = "1" }), { description = "Switch to workspace 1" })
hl.bind("ALT + code:11", hl.dsp.focus({ workspace = "2" }), { description = "Switch to workspace 2" })
hl.bind("ALT + code:12", hl.dsp.focus({ workspace = "3" }), { description = "Switch to workspace 3" })
hl.bind("ALT + code:13", hl.dsp.focus({ workspace = "4" }), { description = "Switch to workspace 4" })
hl.bind("ALT + code:14", hl.dsp.focus({ workspace = "5" }), { description = "Switch to workspace 5" })
hl.bind("ALT + code:15", hl.dsp.focus({ workspace = "6" }), { description = "Switch to workspace 6" })
hl.bind("ALT + code:16", hl.dsp.focus({ workspace = "7" }), { description = "Switch to workspace 7" })
hl.bind("ALT + code:17", hl.dsp.focus({ workspace = "8" }), { description = "Switch to workspace 8" })
hl.bind("ALT + code:18", hl.dsp.focus({ workspace = "9" }), { description = "Switch to workspace 9" })

-- Fenster zu Workspace verschieben
hl.bind("ALT + SHIFT + code:10", hl.dsp.window.move({ workspace = "1" }), { description = "Move window to workspace 1" })
hl.bind("ALT + SHIFT + code:11", hl.dsp.window.move({ workspace = "2" }), { description = "Move window to workspace 2" })
hl.bind("ALT + SHIFT + code:12", hl.dsp.window.move({ workspace = "3" }), { description = "Move window to workspace 3" })
hl.bind("ALT + SHIFT + code:13", hl.dsp.window.move({ workspace = "4" }), { description = "Move window to workspace 4" })
hl.bind("ALT + SHIFT + code:14", hl.dsp.window.move({ workspace = "5" }), { description = "Move window to workspace 5" })
hl.bind("ALT + SHIFT + code:15", hl.dsp.window.move({ workspace = "6" }), { description = "Move window to workspace 6" })
hl.bind("ALT + SHIFT + code:16", hl.dsp.window.move({ workspace = "7" }), { description = "Move window to workspace 7" })
hl.bind("ALT + SHIFT + code:17", hl.dsp.window.move({ workspace = "8" }), { description = "Move window to workspace 8" })
hl.bind("ALT + SHIFT + code:18", hl.dsp.window.move({ workspace = "9" }), { description = "Move window to workspace 9" })

-- Fokus bewegen (vim-style)
hl.bind("ALT + h", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind("ALT + j", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })
hl.bind("ALT + k", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind("ALT + l", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })

-- Fenster schließen
hl.bind("ALT + q", hl.dsp.window.close(), { description = "Close window" })

-- Letzten Workspace (schnelles Hin- und Herwechseln)
hl.bind("ALT + d", hl.dsp.focus({ workspace = "previous" }), { description = "Toggle last workspace" })

-- Fullscreen
hl.bind("ALT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Toggle fullscreen" })

-- ── Launcher und Anwendungen ────────────────────────────────────────────────

-- App Launcher (Caelestia Drawer über globalen Shell-Shortcut)
hl.bind("ALT + space", hl.dsp.global("caelestia:launcher"), { description = "Open app launcher" })

-- Terminal
hl.bind("ALT + Return", hl.dsp.exec_cmd("kitty"), { description = "Terminal" })
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"), { description = "Terminal" })
hl.bind("SUPER + ALT + Return", hl.dsp.exec_cmd("kitty -e tmux new-session -A -s Work"), { description = "Tmux" })

-- Dateimanager
hl.bind("SUPER + e", hl.dsp.exec_cmd("nautilus --new-window"), { description = "File manager" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("nautilus --new-window"), { description = "File manager" })

-- Browser
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("firefox-developer-edition"), { description = "Browser" })

-- Anwendungen
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("spotify"), { description = "Music" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("kitty -e nvim"), { description = "Editor" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("kitty -e lazydocker"), { description = "Docker" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd("signal-desktop"), { description = "Signal" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian -disable-gpu --enable-wayland-ime"), { description = "Obsidian" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("typora --enable-wayland-ime"), { description = "Typora" })

-- Nicht portiert aus der Omarchy-Konfiguration:
--   ALT+SHIFT+SPACE (Omarchy-Menü) und die Webapp-Bindings (SUPER+SHIFT+A/C/E/Y
--   usw.) und SUPER+SHIFT+SLASH (1Password) — die hängen an omarchy-Helfern
--   bzw. nicht installierten Apps. Nachrüsten mit hl.bind(..., hl.dsp.exec_cmd("...")).

-- NVIDIA (Maxwell/Pascal/Volta without GSP firmware), if applicable:
-- hl.env("NVD_BACKEND", "egl")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

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

-- Example keybinds (uncomment to use; adjust launchers to Caelestia tools):
-- hl.bind("ALT + Return", hl.dsp.exec_cmd("kitty"))
-- hl.bind("ALT + h", hl.dsp.movefocus("l"))
-- hl.bind("ALT + j", hl.dsp.movefocus("d"))
-- hl.bind("ALT + k", hl.dsp.movefocus("u"))
-- hl.bind("ALT + l", hl.dsp.movefocus("r"))
-- hl.bind("ALT + q", hl.dsp.killactive())
-- hl.bind("ALT + 1", hl.dsp.workspace("1"))

-- NVIDIA (Maxwell/Pascal/Volta without GSP firmware), if applicable:
-- hl.env("NVD_BACKEND", "egl")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

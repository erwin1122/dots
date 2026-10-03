-- User overrides for Caelestia's variables.lua
-- Deployed as a symlink from ~/dots/config by the dots Ansible playbook.
-- Caelestia merges this table over its defaults, so its built-in app
-- keybinds (SUPER+T etc.) launch these instead of foot/firefox/codium.
return {
    terminal = "kitty",
    browser = "firefox-developer-edition",
    editor = "kitty -e nvim",
    fileExplorer = "nautilus",
}

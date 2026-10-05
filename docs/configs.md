# Configuration catalog

Everything under `config/` in this repository is deployed as symlinks into
your home directory by the `configs` Ansible role. This file is the overview:
which applications have managed configuration, where the source lives, and
where it lands on the target system.

## Layout convention

One directory per application ID, mirroring the target paths inside `$HOME`:

```text
config/
├── bash/
│   └── .bashrc                      → ~/.bashrc
├── fish/
│   └── .config/fish/                → ~/.config/fish/   (directory symlink)
└── omp/
    └── .omp/config.yml              → ~/.omp/config.yml
```

Rules:

- `config/<app>/` mirrors the target paths inside `$HOME`; every file in it is
  symlinked individually (`config/bash/.bashrc` → `~/.bashrc`,
  `config/fish/.config/fish/config.fish` → `~/.config/fish/config.fish`).
- Directories in the repo are not linked themselves — their files are. This
  merges cleanly into directories that already exist on the target system
  (for example `~/.config/caelestia` managed by Caelestia) without replacing
  foreign content. Empty directories are not reproduced.
- Files that already exist at a target path and are not our symlinks are
  archived to `~/.cache/dots/archived-configs/` instead of being overwritten.
- Existing directory symlinks along a managed file's path (for example an old
  Stow-managed `~/.config/nvim`) are detached and replaced with real directories.
  Only files from `dots` are then linked into those directories. The old source
  checkout is neither read for migration nor modified; its unmanaged state is
  not copied into the active configuration.

Behavior:

- During system provisioning, the applications role resolves which selected
  applications get their configuration deployed. The configuration-only
  playbook instead uses the explicitly selected config IDs and installs no
  packages.
- Re-running the playbook updates all symlinks. Files added later to
  `config/<app>/` are deployed on the next playbook run.
- When Herdr is selected, its plugins are registered and a running server's
  configuration is reloaded after deployment. Existing panes keep running;
  no server is started if Herdr is not running.

### Apply selected configs without reinstalling apps

Run as your normal user, without `sudo`:

```bash
cd ~/dots
ansible-playbook playbooks/configs.yml \
  -e '{"dotfiles_selected_apps":["neovim","fish","tmux"]}'
```

Directory-symlink detachment does not use the archive directory. Backups are
needed only when replacing regular config files. New archive directories belong
to the target user; if an earlier root-run left that directory owned by root,
ownership repair requires privilege escalation. Use `--ask-become-pass` for
such a config-only run.

For just Neovim, select `["neovim"]`. Herdr does not need to be selected again
when its configuration and navigation plugin are already installed. Restart
Neovim after applying its config. Reload an existing tmux server with
`tmux source-file ~/.tmux.conf`, and open a new fish shell for fish changes.

To reapply Herdr's own config, include `"herdr"`; this registers the bundled
plugin and reloads a running server, without downloading Herdr again.

The normal provisioning playbook and `bootstrap.sh` still install selected apps.
The config-only playbook requires those apps and their runtime dependencies to
already exist.

The fish `opencode`/`oc` root launcher mirrors the local tmux-only setup;
ordinary OpenCode subcommands remain usable outside tmux. tmux's optional
OpenRig resurrection hooks are enabled only when its local filter exists.
Neovim includes the local Quickfix mappings, Obsession session plugin, and
the Neovim 0.12 Treesitter compatibility module.

### Herdr pane navigation

`Ctrl+h/j/k/l` invokes the bundled `vim-herdr-navigation` plugin directly,
without the `Ctrl+a` prefix. If Herdr was already running when the config was
installed, its old keybindings remain active until a reload. The installer now
reloads automatically; for an earlier installation or a manual config edit, run:

```bash
herdr server reload-config
```

This applies the bindings without stopping pane processes. Do not use
`herdr server stop` just to activate keybindings.

## Managed configurations

| App ID | Source in repo | Target | Notes |
|---|---|---|---|
| `bash` | `config/bash/.bashrc` | `~/.bashrc` | |
| `fish` | `config/fish/.config/fish/` | `~/.config/fish/` | `fish_variables` is machine-generated and deliberately not managed |
| `git` | `config/git/.config/git/` | `~/.config/git/` | User name/email intentionally excluded |
| `kitty` | `config/kitty/.config/kitty/` | `~/.config/kitty/` | |
| `neovim` | `config/neovim/.config/nvim/` | `~/.config/nvim/` | Kickstart-based |
| `tmux` | `config/tmux/.tmux.conf` | `~/.tmux.conf` | |
| `lazygit` | `config/lazygit/.config/lazygit/` | `~/.config/lazygit/` | |
| `btop` | `config/btop/.config/btop/` | `~/.config/btop/` | |
| `fastfetch` | `config/fastfetch/.config/fastfetch/` | `~/.config/fastfetch/` | |
| `starship` | `config/starship/.config/starship.toml` | `~/.config/starship.toml` | |
| `herdr` | `config/herdr/.config/herdr/` | `~/.config/herdr/` | `config.toml` + the vendored `plugins/vim-herdr-navigation` (registered via `herdr plugin link`); machine-generated state files are not managed |
| `omp` | `config/omp/.omp/config.yml` | `~/.omp/config.yml` | German speech-to-text enabled |
| `caelestia` | `config/caelestia/.config/caelestia/` | `~/.config/caelestia/` | `hypr-user.lua` (keybinds/config) + `hypr-vars.lua` (app overrides) + `shell.json` (launcher `vimKeybinds` enabled: Ctrl+J/N down, Ctrl+K/P up in launcher); applied when the profile enables Caelestia |

## Not managed (yet)

- **Hyprland base layout** — Caelestia v2 owns `~/.config/hypr/`
  (`hyprland.lua` plus the modular `hyprland/*.lua` files); replacing it with
  the old Omarchy-style `.conf` files would break the shell.
- **Hyprland user overrides** — managed as
  `config/caelestia/.config/caelestia/hypr-user.lua` (keybindings and config
  settings) plus `config/caelestia/.config/caelestia/hypr-vars.lua` (app
  overrides so Caelestia's own keybinds launch kitty, Firefox Developer
  Edition, nvim, and nautilus). Caelestia loads these at the end of its
  `hyprland.lua`, so every setting there wins over Caelestia defaults.
  Applied whenever the profile enables Caelestia (independent of the app
  catalog). Omarchy-specific bindings (Omarchy menu, webapp bindings,
  1Password) are documented as not ported inside `hypr-user.lua`.
- **`waybar`, `i3`, `wezterm`** — legacy from the previous desktop; they are
  not part of the Hyprland/Caelestia target.

## Adding an application configuration

1. Create `config/<app-id>/` with the files in the target layout (see the
   convention above). `<app-id>` must match a catalog entry in
   `group_vars/Archlinux.yml`.
2. Add a row to the table above.

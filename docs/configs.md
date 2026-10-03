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

- Everything directly inside `config/<app>/` is linked to the same relative
  path in `$HOME` (`config/bash/.bashrc` → `~/.bashrc`).
- A single leading `.config` or `.omp` directory is transparent: its contents
  are linked one level deeper, because `~/.config` itself must stay a real
  directory shared with other applications.
- `.config`, `.omp` themselves and `$HOME` are never replaced.

Behavior of the `configs` role:

- Only applications that are installed in the same playbook run
  (`dotfiles_resolved_applications`) get their configuration deployed. Adding
  an app to the catalog plus a matching `config/<app>/` directory is enough.
- If an unmanaged real directory already exists at a target path, it is moved
  to `~/.cache/dots/archived-configs/` instead of being overwritten. Existing
  files and symlinks are replaced.
- Re-running the playbook updates the symlinks (they point into the repo, so
  a `git pull` in `~/dots` updates your configuration without re-running
  Ansible).

## Managed configurations

| App ID | Source in repo | Target | Notes |
|---|---|---|---|
| `bash` | `config/bash/.bashrc` | `~/.bashrc` | |
| `fish` | `config/fish/.config/fish/` | `~/.config/fish/` | `fish_variables` is machine-generated and deliberately not managed |
| `git` | `config/git/.config/git/` | `~/.config/git/` | User name/email intentionally excluded |
| `kitty` | `config/kitty/.config/kitty/` | `~/.config/kitty/` | |
| `nvim` | `config/nvim/.config/nvim/` | `~/.config/nvim/` | Kickstart-based |
| `tmux` | `config/tmux/.tmux.conf` | `~/.tmux.conf` | |
| `lazygit` | `config/lazygit/.config/lazygit/` | `~/.config/lazygit/` | |
| `btop` | `config/btop/.config/btop/` | `~/.config/btop/` | |
| `fastfetch` | `config/fastfetch/.config/fastfetch/` | `~/.config/fastfetch/` | |
| `starship` | `config/starship/.config/starship.toml` | `~/.config/starship.toml` | |
| `herdr` | `config/herdr/.config/herdr/` | `~/.config/herdr/` | Only `config.toml`; `plugins.json` contains absolute local paths and is not managed |
| `omp` | `config/omp/.omp/config.yml` | `~/.omp/config.yml` | German speech-to-text enabled |

## Not managed (yet)

- **Hyprland / Caelestia** — Caelestia writes its own Hyprland configuration
  during `caelestia install`. User-level Hyprland tweaks will be integrated in
  a follow-up step after verifying against the Caelestia layout.
- **`waybar`, `i3`, `wezterm`** — legacy from the previous desktop; they are
  not part of the Hyprland/Caelestia target.

## Adding an application configuration

1. Create `config/<app-id>/` with the files in the target layout (see the
   convention above). `<app-id>` must match a catalog entry in
   `group_vars/Archlinux.yml`.
2. Add a row to the table above.

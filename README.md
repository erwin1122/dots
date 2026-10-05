# dots

Reproducible Arch Linux setup for Hyprland and Caelestia Shell v2. KDE Plasma
with SDDM remains installed as a reliable fallback desktop session.

## Install

After following the Archinstall tutorial, run this as the normal user. With no
arguments, it installs the complete daily-driver profile:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash
```

The bootstrap script installs its dependencies, clones this repository to
`~/dots`, then runs the versioned local Ansible playbook. Review
[`bootstrap.sh`](bootstrap.sh) before using a changed revision.

### Apply configs locally

After the initial installation, run the configuration-only playbook from your
local checkout as your normal user:

```bash
cd ~/dots
ansible-playbook playbooks/configs.yml \
  -e '{"dotfiles_selected_apps":["neovim","fish","tmux"]}'
```

This does not install or update system packages. Select only the configs you
want to apply. Regular local config files are archived; old directory symlinks
are detached without copying their contents or modifying their source checkout.
The active managed files then come exclusively from `dots`. See
[docs/configs.md](docs/configs.md) for details, including archive ownership repair
when earlier root-run provisioning left root-owned backups.

For Neovim's Herdr navigation, an already configured Herdr does not need to be
selected again. On a fresh setup, install/configure Herdr first; the Neovim
bindings load its bundled editor integration.

## Tutorials

- [Install Arch Linux with KDE Plasma and SDDM](docs/archinstall-kde-plasma.md)
- [Application catalog and installation profiles](docs/applications.md)

## Profiles

```bash
# Daily-driver desktop, including Steam
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- full

# Desktop without gaming
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- workstation

# No graphical desktop or Caelestia
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- server

# Select applications from an interactive terminal prompt
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- select
```

The current implementation is Arch-only. Each app is named in the catalog,
can be installed through the `custom` or `select` profile, and application
configuration is deployed as symlinks for every installed app that has one —
see [docs/configs.md](docs/configs.md).

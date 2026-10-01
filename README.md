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
can be installed through the `custom` or `select` profile, and will receive
its own configuration directory during the next migration phase.

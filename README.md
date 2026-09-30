# dots

Reproducible Arch Linux workstation setup for Hyprland and Caelestia Shell v2.
KDE Plasma with SDDM remains installed as a reliable fallback desktop session.

## Install

After following the Archinstall tutorial, run this as the normal user:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash
```

The bootstrap script installs its dependencies, clones this repository to
`~/dots`, then runs the versioned local Ansible playbook. Review
[`bootstrap.sh`](bootstrap.sh) before using a changed revision.

## Tutorials

- [Install Arch Linux with KDE Plasma and SDDM](docs/archinstall-kde-plasma.md)

## Profiles and tags

The current profile is Arch-only:

```bash
sudo ansible-playbook playbooks/arch-hyprland-caelestia.yml \
  --extra-vars "dotfiles_user=${USER} dotfiles_home=${HOME}"
```

Run a smaller part with tags:

```bash
sudo ansible-playbook playbooks/arch-hyprland-caelestia.yml \
  --extra-vars "dotfiles_user=${USER} dotfiles_home=${HOME}" --tags terminal
```

Roles separate reusable application concerns from distribution-specific package
lists. Future Ubuntu or other distribution profiles will reuse the portable
roles and provide their own package variables and tasks.

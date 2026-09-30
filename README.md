# dots

Reproducible workstation setup for Arch Linux. The first profile installs
Hyprland and Caelestia Shell v2 while leaving KDE Plasma and SDDM available as
a fallback session. Application configuration is added after the base desktop
profile is proven on a fresh machine.

## Install

Run this as the normal user on a fresh Arch installation:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash
```

GitHub renders a copy button on the command block. The script installs its
bootstrap dependencies, clones this repository to `~/dots`, then runs the
versioned local Ansible playbook. Review
[`bootstrap.sh`](bootstrap.sh) before using a changed revision.

## Profiles and tags

The current profile is Arch-only:

```bash
ansible-playbook playbooks/arch-hyprland-caelestia.yml --ask-become-pass
```

Run a smaller part with tags:

```bash
ansible-playbook playbooks/arch-hyprland-caelestia.yml --ask-become-pass --tags terminal
```

Roles separate reusable application concerns from distribution-specific package
lists. Future Ubuntu or other distribution profiles will reuse the portable
roles and provide their own package variables and tasks.

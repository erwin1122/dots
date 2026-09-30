# Archinstall: KDE Plasma, Wayland, and SDDM

This guide prepares a fresh Arch Linux machine for this Hyprland and Caelestia
setup. It installs KDE Plasma on Wayland with SDDM first, so Plasma remains
available as a known-good fallback after Hyprland and Caelestia are installed.

The guide targets a QEMU/KVM virtual machine, but the installer choices also
apply to a physical UEFI machine. **Selecting a disk in Archinstall erases its
contents.** Do not use this guide on a disk with data you want to keep.

## Install Arch Linux

1. Boot the current official Arch Linux ISO in UEFI mode.
2. Verify that networking works:

   ```bash
   ping -c 3 archlinux.org
   ```

3. Start the guided installer:

   ```bash
   archinstall
   ```

4. Choose these settings in the menus:

   | Menu | Choice |
   |---|---|
   | Language | `Deutsch` |
   | Mirrors | A nearby mirror region |
   | Disk configuration | Use the whole **VM disk**; choose a filesystem deliberately |
   | Bootloader | `Grub` |
   | Swap | Enabled, `zstd` |
   | Hostname | `archlinux` |
   | Root password | Set one or leave root locked if you create a sudo user |
   | User account | `arch`; grant it sudo access |
   | Profile | `Desktop` → `KDE Plasma` (Wayland) |
   | Greeter | `sddm` |
   | Graphics driver | `All open-source` for a QEMU virtio GPU or Intel/AMD hardware |
   | Audio | `pipewire` |
   | Kernel | `linux` |
   | Locale, keyboard, timezone | `de_DE`, `de`, `Europe/Berlin` |

5. Review the summary carefully, especially the selected disk, then install.
6. Reboot, remove the ISO, and sign in to **Plasma (Wayland)** through SDDM.

Do not remove KDE Plasma or SDDM: they are the fallback session while
Hyprland/Caelestia is being developed and tested.

## Copyable Archinstall settings

This is a JSON **settings excerpt**, not a complete unattended configuration.
It deliberately omits `disk_config` and user credentials, because those values
must match the target disk and must never be copied blindly between machines.

```json
{
  "archinstall-language": "Deutsch",
  "audio_config": {
    "audio": "pipewire"
  },
  "bootloader_config": {
    "bootloader": "Grub",
    "removable": false,
    "uki": false
  },
  "kernels": [
    "linux"
  ],
  "hostname": "archlinux",
  "locale_config": {
    "kb_layout": "de",
    "sys_enc": "UTF-8",
    "sys_lang": "de_DE"
  },
  "ntp": true,
  "profile_config": {
    "gfx_driver": "All open-source",
    "greeter": "sddm",
    "profile": {
      "details": [
        "KDE Plasma"
      ],
      "main": "Desktop"
    }
  },
  "swap": {
    "algorithm": "zstd",
    "enabled": true
  },
  "timezone": "Europe/Berlin"
}
```

For a reusable unattended installation, run the guided installer once and
save/export its generated configuration. Edit the exported `disk_config` only
after checking the target device name, then use that ISO's matching
configuration format:

```bash
archinstall --config config.json
```

Archinstall's JSON schema evolves with the ISO. Generating the base
configuration from the exact ISO you booted is safer than copying a full disk
layout from an older tutorial.

## Install the dots

Open a terminal in Plasma as the normal user and run:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash
```

The first run installs Hyprland, Caelestia Shell v2, required services, and
the currently defined application roles. After it succeeds, log out through
SDDM and choose the Hyprland session. Plasma remains selectable from the same
session menu.

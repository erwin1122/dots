# Application catalog

This catalog is the installation source of truth for the first migration
phase. It contains applications and intentionally selected developer tools,
not transitive dependencies: Pacman and Yay resolve those themselves.

The catalog uses only official Arch repositories and the AUR. It does not rely
on Omarchy packages or Omarchy configuration.

## Profiles

| Profile | Contents |
|---|---|
| `full` | Daily-driver desktop: every group below, including Steam |
| `workstation` | `full` without the gaming group |
| `server` | Shell/CLI, development, containers, and AI tools; no Hyprland or Caelestia |
| `custom` | Only explicitly supplied application IDs; no desktop profile is implied |

Use a named profile:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- workstation
```

Install individual applications without a desktop profile:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- custom tmux neovim spotify
```

Or choose comma-separated application IDs interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- select
```

## Applications

| Group | Application IDs | Source |
|---|---|---|
| Shell and CLI | `bash`, `fish`, `tmux`, `tmux-plugin-manager`, `fzf`, `fd`, `ripgrep`, `bat`, `eza`, `btop`, `fastfetch`, `zoxide`, `starship`, `lazygit`, `tldr` | Arch; `tmux-plugin-manager` from AUR |
| Development | `neovim`, `git`, `github-cli`, `clang`, `rust`, `dotnet-sdk`, `luarocks`, `mise`, `tree-sitter-cli` | Arch |
| Terminal | `kitty`, `lazydocker` | Arch |
| Browser and knowledge | `firefox-developer-edition`, `librewolf`, `bitwarden`, `obsidian`, `typora` | Arch; `typora` from AUR |
| Communication | `signal-desktop`, `spotify`, `localsend` | Arch; `spotify` and `localsend-bin` from AUR |
| Office and files | `nautilus`, `libreoffice`, `gnome-disk-utility`, `gnome-calculator` | Arch |
| Media and creative work | `mpv`, `obs-studio`, `kdenlive`, `pinta`, `xournalpp`, `imv` | Arch |
| Virtualization | `virt-manager` | Arch; also installs QEMU, libvirt, SWTPM, DNSMasq, OVMF, and Virt Viewer |
| Containers | `docker` | Arch; also installs Docker Compose and Lazydocker |
| AI coding tools | `claude-code`, `github-copilot-cli`, `opencode` | AUR for Claude Code and the Copilot CLI binary; Arch for OpenCode |
| Gaming | `steam` | Arch `multilib`; only in `full` |

The `firefox-developer-edition` entry also installs the German language pack.
Caelestia's default Firefox and Foot components are disabled: this setup uses
Firefox Developer Edition plus LibreWolf and Kitty instead.

## Service changes

Selecting `docker` enables `docker.service` and adds the configured user to
the `docker` group. Selecting `virt-manager` enables `libvirtd.service` and
adds the user to the `libvirt` and `kvm` groups. Log out and back in after
either group change.

Selecting Steam enables the Arch `multilib` repository before installation.
The profile detects Nvidia, AMD, Intel, and Virtio GPUs and adds the matching
32-bit Vulkan driver so Pacman does not prompt for a provider. Advanced users
can override this with `dotfiles_steam_vulkan_driver`.

Before AUR builds, the installer clears the package-download cache and then
installs AUR apps one at a time with build cleanup. This keeps the `full`
profile viable on moderately sized VM disks.

## Configuration migration

This phase installs software only. Application configuration is deliberately
deferred. The next phase will keep configuration sources separated by
application, for example:

```text
config/
├── fish/
├── nvim/
├── tmux/
├── kitty/
├── lazygit/
└── ...
```

That separation will allow a configuration to be enabled independently of the
package profile that installed its application.

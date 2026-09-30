#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPOSITORY="https://github.com/erwin1122/dots.git"
readonly DESTINATION="${HOME}/dots"

if [[ "$(id -u)" -eq 0 ]]; then
  printf '%s\n' "Run this bootstrap script as your normal user, not as root." >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  printf '%s\n' "This bootstrap script currently supports Arch Linux only." >&2
  exit 1
fi

sudo pacman -Syu --needed --noconfirm ansible git base-devel

if [[ -d "${DESTINATION}/.git" ]]; then
  git -C "${DESTINATION}" pull --ff-only
else
  git clone "${REPOSITORY}" "${DESTINATION}"
fi

cd "${DESTINATION}"
ansible-playbook playbooks/arch-hyprland-caelestia.yml --ask-become-pass

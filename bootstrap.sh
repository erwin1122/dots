#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPOSITORY="https://github.com/erwin1122/dots.git"
readonly DESTINATION="${HOME}/dots"
sudo_options=()

if [[ "${DOTS_NONINTERACTIVE:-0}" == "1" ]]; then
  sudo_options+=(--non-interactive)
fi

if [[ "$(id -u)" -eq 0 ]]; then
  printf '%s\n' "Run this bootstrap script as your normal user, not as root." >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  printf '%s\n' "This bootstrap script currently supports Arch Linux only." >&2
  exit 1
fi

sudo "${sudo_options[@]}" pacman -Syu --needed --noconfirm ansible git base-devel

if [[ -d "${DESTINATION}/.git" ]]; then
  git -C "${DESTINATION}" pull --ff-only
else
  git clone "${REPOSITORY}" "${DESTINATION}"
fi

cd "${DESTINATION}"
sudo "${sudo_options[@]}" -i /usr/bin/env \
  "ANSIBLE_CONFIG=${DESTINATION}/ansible.cfg" \
  "ANSIBLE_ROLES_PATH=${DESTINATION}/roles" \
  /usr/bin/ansible-playbook \
  --inventory "${DESTINATION}/inventories/localhost.yml" \
  "${DESTINATION}/playbooks/arch-hyprland-caelestia.yml" \
  --extra-vars "dotfiles_user=${USER} dotfiles_home=${HOME}"

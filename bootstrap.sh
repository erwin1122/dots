#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPOSITORY="https://github.com/erwin1122/dots.git"
readonly DESTINATION="${HOME}/dots"
sudo_options=()
profile="${1:-full}"
selected_apps=()

usage() {
  cat <<'EOF'
Usage:
  curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- [profile] [app-id ...]

Profiles:
  full         Daily-driver desktop, including gaming (default)
  workstation  Daily-driver desktop without gaming
  server       Command-line, development, containers, and AI tools
  custom       Install only the app IDs supplied after the profile
  select       Interactively choose app IDs from the terminal

Environment:
  DOTS_NONINTERACTIVE=1  Never prompt for anything (fails instead of asking)
  DOTS_SUDO_PASSWORD=..  Sudo password for TTY-less runs; export it before
                         piping so it reaches the script:
                           export DOTS_SUDO_PASSWORD=...
                           curl ... | bash -s -- workstation
                         Automation/tests only — an interactive terminal
                         prompts without it.
EOF
}

case "${profile}" in
  full|workstation|server)
    if [[ "$#" -gt 1 ]]; then
      usage >&2
      exit 2
    fi
    ;;
  custom)
    shift
    selected_apps=("$@")
    if [[ "${#selected_apps[@]}" -eq 0 ]]; then
      printf '%s\n' "The custom profile requires at least one application ID." >&2
      exit 2
    fi
    ;;
  select)
    if [[ ! -r /dev/tty ]]; then
      printf '%s\n' "Interactive selection requires a terminal." >&2
      exit 2
    fi

    cat >/dev/tty <<'EOF'
Available app IDs:
bash fish tmux tmux-plugin-manager kitty neovim git github-cli fzf fd
ripgrep bat eza btop fastfetch zoxide starship lazygit lazydocker tldr
clang rust dotnet-sdk luarocks mise tree-sitter-cli
firefox-developer-edition librewolf bitwarden obsidian typora
signal-desktop spotify localsend
nautilus libreoffice gnome-disk-utility gnome-calculator
mpv obs-studio kdenlive pinta xournalpp imv
virt-manager docker claude-code github-copilot-cli opencode steam herdr omp

Enter comma-separated IDs, for example:
tmux,neovim,spotify,firefox-developer-edition
EOF
    printf '%s' "Applications: " >/dev/tty
    IFS=',' read -r -a selected_apps </dev/tty
    for index in "${!selected_apps[@]}"; do
      selected_apps[$index]="${selected_apps[$index]// /}"
    done
    profile="custom"
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if [[ "${DOTS_NONINTERACTIVE:-0}" == "1" ]]; then
  sudo_options+=(--non-interactive)
fi

# Without a TTY (curl | bash, SSH without -t) sudo cannot prompt for a
# password. DOTS_SUDO_PASSWORD supplies it through a throwaway askpass
# helper. Only use this for automation; interactively, leave it unset so
# sudo prompts normally. Askpass replaces --non-interactive: sudo rejects
# the -A --non-interactive combination in a full session environment
# ("a password is required"), while askpass alone already cannot prompt.
if [[ -n "${DOTS_SUDO_PASSWORD:-}" ]]; then
  sudo_options=()
  askpass_file="$(mktemp)"
  trap 'rm -f "${extra_vars_file:-}" "${askpass_file}"' EXIT
  printf '#!/bin/sh\necho "%s"\n' "${DOTS_SUDO_PASSWORD//\"/\\\"}" >"${askpass_file}"
  chmod 700 "${askpass_file}"
  export SUDO_ASKPASS="${askpass_file}"
  sudo_options+=(-A)
fi

if [[ "$(id -u)" -eq 0 ]]; then
  printf '%s\n' "Run this bootstrap script as your normal user, not as root." >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  printf '%s\n' "This bootstrap script currently supports Arch Linux only." >&2
  exit 1
fi

if [[ "${profile}" != "server" ]]; then
  available_mb=$(df -Pm "${HOME}" | awk 'NR==2 {print $4}')
  if (( available_mb < 5120 )); then
    printf '%s\n' \
      "Only ${available_mb} MB of disk space is available under ${HOME}." \
      "AUR builds for the desktop profiles (e.g. quickshell for Caelestia)" \
      "temporarily need several GB. Free at least 5 GB, or use a profile" \
      "with fewer AUR packages:" >&2
    printf '  curl -fsSL https://raw.githubusercontent.com/erwin1122/dots/main/bootstrap.sh | bash -s -- server\n' >&2
    exit 1
  fi
fi

sudo "${sudo_options[@]}" pacman -Syu --needed --noconfirm ansible git base-devel

if [[ -d "${DESTINATION}/.git" ]]; then
  git -C "${DESTINATION}" pull --ff-only
else
  git clone "${REPOSITORY}" "${DESTINATION}"
fi

extra_vars_file="$(mktemp)"
trap 'rm -f "${extra_vars_file}"' EXIT
{
  printf 'dotfiles_user: %s\n' "${USER}"
  printf 'dotfiles_home: %s\n' "${HOME}"
  printf 'dotfiles_profile: %s\n' "${profile}"
  if [[ "${#selected_apps[@]}" -eq 0 ]]; then
    printf 'dotfiles_selected_apps: []\n'
  else
    printf 'dotfiles_selected_apps:\n'
    for app in "${selected_apps[@]}"; do
      if [[ ! "${app}" =~ ^[a-z0-9-]+$ ]]; then
        printf '%s\n' "Invalid application ID: ${app}" >&2
        exit 2
      fi
      printf '  - %s\n' "${app}"
    done
  fi
} >"${extra_vars_file}"

cd "${DESTINATION}"
sudo "${sudo_options[@]}" -i /usr/bin/env \
  "ANSIBLE_CONFIG=${DESTINATION}/ansible.cfg" \
  "ANSIBLE_ROLES_PATH=${DESTINATION}/roles" \
  /usr/bin/ansible-playbook \
  --inventory "${DESTINATION}/inventories/localhost.yml" \
  "${DESTINATION}/playbooks/arch-hyprland-caelestia.yml" \
  --extra-vars "@${extra_vars_file}"

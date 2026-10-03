# ~/.config/fish/config.fish

# Only in interactive shells
if not status is-interactive
    return
end

# Show system info on shell start (only if installed)
if type -q fastfetch
    fastfetch
end

# Cursor styles: block (blinking) in normal/visual mode, line in insert mode
set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_visual block blink
set fish_vi_force_cursor 1

# Enable vi mode (must come before all bind calls)
fish_vi_key_bindings

# Ctrl+C in insert mode: switch to normal mode (like in Neovim)
bind -M insert \cc "set fish_bind_mode default; commandline -f repaint"

# Ctrl+W: delete word backwards
bind -M insert \cw backward-kill-word

# Ctrl+Y: accept full autosuggestion (overrides default yank)
bind -M insert \cy accept-autosuggestion
# Shift+Ctrl+Y: accept next word of suggestion
# Sequence \e[89;6u is sent by Windows Terminal in CSI-u mode
bind -M insert \e\[89\;6u forward-word

# Aliases
alias ls 'ls -a --color=auto'
alias ll 'ls -l -a --color=auto'
alias grep 'grep --color=auto'
alias lg 'lazygit'
alias cl 'clear'
alias gg 'cd /mnt/c/git'

# Environment variables
set -gx NNN_OPTS "dH"
set -gx NNN_OPENER "nvim"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

# Use the windows git installation when inside the mounted C drive.
# Otherwise git operations will be very slow.
function git
    if string match -q '/mnt/c/*' (pwd -P)
        '/mnt/c/Program Files/Git/cmd/git.exe' $argv
    else
        command git $argv
    end
end

# Personal binaries (e.g. omp) + opencode
fish_add_path ~/.local/bin /home/arch/.opencode/bin

# ~/.config/fish/config.fish

# Keep tool paths dynamic and preserve paths inherited from the user's environment.
for path_entry in "$HOME/.opencode/bin" "$HOME/.local/bin" "$HOME/.local/share/mise/shims"
    if not contains -- "$path_entry" $PATH
        set -gx PATH "$path_entry" $PATH
    end
end

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

function __oc_port_available
    command python3 -c 'import socket, sys; s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); s.bind(("127.0.0.1", int(sys.argv[1]))); s.close()' $argv[1]
end

# Launch the OpenCode root TUI with a tmux-local, loopback listener.
function opencode
    set -l subcommand $argv[1]
    switch "$subcommand"
        case completion acp mcp attach run debug providers auth agent upgrade uninstall serve web models stats export import github pr session plugin plug db --help -h --version -v
            command opencode $argv
            return $status
    end

    if not set -q TMUX; or test -z "$TMUX"
        printf 'opencode: root TUI must be run inside tmux\n' >&2
        return 1
    end

    if not command -q opencode
        printf 'opencode: real opencode binary was not found on PATH\n' >&2
        return 1
    end

    set -l requested_port
    set -l port_argument_seen 0
    set -l hostname_argument_seen 0
    set -l index 1
    while test $index -le (count $argv)
        set -l argument $argv[$index]
        if test "$argument" = --port
            if test $index -eq (count $argv)
                printf 'opencode: --port requires a value\n' >&2
                return 2
            end
            if test $port_argument_seen -eq 1
                printf 'opencode: --port may be specified only once\n' >&2
                return 2
            end
            set requested_port $argv[(math $index + 1)]
            set port_argument_seen 1
            set index (math $index + 2)
            continue
        else if string match -q -- '--port=*' "$argument"
            if test $port_argument_seen -eq 1
                printf 'opencode: --port may be specified only once\n' >&2
                return 2
            end
            set requested_port (string replace -- '--port=' '' "$argument")
            set port_argument_seen 1
            set index (math $index + 1)
            continue
        else if test "$argument" = --hostname
            if test $index -eq (count $argv)
                printf 'opencode: --hostname requires a value\n' >&2
                return 2
            end
            if test $hostname_argument_seen -eq 1
                printf 'opencode: --hostname may be specified only once\n' >&2
                return 2
            end
            set hostname_argument_seen 1
            set index (math $index + 2)
            continue
        else if string match -q -- '--hostname=*' "$argument"
            if test $hostname_argument_seen -eq 1
                printf 'opencode: --hostname may be specified only once\n' >&2
                return 2
            end
            set hostname_argument_seen 1
            set index (math $index + 1)
            continue
        end
        set index (math $index + 1)
    end

    set -l port
    if test $port_argument_seen -eq 1
        if not string match -q -r '^[0-9]+$' -- "$requested_port"
            printf 'opencode: port must be an integer from 1 to 65535\n' >&2
            return 2
        end
        if not test "$requested_port" -ge 1; or not test "$requested_port" -le 65535
            printf 'opencode: port must be an integer from 1 to 65535\n' >&2
            return 2
        end
        set port "$requested_port"
        if not __oc_port_available "$port"
            printf 'opencode: port %s is already in use or unavailable\n' "$port" >&2
            return 1
        end
    else
        set -l attempts 0
        while test $attempts -lt 20
            set port (random 49152 65535)
            if __oc_port_available "$port"
                break
            end
            set attempts (math $attempts + 1)
        end
        if test $attempts -ge 20
            printf 'opencode: could not find an available loopback port after 20 attempts\n' >&2
            return 1
        end
    end

    set -lx OPENCODE_PORT "$port"
    set -l injected_arguments
    if test $hostname_argument_seen -eq 0
        set -a injected_arguments --hostname 127.0.0.1
    end
    if test $port_argument_seen -eq 0
        set -a injected_arguments --port "$port"
    end
    command opencode $injected_arguments $argv
end

# Backward-compatible name for the root TUI launcher.
function oc
    opencode $argv
end

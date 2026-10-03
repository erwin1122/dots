function n --description "nnn wrapper: cd on quit"
    # Block nesting of nnn in subshells
    if test (set -q NNNLVL; and echo $NNNLVL; or echo 0) -gt 0
        echo "nnn is already running"
        return
    end

    if set -q XDG_CONFIG_HOME
        set -gx NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    else
        set -gx NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    end

    command nnn -e $argv

    if test -f $NNN_TMPFILE
        source $NNN_TMPFILE
        rm -f -- $NNN_TMPFILE
    end
end

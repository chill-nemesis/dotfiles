# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If tmux is available, and if not in a tmux env, start tmux
# This is run before the dotfiles hook to prevent running the startup scripts twice
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
    # If we're not attached to a terminal on stdin,
    # then there's something being piped in (like a banner)
    BANNER_FILE="$(mktemp)"

    # Check if it is a login shell
    # If so, we should print that in the banner
    if shopt -q login_shell; then
        run-parts /etc/update-motd.d >>"$BANNER_FILE"
    fi

    if ! [ -t 0 ]; then
        # Append any additional banner that may be there
        cat >>"$BANNER_FILE"
    fi

    # Start tmux with the banner, and remove the banner file afterwards
    tmux new bash -c "cat \"$BANNER_FILE\"; rm -f \"$BANNER_FILE\"; exec bash"

    # Exit the original shell so we only keep the tmux session
    # TODO: keep alive flag?
    exit
fi

# load the root bashrc. This takes care of loading all other available scripts and configs
if [ -f ~/.dotfiles/.config/term/root.rc ]; then
    . ~/.dotfiles/.config/term/root.rc
fi

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
HISTCONTROL=ignoredups:erasedups

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

# If we are in an interactive shell and not within tmux, start tmux.
# Doing that before the dotfiles hook to prevent running the startup scripts twice
if [[ -z "$TMUX" ]] && [[ ! "$TERM" =~ screen ]] && command -v tmux &>/dev/null; then
    # Start tmux as the default shell
    exec tmux
else
    # ask tmux what the pane index is
    idx=$(tmux display-message -p -F "#{pane_index}")

    # Only print the banner if this is the first pane in the session
    if [[ "$idx" -eq 0 ]]; then
        run-parts /etc/update-motd.d --lsbsysinit 2>/dev/null
    fi

    # load the root bashrc. This takes care of loading all other available scripts and configs
    if [ -f ~/.dotfiles/.config/term/root.rc ]; then
        . ~/.dotfiles/.config/term/root.rc
    fi
fi

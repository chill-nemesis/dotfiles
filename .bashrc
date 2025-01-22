# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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


# load the root bashrc. This takes care of loading all other available scripts and configs
if [ -f ~/.dotfiles/.config/term/root.rc ]; then
    . ~/.dotfiles/.config/term/root.rc
fi

# If tmux is available, and if not in a tmux env, start tmux
# Technically, this means that we are running dotfiles twice (once for the "original" bash, and once for tmux)
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    # Capture the startup banner in a temporary file
    # Using a tempfile rather than storing it in a variable handles edge cases
    # (e.g., weirdly formatted text, or large text) better.
    # STARTUP_MESSAGE=$(mktemp)

    # # Check if there's input (e.g., a banner) to capture
    # if [ -t 0 ]; then
    #     # No input available, remove tempfile
    #     rm -f "$STARTUP_MESSAGE"
    # else
    #     # Capture the input into the tempfile
    #     cat > "$STARTUP_MESSAGE"
    # fi
    
    # # Default is to start a new tmux session
    # RC_TMUX_OPERATION="new"

    # # Check if the DOTFILE_TMUX_ATTACH variable is set
    # if [ -n "$DOTFILE_TMUX_ATTACH" ]; then
    #     # attach to the session provided by the user
    #     RC_TMUX_OPERATION="attach -t $DOTFILE_TMUX_ATTACH"
    # fi


    # # Start tmux and display the startup message if present

    # tmux $RC_TMUX_OPERATION 'echo "Hi :)"'

    # # Exit the initial shell after tmux finishes
    # # exit


    tmux new && exit
fi
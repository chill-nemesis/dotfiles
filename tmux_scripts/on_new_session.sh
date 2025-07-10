#!/bin/bash

# This script is executed whenever a new tmux session is created.

# only inside tmux, on a real TTY
if [[ -n "$TMUX" && -t 1 ]]; then
	# ask tmux what the pane index is
	idx=$(tmux display-message -p -F "#{pane_index}")

	# Only print the banner if this is the first pane in the session
	if [[ "$idx" -eq 0 ]]; then
		run-parts /etc/update-motd.d --lsbsysinit 2>/dev/null
	fi
fi

exec "$SHELL" --login

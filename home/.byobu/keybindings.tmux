unbind-key -n C-a
set -g prefix ^A
set -g prefix2 ^A
bind a send-prefix

# Allow C-Left/C-Right to move one word at a time.
unbind-key -n C-Left
unbind-key -n C-Right

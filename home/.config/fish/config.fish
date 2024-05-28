#! /usr/bin/fish

source "$HOME/.homesick/repos/homeshick/homeshick.fish"
source (/snap/starship/1766/bin/starship init fish --print-full-init | psub)

contains "$HOME/.cargo/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
contains "$HOME/.local/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/.local/bin" $fish_user_paths

eval (dircolors $HOME/.config/dir_colors/dircolors | head -n 1 | sed 's/^LS_COLORS=/set -x LS_COLORS /;s/;$//')

alias cat bat

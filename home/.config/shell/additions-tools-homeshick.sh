source "$SHELL_SCRIPTS_HOME/logging.sh"

if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
  source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
else
  log-warning "homeshick not installed"
fi

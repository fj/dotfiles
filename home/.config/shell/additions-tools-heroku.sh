source "$SHELL_SCRIPTS_HOME/logging.sh"

heroku_path_to_add="/usr/local/heroku/bin"
if [ -d "${heroku_path_to_add}" ]; then
  if [[ ":$PATH:" != *":${heroku_path_to_add}:"* ]]; then
    PATH="${heroku_path_to_add}:${PATH}"
  else
    log-warning "wanted to add $heroku_path_to_add but it's already there"
  fi
else
  log-warning "wanted to add $heroku_path_to_add but it's not an existing directory"
fi
export PATH

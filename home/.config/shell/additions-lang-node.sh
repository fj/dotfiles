#! /usr/bin/bash
source "$SHELL_SCRIPTS_HOME/loading.sh"

# Add node.
export NVM_DIR="$HOME/.nvm"
register-feature "ready-node" "$NVM_DIR/nvm.sh"

function npm-exec {
  (PATH=$(npm bin):$PATH; eval $@;)
}

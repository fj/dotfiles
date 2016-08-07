source "$SHELL_SCRIPTS_HOME/logging.sh"

function list-features() {
  local feature_list=$(compgen -A function | grep -oP "^load-feature-\K.*")
  for feature in $feature_list; do
    log-info "feature: $feature"
  done
}

function register-feature() {
  eval "load-feature-$1() { __load-feature \"$1\" \"$2\"; }"
  add-feature-load-hook $1
}

function add-feature-load-hook() {
  eval "$1() { load-feature-$1; remove-feature-load-hook $1; }"
}

function remove-feature-load-hook() {
  unset -f $1
  log-success "unhooked '$1' and loaded feature"
}

function __load-feature() {
  local loaded
  loaded=false
  if [[ -s "$2" ]]; then
    source $2
    loaded=true
  fi

  local feature_name
  feature_name=$1

  if $loaded; then
    log-success "feature [$feature_name] successfully loaded"
  else
    log-warning "feature [$feature_name] not available"
  fi
}

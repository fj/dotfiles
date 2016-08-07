function __colorize() {
  case $1 in
  off)          echo -n '\e[0m' ;;
  fg-red)       echo -n '\e[31m' ;;
  fg-green)     echo -n '\e[32m' ;;
  fg-yellow)    echo -n '\e[33m' ;;
  fg-blue)      echo -n '\e[34m' ;;
  fg-cyan)      echo -n '\e[36m' ;;
  fg-b-green)   echo -n '\e[1;32m' ;;
  fg-b-yellow)  echo -n '\e[1;33m' ;;
  fg-b-blue)    echo -n '\e[1;34m' ;;
  fg-b-cyan)    echo -n '\e[1;36m' ;;
  fg-b-white)   echo -n '\e[1;37m' ;;
  fg-b-red)     echo -n '\e[1;31m' ;;
  esac
}

function colorize() {
  __colorize $1

  local arg
  if [[ "$2" ]];
  then
    echo -ne "$2"
  else
    IFS= read -r arg;
    echo -ne "$arg";
  fi

  __colorize 'off'
}

function log-success() {
  log-message "$1" $(colorize 'fg-green' '✔')
}

function log-warning() {
  log-message $(colorize 'fg-red' $1) $(colorize 'fg-red' '✖')
}

function log-caution() {
  log-message "$1" $(colorize 'fg-yellow' '❗')
}

function log-info() {
  log-message "$1" $(colorize 'fg-b-cyan' '◆')
}

function log-message() {
  echo -e "    $2   $1"
}

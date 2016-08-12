# More verbose, colorful ls.
alias ls='ls -p -l --all --group-directories-first --color=auto'

function mkcd {
  if [ ! -n "$1" ]; then
    echo "missing a directory name"
  elif [ -d $1 ]; then
    echo "\'$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

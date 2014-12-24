# Add chruby.
source /usr/local/share/chruby/chruby.sh

# Add gem_home.
source /usr/local/share/gem_home/gem_home.sh

# Bundler shortcut.
alias be='bundle exec'

function rb-go() {
  chruby .
  gem_home .
}

function rb-stop() {
  gem_home -
  chruby system
}

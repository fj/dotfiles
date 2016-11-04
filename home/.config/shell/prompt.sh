#! /usr/bin/bash

#env
export TERM='xterm'

#dependencies
source "$SHELL_SCRIPTS_HOME/logging.sh"

#prompt

function __prompt_reference() {
  local r
  case $1 in
    cf_info)
      if test -e "${HOME}/.cf/config.json" ; then
        r="‹cf:$(jq --raw-output '.OrganizationFields.Name + "/" + .SpaceFields.Name' < ~/.cf/config.json)›"
      else
        unset r
      fi
      ;;
    rbenv_info)
      if test -z "$RUBY_ROOT" ; then
        unset r
      else
        local ruby_version
        ruby_version=$(basename $RUBY_ROOT)

        local ruby_gempath
        ruby_base_gempath=${GEM_PATH%%/.gem*}
        if [ ${ruby_base_gempath} == ${HOME} ]; then
          ruby_gempath="(global)"
        else
          ruby_gempath=$(basename ${ruby_base_gempath})
        fi

        r="‹ruby:${ruby_version}${ruby_gempath+@$ruby_gempath}›"
      fi
      ;;
    virtualenv_info)
      local python_virtualenv
      if test -z "$VIRTUAL_ENV" ; then
        unset r
      else
        r="‹virtualenv:$(basename "$VIRTUAL_ENV")›"
      fi
      ;;
    git_info)
      r=$(__git_ps1 | sed -e 's/^ *//g' -e 's/ *$//g')
      ;;
    userhost)
      r='\u@\h'
      ;;
    date)
      r=`date +'%Y-%m-%d'`
      ;;
    time)
      r=`date +'%H:%M:%S'`
      ;;
  esac

  echo -ne "$r"
}

function prompt_segment() {
  local segment
  segment=$(__prompt_reference $1)

  echo -ne "$segment"
}

function dashed_line_segment() {
  printf '%*s' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

function set_bash_prompt() {
  local prompt_header_elements
  declare -A element_colors

  prompt_header_elements=(
    userhost
    date
    time
  )
  prompt_lines_elements=(
    rbenv_info
    virtualenv_info
    cf_info
    git_info
  )
  element_colors[rbenv_info]='fg-red'
  element_colors[git_info]='fg-b-yellow'
  element_colors[virtualenv_info]='fg-blue'
  element_colors[cf_info]="fg-blue"
  element_colors[date]='fg-b-white'
  element_colors[time]='fg-b-white'
  element_colors[userhost]='fg-green'

  local sep
  sep=" · "

  local prompt_header
  local segment
  for e in "${prompt_header_elements[@]}"
  do
    segment=$(prompt_segment $e)
    if [[ "$segment" ]]
    then
      prompt_header="${prompt_header+$prompt_header$sep}"
      prompt_header="${prompt_header}$(colorize "${element_colors[$e]}" "$segment")"
    fi
  done

  local prompt_lines
  local prompt_line_prefix
  prompt_line_prefix="│   "
  sep="\n"
  for e in "${prompt_lines_elements[@]}"
  do
    segment=$(prompt_segment $e)
    if [[ "$segment" ]]
    then
      prompt_lines="${prompt_lines+$prompt_lines$sep}"
      prompt_lines="${prompt_lines}${prompt_line_prefix}$(colorize "${element_colors[$e]}" "$segment")"
    fi
  done

  PS1="$(dashed_line_segment)\[\e[G\]
╭── ${prompt_header}${prompt_lines+\n$prompt_lines}
│   $(pwd | colorize "fg-b-cyan")
╰─▶ ψ "
}

export GIT_PS1_SHOWDIRTYSTATE=1
PROMPT_COMMAND=set_bash_prompt



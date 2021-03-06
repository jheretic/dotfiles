# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
  # Shell is non-interactive.  Be done now
  return
fi

# Append to path without duplicates
function append_path() {
  if ! [[ $PATH =~ (^|:)$1($|:) ]] && [[ -d "$1" ]]; then
    export PATH="$PATH:$1"
  fi
}

#ENVIRONMENT
export EDITOR="vim"
export PAGER="less"
append_path "/bin"
append_path "/usr/bin"
append_path "/usr/local/bin"
append_path "/sbin"
append_path "/usr/sbin"
append_path "/usr/local/sbin"
append_path "$HOME/.local/bin"

# set vi mode
set -o vi
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Enable '**' for recursive globbing
shopt -s globstar
# smart history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#HISTORY
HISTSIZE=3000          # the bash history should save 3000 commands
HISTCONTROL=ignoreboth #no duplicates in history, commands w/ preceding space get ignored
HISTTIMEFORMAT='%F %T '
# append to the history file, don't overwrite it
shopt -s histappend
# make multi-line commands end up in the same history entry
shopt -s cmdhist

#GPG
export GPG_TTY=$(tty)
if [[ -d "$HOME/.gnupg" ]]; then
  hash "gpg-connect-agent" 2>/dev/null && gpg-connect-agent updatestartuptty /bye >/dev/null
fi
# Set SSH auth sock to point at GPG only if we're not connecting via SSH
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]] && [[ -z "$SSH_CONNECTION" ]]; then
  unset SSH_AGENT_PID
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

#PROMPTS
# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
  if hash "tput" 2>/dev/null && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

#Indymedia user prompt
function imc_prompt_command() {
  local rts=$?
  local u="\u@\h"
  local w=$(echo "${PWD/#$HOME/\~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
  # pwd max length L, prefix shortened pwd with m
  local L=45 m='<'
  ((${#w} > $L)) && {
    local n=$((${#w} - $L + ${#m}))
    local w="${m}${w:$n}"
  } ||
    local w="${w}"
  local p="(((i)))"
  PS1="${debian_chroot:+($debian_chroot )}${u}:${w} ${p} "
  case "$TERM" in
  xterm* | rxvt*)
    if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007$(__vte_osc7)"
    else
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
    fi
    ;;
  *) ;;

  esac
}

function imc_color_prompt_command() {
  local rts=$?
  local u="\[\033[1;36m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h\[\033[0m\]"
  local w=$(echo "${PWD/#$HOME/\~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
  # pwd max length L, prefix shortened pwd with m
  local L=45 m='<'
  ((${#w} > $L)) && {
    local n=$((${#w} - $L + ${#m}))
    local w="\[\033[0;32m\]${m}\[\033[1;30m\]${w:$n}\[\033[0m\]"
  } ||
    local w="\[\033[1;30m\]${w}\[\033[0m\]"
  # different colors for different return status
  (($rts == 0)) &&
    local p="\[\033[1;32m\](\[\033[0;32m\](\[\033[1;30m\](\[\033[m\]i\[\033[1;30m\])\[\033[0;32m\])\[\033[1;32m\])\[\033[m\]" ||
    local p="\[\033[1;31m\](\[\033[0;31m\](\[\033[1;30m\](\[\033[m\]i\[\033[1;30m\])\[\033[0;31m\])\[\033[1;31m\])\[\033[m\]"
  PS1="${debian_chroot:+($debian_chroot )}${u}:${w} ${p} "
  case "$TERM" in
  xterm* | rxvt*)
    if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007$(__vte_osc7)"
    else
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
    fi
    ;;
  *) ;;

  esac
}

#Acorn Active Media root prompt
function acorn_prompt_command() {
  local rts=$?
  local u="\h"
  local w=$(echo "${PWD/#$HOME/\~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
  # pwd max length L, prefix shortened pwd with m
  local L=45 m='<'
  ((${#w} > $L)) && {
    local n=$((${#w} - $L + ${#m}))
    local w="${m}${w:$n}"
  } ||
    local w="${w}"
  local p="--{D"
  PS1="${debian_chroot:+($debian_chroot )}${u}:${w} ${p} "
  case "$TERM" in
  xterm* | rxvt*)
    if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}root@${HOSTNAME}: ${PWD/$HOME/~}\007$(__vte_osc7)"
    else
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}root@${HOSTNAME}: ${PWD/$HOME/~}\007"
    fi
    ;;
  *) ;;

  esac
}

function acorn_color_prompt_command() {
  local rts=$?
  local u="\[\033[0;31m\]\h\[\033[0m\]"
  local w=$(echo "${PWD/#$HOME/\~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
  # pwd max length L, prefix shortened pwd with m
  local L=45 m='<'
  ((${#w} > $L)) && {
    local n=$((${#w} - $L + ${#m}))
    local w="\[\033[0;32m\]${m}\[\033[1;30m\]${w:$n}\[\033[0m\]"
  } ||
    local w="\[\033[1;30m\]${w}\[\033[0m\]"
  # different colors for different return status
  (($rts == 0)) &&
    local p="\[\033[1;32m\]-\[\033[1;32m\]-\[\033[1;30m\]{\[\033[0;32m\]D\[\033[m\]" ||
    local p="\[\033[1;32m\]-\[\033[1;32m\]-\[\033[1;30m\]{\[\033[0;31m\]D\[\033[m\]"
  PS1="${debian_chroot:+($debian_chroot )}${u}:${w} ${p} "
  case "$TERM" in
  xterm* | rxvt*)
    if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}root@${HOSTNAME}: ${PWD/$HOME/~}\007$(__vte_osc7)"
    else
      echo -ne "\033]0;${debian_chroot:+($debian_chroot )}root@${HOSTNAME}: ${PWD/$HOME/~}\007"
    fi
    ;;
  *) ;;

  esac
}

#VTE workaround
if [[ $TILIX_ID ]] || [[ $VTE_VERSION ]]; then
  source /etc/profile.d/vte.sh
fi

# Actually set prompts
if [[ ${EUID} == 0 ]]; then
  if [[ "$color_prompt" == yes ]]; then
    PROMPT_COMMAND=acorn_color_prompt_command
  else
    PROMPT_COMMAND=acorn_prompt_command
  fi
else
  if [[ "$color_prompt" == yes ]]; then
    PROMPT_COMMAND=imc_color_prompt_command
  else
    PROMPT_COMMAND=imc_prompt_command
  fi
fi
unset color_prompt force_color_prompt

# Load history from all sessions
PROMPT_COMMAND="$PROMPT_COMMAND; history -a; history -c; history -r"

# ALIASES
# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias diff='diff --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias zgrep='zgrep --color=auto'

  #Colorize man pages
  export LESS_TERMCAP_mb=$'\e[1;32m'
  export LESS_TERMCAP_md=$'\e[1;32m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[1;4;31m'
fi

# make less more friendly for non-text input files, see lesspipe(1)
hash "lesspipe" 2>/dev/null && eval "$(SHELL=/bin/sh lesspipe)" && export LESS=' -R '

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

# enable bash completion in interactive shells
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# if the command-not-found package is installed, use it
if [[ -x /usr/lib/command-not-found || -x /usr/share/command-not-found ]]; then
  function command_not_found_handle() {
    # check because c-n-f could've been removed in the meantime
    if [[ -x /usr/lib/command-not-found ]]; then
      /usr/bin/python /usr/lib/command-not-found -- $1
      return $?
    elif [[ -x /usr/share/command-not-found ]]; then
      /usr/bin/python /usr/share/command-not-found -- $1
      return $?
    else
      return 127
    fi
  }
elif [[ -x /usr/share/doc/pkgfile/command-not-found.bash ]]; then
  # Else we're probably on Archlinux, check for pkgfile
  source /usr/share/doc/pkgfile/command-not-found.bash
fi

# Use fuzzy finder
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

#Bauerbill wrapper
hash "bb-wrapper" 2>/dev/null && alias bb="$(which bb-wrapper) --build-dir /tmp/build"

# added by travis gem
[[ -f $HOME/.travis/travis.sh ]] && source $HOME/.travis/travis.sh

# Cargo support
hash "cargo" 2>/dev/null && append_path "$HOME/.cargo/bin"

# Force Go to stay in its lane
hash "go" 2>/dev/null && {
  export GOPATH="$HOME/.local/lib/go"
  append_path "$GOPATH/bin"
}

# Load rbenv environment
hash "rbenv" 2>/dev/null && eval "$(rbenv init -)"

# Load pyenv environment
hash "pyenv" 2>/dev/null && eval "$(pyenv init -)"

# Load nvm environment
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

#Local environment
if [[ -f ~/.bash_local ]]; then
  . ~/.bash_local
fi

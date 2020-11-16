# Load znap
source ~/.zsh/zsh-snap/znap.zsh

# Keybinding
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Apps
export EDITOR="vim"
export PAGE="less"

# Vim-style
bindkey -v

# Completion
zstyle :compinstall filename '/home/n0n/.zshrc'
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES
znap source zsh-autosuggestions

# Some basic stuff from prezto
znap source prezto modules/{environment,history}

# Syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-syntax-highlighting

# Use Znap to cache the output of slow `eval` commands:

# Color
# This runs inside the LS_COLORS repo.
znap eval LS_COLORS 'gdircolors -b LS_COLORS'
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

# enable color support of ls and also add handy aliases
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

# make less more friendly for non-text input files, see lesspipe(1)
hash "lesspipe" 2>/dev/null && eval "$(SHELL=/bin/sh lesspipe)" && export LESS=' -R '

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
elif [[ -x /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
  # Else we're probably on Archlinux, check for pkgfile
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

#Bauerbill wrapper
hash "bb-wrapper" 2>/dev/null && alias bb="$(which bb-wrapper) --build-dir /tmp/build"

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

#ALIASES
alias psgrep="ps aux | grep -v 'grep --color=auto -e %MEM' | grep -e %MEM -e"
alias modgrep="lsmod | grep -v 'grep --color=auto -e %MEM' | grep -e %MEM -e"

command -v lsd &>/dev/null && alias ls='lsd --group-dirs first'
command -v btm &>/dev/null && alias top='btm'


# History
HISTFILE=~/.histfile
HISTFILESIZE=99999
HISTSIZE=99999
SAVEHIST=99999
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Fix a broken terminal

autoload -Uz add-zsh-hook

function reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}

add-zsh-hook -Uz precmd reset_broken_terminal

# help

autoload -Uz run-help
#unalias run-help
alias help=run-help

autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn

# Directory completion

autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:*:cdr:*:*' menu selection

#alias findf=_findf #find files
alias findbig=_findbig #find large files

## finds big files (50MB with no parameter)
function _findbig() {
  local meg="${1-50}"
  find -size +$(($meg * 1024))k -exec du -h {} \; 2>/dev/null
}

# Development
#
# These don't have a repo, but the first arg will be used to name the cache file.
znap eval pyenv-init 'pyenv init -'
znap eval rbenv-init 'rbenv init -'

# added by travis gem
[[ -f $HOME/.travis/travis.sh ]] && source $HOME/.travis/travis.sh

# Cargo support
hash "cargo" 2>/dev/null && path+=$HOME/.cargo/bin

# Force Go to stay in its lane
hash "go" 2>/dev/null && {
  export GOPATH="$HOME/.local/lib/go"
  path+=$GOPATH/bin
}

# Load nvm environment
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh


eval "$(starship init zsh)"

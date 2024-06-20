if type -q mise
    mise activate fish | source
else
    if type -q pyenv
        pyenv init - | source
    end
    if type -q rbenv
        rbenv init - | source
    end
    if type -q goenv
        goenv init - | source
    end
end

set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

fish_add_path ~/.local/bin

set fish_greeting

# Set tty for GPG programs like pinentry(s)
set -x GPG_TTY (tty)

# Set SSH auth socket to point at GPG only if we're not connecting over SSH
if not set -q gnupg_SSH_AUTH_SOCK_by
    or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
    and not string length --quiet $SSH_CONNECTION
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

if type -q starship
    starship init fish | source
end

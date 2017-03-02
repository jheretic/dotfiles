#
# ~/.bash_profile
#

# Allow Screen to work with ssh-agent
test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"

# Use local node_modules bin
export PATH="$HOME/.node_modules/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc

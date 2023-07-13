function dotfiles --wraps='/usr/bin/git --git-dir=/home/n0n/.dotfiles --work-tree=/home/n0n' --description 'alias dotfiles /usr/bin/git --git-dir=/home/n0n/.dotfiles --work-tree=/home/n0n'
  /usr/bin/git --git-dir=/home/n0n/.dotfiles --work-tree=/home/n0n $argv
        
end

install: install-bash install-vim install-top install-screen install-x install-directories install-screen install-git

install-bash:
	ln -sf `pwd`/files/.bashrc ~/.bashrc
	ln -sf `pwd`/files/.bash_profile ~/.bash_profile
	ln -sf `pwd`/files/.bash_aliases ~/.bash_aliases
	mkdir -p ~/.config/environment.d
	ln -sf `pwd`/files/.config/environment.d/99-envvars.conf ~/.config/environment.d/99-envvars.conf

install-vim:
	mkdir -p ~/.config/nvim
	ln -sf `pwd`/files/.config/nvim/init.vim ~/.config/nvim/init.vim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

install-top:
	ln -sf `pwd`/files/.toprc ~/.toprc

install-screen:
	ln -sf `pwd`/files/.screenrc ~/.screenrc

install-x:
	ln -sf `pwd`/files/.Xdefaults ~/.Xdefaults
	ln -sf `pwd`/files/.xprofile ~/.xprofile

install-apps:
	mkdir -p ~/.local/share/applications

install-directories:
	mkdir -p ~/aud ~/doc/templates ~/emu ~/img ~/net/torrents ~/pub ~/src/scratch ~/top ~/vid/{tv,movies,trailers,music_videos} ~/www ~/.bak ~/.tmp ~/.config
	ln -sf `pwd`/files/.config/user-dirs.dirs ~/.config/user-dirs.dirs
	ln -sf `pwd`/files/.config/user-dirs.locale ~/.config/user-dirs.locale

install-git:
	ln -sf `pwd`/files/.gitignore_global ~/.gitignore_global

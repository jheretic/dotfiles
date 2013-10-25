install: install-bash install-vim install-top install-x install-directories \
			install-screen

install-bash:
	ln -sf `pwd`/files/.bashrc ~/.bashrc
	ln -sf `pwd`/files/.bash_profile ~/.bash_profile
	ln -sf `pwd`/files/.bash_aliases ~/.bash_aliases

install-vim:
	ln -sf `pwd`/files/.vimrc ~/.vimrc
	mkdir ~/.vim/bundle
	git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

install-top:
	ln -sf `pwd`/files/.toprc ~/.toprc

install-screen:
	ln -sf `pwd`/files/.screenrc ~/.screenrc

install-x:
	ln -sf `pwd`/files/.Xdefaults ~/.Xdefaults
	ln -sf `pwd`/files/.xprofile ~/.xprofile

install-apps:
	mkdir -p ~/.local/share/applications
	ln -sf `pwd`/files/.local/share/applications/firefox-test.desktop ~/.local/share/applications/firefox-test.desktop

install-directories:
	mkdir -p ~/aud ~/bin ~/cds ~/doc/templates ~/emu ~/img ~/lib ~/net/torrents ~/pub ~/src/scratch ~/top ~/vid/{tv,movies,trailers,music_videos} ~/www ~/.bak ~/.tmp ~/.config 
	ln -sf `pwd`/files/.config/user-dirs.conf ~/.config/user-dirs.conf
	ln -sf `pwd`/files/.config/user-dirs.locale ~/.config/user-dirs.locale

sync:
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.config/nvim

	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.config/nvim/init.vim ] || ln -s $(PWD)/vimrc ~/.config/nvim/init.vim
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.bashrc ] || ln -s $(PWD)/bashrc ~/.bashrc
	[ -f ~/.bash_profile ] || ln -s $(PWD)/bashprofile ~/.bash_profile
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	rm -f ~/.tmux.conf
	rm -f ~/.git-prompt.sh

.PHONY: all clean sync build run kill

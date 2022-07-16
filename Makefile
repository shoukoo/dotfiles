brew-dump:
	brew bundle dump

brew-list:
	brew outdated


sync:
	mkdir -p ~/Code/shoukoo
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/lazygit
	mkdir -p ~/.config/fish

	# Go stuff
	go install github.com/jesseduffield/lazygit@latest

	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/bin/fts ] || ln -s $(PWD)/fts ~/bin/fts
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua
	[ -d ~/.vsnip ] || ln -s $(PWD)/vsnip ~/.vsnip
	[ -f ~/.rubocop.yml ] || ln -s $(PWD)/rubocop.yml ~/.rubocop.yml
	[ -f ~/.config/lazygit/config.yml ] || ln -s $(PWD)/lazygit.conf ~/.config/lazygit/config.yml
	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/config.fish ~/.config/fish/config.fish
	[ -d ~/.config/fish/functions ] || ln -s $(PWD)/functions ~/.config/fish/functions
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/neovim.lua ~/.config/nvim/init.lua

	# Krew
	kubectl krew install < krew.txt

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.tmux.conf
	rm -f ~/.git-prompt.sh
	rm -f ~/.rubocop.yml
	rm -f ~/bin/fts
	rm -rf ~/.config/nvim/lua
	rm -rf ~/.vsnip
	rm -rf ~/.config/lazygit/config.yml

.PHONY: all clean sync build run kill

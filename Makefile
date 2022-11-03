brew-dump:
	brew bundle dump

brew-list:
	brew outdated


sync:
	mkdir -p ~/Code/shoukoo
	mkdir -p ~/bin
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/lazygit

	[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	[ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ] || git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
	[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/bin/fts ] || ln -s $(PWD)/fts ~/bin/fts
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua
	[ -d ~/.vsnip ] || ln -s $(PWD)/vsnip ~/.vsnip
	[ -f ~/.rubocop.yml ] || ln -s $(PWD)/rubocop.yml ~/.rubocop.yml
	[ -f ~/.config/lazygit/config.yml ] || ln -s $(PWD)/lazygit.conf ~/.config/lazygit/config.yml
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/neovim.lua ~/.config/nvim/init.lua

	# go
	go install github.com/justjanne/powerline-go@latest
	go install github.com/jesseduffield/lazygit@latest

	# Krew
	kubectl krew install < krew.txt

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.tmux.conf
	rm -f ~/.git-prompt.sh
	rm -f ~/.rubocop.yml
	rm -f ~/bin/fts
	rm -rf ~/.config/nvim/lua
	rm -rf ~/.vsnip
	rm -rf ~/.config/lazygit/config.yml
	rm -f ~/.zshrc

.PHONY: all clean sync build run kill

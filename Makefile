brew-dump:
	brew bundle dump --force

brew-list:
	brew outdated

nix-rebuild:
	# Must use --impure since the private.nix is outside of the repo
	darwin-rebuild switch --flake .#darwin --impure

sync:
	mkdir -p ~/Code/shoukoo
	mkdir -p ~/bin
	mkdir -p ~/.config/wezterm
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/lazygit
	mkdir -p ~/.config/zellij/plugins
	mkdir -p ~/.config/ghostty



	[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	[ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ] || git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
	[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.gitignore ] || ln -s $(PWD)/gitignore ~/.gitignore
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/bin/fts ] || ln -s $(PWD)/fts ~/bin/fts
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua
	[ -d ~/.vsnip ] || ln -s $(PWD)/vsnip ~/.vsnip
	[ -f ~/.rubocop.yml ] || ln -s $(PWD)/rubocop.yml ~/.rubocop.yml
	[ -f ~/.config/lazygit/config.yml ] || ln -s $(PWD)/lazygit.conf ~/.config/lazygit/config.yml
	[ -f ~/.config/wezterm/wezterm.lua ] || ln -s $(PWD)/wezterm.lua ~/.config/wezterm/wezterm.lua
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/neovim.lua ~/.config/nvim/init.lua
	[ -f ~/.config/zellij/config.kdl ] || ln -s $(PWD)/zellij.kdl ~/.config/zellij/config.kdl
	[ -f  ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty ~/.config/ghostty/config

	# go
	go install github.com/justjanne/powerline-go@bedd965
	go install github.com/jesseduffield/lazygit@latest

  # git
	git config --global core.excludesfile ~/.gitignore

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -rf ~/.config/zellij/config.kdl
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/wezterm/wezterm.lua
	rm -f ~/.git-prompt.sh
	rm -f ~/.rubocop.yml
	rm -f ~/bin/fts
	rm -rf ~/.config/nvim/lua
	rm -rf ~/.vsnip
	rm -rf ~/.config/lazygit/config.yml
	rm -f ~/.zshrc
	rm -f ~/.gitignore
	rm -f ~/.config/ghostty/config

.PHONY: all clean sync build run kill

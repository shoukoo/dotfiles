{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    maybeImport = path: if builtins.pathExists path then import path else {};
    #privateConfig = import (builtins.toPath ./private.nix);
    privateConfig = maybeImport "${builtins.getEnv "HOME"}/.config/nix/private.nix";
    configuration = { pkgs, ... }: {

     # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.age
          pkgs.awscli
          pkgs.poetry
          pkgs.nodejs_18
          pkgs.pyenv
          pkgs.python39
          pkgs.python311
          pkgs.coreutils
          pkgs.curl
          pkgs.delve
          pkgs.direnv
          pkgs.fzf
          pkgs.go
          pkgs.gum
          pkgs.htop
          pkgs.jq
          pkgs.jqp
          pkgs.lua
          pkgs.lua-language-server
          pkgs.neovim
          pkgs.ripgrep
          pkgs.sqlite
          pkgs.tree
          pkgs.zellij
          pkgs.zig
          pkgs.zls
        ];

      system.defaults = {
        dock = {
          autohide = true;
          tilesize = 48;
        };

        # Mouse tracking speed 
        ".GlobalPreferences"."com.apple.mouse.scaling" = 1.5;

        universalaccess = {
          reduceMotion = true;
          reduceTransparency = true;
        };

        NSGlobalDomain = {
          AppleShowAllExtensions = false;
          # Disable natural scrolling
          "com.apple.swipescrolldirection" = false;
        };

        # Display sound in the menu
        controlcenter.Sound = true;

        #finder doesn't seem to work
        #finder.FXPreferredViewStyle = "clmv";
        #finder.AppleShowAllExtensions = false;

      };

      # Homebrew needs to be installed on its own!
      homebrew.enable = true;
      homebrew.onActivation.cleanup = "uninstall";
      homebrew.taps = [
        "nikitabobko/tap"
      ];
      homebrew.casks = [
        "1password"
        "arc"
        "cold-turkey-blocker"
        "homerow"
        "firefox"
        "ghostty"
        "maccy"
        "wireshark"
        "aerospace"
      ];


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."darwin" = nix-darwin.lib.darwinSystem {
      modules = [ configuration privateConfig ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."darwin".pkgs;
  };
}

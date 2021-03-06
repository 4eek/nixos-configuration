{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    # Aliases
    shellAliases = {
      c = "clear";
      lg = "lazygit";
      #vim = "nvim";
      vi = "vim";
      e = "nvim";
      tf = "terraform";
      tw = "timew";
      rr = "ranger";

      l = "exa";
      ls = "exa";
      ll = "exa -l";
      lll = "exa -la";
      grv = "grv";
    };
    # Clear this to avoid a conflict with oh-my-zsh
    #promptInit = "";
    promptInit = ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
    # Enable oh-my-zsh
    ohMyZsh = {
      enable = true;
      theme = "spaceship";
      plugins = [
        "aws"
        "command-not-found"
        "common-aliases"
        "composer"
        "dircycle"
        "docker"
        "docker-compose"
        "docker-machine"
        "fasd"
        "git"
        "gitfast"
        "git-extras"
        "github"
        "golang"
        "helm"
        "history-substring-search"
        "kops"
        "kubectl"
        "mix"
        "node"
        "minikube"
        "npm"
        "postgres"
        "rebar"
        "ripgrep"
        "rust"
        "react-native"
        "systemd"
        "taskwarrior"
        "terraform"
        "tig"
        "tmux"
        "tmuxinator"
        "vagrant"
        "vi-mode"
        "web-search"
        "yarn"
        "zsh_reload"
      ];
      customPkgs = with pkgs; [
        spaceship-prompt
      ];
    };
    # Custom .zshrc type setup
    interactiveShellInit = ''
      # z - jump around
      source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
      export EDITOR='nvim'
      export SSH_ASKPASS='/run/current-system/sw/bin/ksshaskpass'
      export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

      nixify() {
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi
        if [ ! -e default.nix ]; then
          cat > default.nix <<'EOF'
      let
        # unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
        unstable = import <nixos-unstable> {};
      in
        with import <nixpkgs> {};
        stdenv.mkDerivation {
          name = "env";
          buildInputs = [
            unstable.gitFull
          ];
        }
      EOF
          $EDITOR default.nix
        fi
      }

      timew
      task
    '';
  };
}

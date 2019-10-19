{ config, pkgs, ... }:

{	
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    # Aliases 
    shellAliases = { 
      c = "clear";
      lg = "lazygit";
      vim = "nvim";
      vi = "vim";
      tf = "terraform";

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
      theme = "robbyrussell";
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
        "git-extras"
        "github"
        "golang"
        "helm"
        "history-substring-search"
        "kops"
	"kube-ps1"
        "kubectl"
        "mix"
	"nix-shell"
        "node"
        "npm"
        "postgres"
        "rust"
        "react-native"
        "tmux"
        "tmuxinator"
        "vagrant"
        "vi-mode"
        "web-search"
        "yarn"
        "zsh-autosuggestions"
        "zsh-completions"
        "zsh_reload"
      ];
    };
    # Custom .zshrc type setup
    interactiveShellInit = ''
      # z - jump around
      source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
      export PROMPT=$PROMPT'$(kube_ps1) '
      export EDITOR='nvim'
    '';
  };
}

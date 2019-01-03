{ config, pkgs, ... }:

{	
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    # bind vi to vim because vim_configurable is used and doesn't provide vi
    shellAliases = { vi = "vim"; };
    # Clear this to avoid a conflict with oh-my-zsh
    promptInit = "";
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
        "kubectl"
        "mix"
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
  };
}

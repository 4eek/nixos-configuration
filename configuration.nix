# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Modules to include
      ./bluetooth.nix
      ./fonts.nix
      ./zsh.nix
      #./k8s.nix
      #./ipfs.nix
    ];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Enable OpenGL support
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Make your audio card the default ALSA card
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

  # Disable PC Speaker "audio card"
  boot.blacklistedKernelModules = [ "snd_pcsp" "nouveau" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Mount our encrypted partition before looking for LVM
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/42f39571-ac38-4678-9fd0-4c2dd067efd2";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  networking.hostName = "dukuduku"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  nixpkgs.config = {
    # Allow unfree so we can get firefox-dev, etc.
    allowUnfree = true;
    # Allow usage of packages from nixos-unstable
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [
    ag
    unstable.any-nix-shell
    arandr
    aria2
    ark
    aspell
    aspellDicts.en
    awscli
    bind
    cabal2nix
    cabal-install
    calibre
    cargo
    chromium
    google-chrome
    cifs-utils
    cryptsetup
    dialog
    direnv
#    dmenu
    unstable.dropbox
    emacs
    encfs
    evince
    exa
    exfat
    fasd
    feh
    ffmpeg
    firefox
    firefox-devedition-bin
    frei0r
    fzf
    gcc
    gettext
    ghc
    gitAndTools.gitFull
    gitAndTools.git-extras
    gitAndTools.gita
    gitAndTools.hub
    gitAndTools.lab
    gitAndTools.tig
    gitAndTools.gitAnnex
    gitAndTools.diff-so-fancy
    gitAndTools.grv
    unstable.git-repo-updater
    gnumake
    gnupg
    go
    unstable.helmfile
    htop
    inotify-tools
    jq
    jnettop
    kbfs
    ksshaskpass
    kdenlive
    kdiff3
 #   keychain
    keybase
    keybase-gui
    unstable.kgpg
    kops
    krita
    unstable.kubectl
#    kubernetes
    unstable.kubernetes-helm
    libreoffice
    lsof
    maim
    marble
    mc
    unstable.minikube
    mongodb
    nox
    unstable.mongodb-compass
    neovim
    networkmanagerapplet
    nix-prefetch-scripts
    nodejs
    nodePackages.eslint
    nmap
    unstable.nnn
    obs-studio
    octave
    openarena
    openconnect
    openconnect_openssl
    openvpn
    pass
    unstable.postman
    powertop
    unstable.protonvpn-cli
    qtpass
    ranger
    #unstable.rescuetime
    ripgrep
    rustc
    rustup
    rxvt_unicode-with-plugins
    scrot
    unstable.signal-desktop
    slack
    slop
    sops
    spectacle
#    stalonetray
    unstable.standardnotes
    sqlite
    unstable.tdesktop
    unstable.terminator
#    termite
    terraform_0_12
    thunderbird
    tigervnc
    tmux
    tree
    udisks2
    unzip
    upower
#    vagrant
    unstable.vscode
    (
      import ./vim.nix
    )
#    unstable.virtualbox
    vlc
    wget
    which
    xcompmgr
    xorg.xbacklight
    xclip
    xorg.xev
    xscreensaver
    yarn
    zathura
    zeal
    zoom-us
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Enable virtualisation - otherwise get missing vboxdrv error
  virtualisation.virtualbox.host.enable = true;

  # Enable upower service - used by taffybar's battery widget
  services.upower.enable = true;
  powerManagement.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # The locate service for finding files in the nix-store quickly.
  services.locate.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Avahi is used for finding other devices on the network.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable TLP for optimal power saving
  services.tlp.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  #services.xserver.desktopManager.default = "none";
  #services.xserver.desktopManager.xterm.enable = false;
  # Try SLiM as the display manager
  #services.xserver.displayManager.slim.defaultUser = "kgf";
  # services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.sessionCommands = ''
  #  ${pkgs.xlibs.xset}/bin/xset r rate 200 60  # set the keyboard repeat rate
  #  ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr # Set cursor
    #${pkgs.feh}/bin/feh --no-fehbg --bg-tile ~/background.png &
  #'';
  services.xserver.xkbOptions = "ctrl:nocaps";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable xmonad
  #services.xserver.windowManager.default = "xmonad";
  #services.xserver.windowManager.xmonad = {
  #  enable = true;
  #  enableContribAndExtras = true;
  #};

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable Emacs Server
  services.emacs.enable = true;

  # Enable Postgesql service
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_11;
  services.postgresql.authentication = lib.mkForce ''
    # Generated file; do not edit!
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            trust
    host    all             all             ::1/128                 trust
  '';

  # Enable Keybase services
  services.keybase.enable = true;
  services.kbfs.enable = true;

  # Enable docker for container management.
  # This only enables the service, but does not add users to the docker group.
  virtualisation.docker.enable = true;

  # Enable Kubernetes
#  services.kubernetes = {
#    roles = ["master" "node"];
#    masterAddress = "dukuduku";
#    #kubelet.extraOpts = "--fail-swap-on=false";
#  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.extraUsers.kgf = {
    createHome = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "docker"];
    group = "users";
    home = "/home/kgf";
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

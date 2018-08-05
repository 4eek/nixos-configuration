# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Modules to include
      ./bluetooth.nix
      ./fonts.nix
      ./zsh.nix
      ./ipfs.nix
    ];

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
  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Mount our encrypted partition before looking for LVM
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  networking.hostName = "dukuduku"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Allow unfree so we can get firefox-dev, etc.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [
    ag
    arandr
    aria2
    aspell
    aspellDicts.en
    awscli
    beam.packages.erlangR20.elixir
    bind
    cabal2nix
    cabal-install
    calibre
    cargo
    chromium
    cifs-utils
    cryptsetup
    direnv
    dmenu
    emacs
    encfs
    evince
    exfat
    feh
    firefox
    firefox-devedition-bin
    gcc
    gettext
    ghc
    git
    gitAndTools.hub
    gitAndTools.tig
    gnumake
    gnupg
    go
    kubectl
    kubernetes
    kubernetes-helm
    htop
    inotify-tools
    jnettop
    kdiff3
    keychain
    libreoffice
    lsof
    maim
    minikube
    neovim
    networkmanagerapplet
    nix-prefetch-scripts
    nix-repl
    nix-zsh-completions
    nodejs
    octave
    oh-my-zsh
    openarena
    openconnect
    openconnect_openssl
    pass
    powertop
    qtpass
    ranger
    rustc
    rustup
    rxvt_unicode-with-plugins
    scrot
    slop
    spectacle
    stalonetray
    sqlite
    terminator
    termite
    thunderbird
    tigervnc
    tmux
    tree
    udisks2
    unzip
    upower
    vagrant
    vim
    virtualbox
    vlc
    wget
    which
    xcompmgr
    xfce.thunar
    xorg.xbacklight
    xclip
    xorg.xev
    xscreensaver
    zathura
    zeal
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-navigation-tools

    # For clipboard syncing
    xsel
    #parcellite
    xdotool
  ]) ++
  (with pkgs.haskellPackages; [
    stylish-haskell
    xmobar
    # apply-refact
    hlint
    # hasktags
    hoogle
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.xterm.enable = false;
  # Try SLiM as the display manager
  #services.xserver.displayManager.slim.defaultUser = "kgf";
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xlibs.xset}/bin/xset r rate 200 60  # set the keyboard repeat rate
    ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr # Set cursor
    #${pkgs.feh}/bin/feh --no-fehbg --bg-tile ~/background.png &
  '';
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
  services.postgresql.package = pkgs.postgresql100;
  services.postgresql.authentication = lib.mkForce ''
    # Generated file; do not edit!
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            trust
    host    all             all             ::1/128                 trust
  '';

  # Enable docker for container management.
  # This only enables the service, but does not add users to the docker group.
  virtualisation.docker.enable = true;

  # Enable Kubernetes
#  services.kubernetes = {
#    roles = ["master" "node"];
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
  system.nixos.stateVersion = "17.09"; # Did you read the comment?

}

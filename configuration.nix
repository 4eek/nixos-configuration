# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
with pkgs;
let
  unstableTarball =
    fetchTarball
    https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

  my-python-packages = python-packages: with python-packages; [
    toolz
    packaging
    setuptools
    bugwarrior
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
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
      ./ipfs.nix
    ];

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  # ZFS
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostName = "speskop";
  networking.hostId = "abcdef01";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.extraHosts =
  ''
    52.215.250.255 privyseal-docker1
    54.154.251.216 privyseal-docker2
  '';

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s20f0u2u4.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Nixos nixpkgs config.
  nixpkgs.config = {
    # Allow unfree so we can get firefox-dev, etc.
    allowUnfree = true;
    #allowBroken = true;
    # Allow usage of packages from nixos-unstable
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  # Enable periodic automatic GC.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable Syncthing.
  services.syncthing = {
      enable = true;
      dataDir = "/home/kgf/Desktop/Syncthing";
      configDir = "/home/kgf/.config/syncthing";
      user = "kgf";
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
  };


  # Enable TOR.
  # services.tor = {
  #     enable = true;
  #     client.enable = true;
  #     controlPort = 9051;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ag
    unstable.alacritty
    unstable.any-nix-shell
    unstable.android-studio
    arandr
    aria2
    ark
    unstable.asciinema
    aspell
    aspellDicts.en
    ansible
    awscli
    bind
    # unstable.binutils
    unstable.brave
    unstable.broot
    cabal2nix
    cabal-install
    calibre
    unstable.ccache
    # chromium
    # google-chrome
    cifs-utils
    cryptsetup
    unstable.dbeaver
    dialog
    direnv
    unstable.discord
    # dmenu
    unstable.doas
    unstable.dropbox
    unstable.dropbox-cli
    # emacs
    encfs
    evince
    exa
    exfat
    fasd
    # feh
    ffmpeg
    unstable.firefox
    # firefox-devedition-bin
    frei0r
    fzf
    gcc
    gettext
    ghc
    unstable.gimp-with-plugins
    unstable.gitAndTools.gitFull
    unstable.gitAndTools.git-extras
    unstable.gitAndTools.gita
    unstable.gitAndTools.lab
    unstable.gitAndTools.hub
    unstable.gitAndTools.tig
    unstable.gitAndTools.gitAnnex
    unstable.gitAndTools.diff-so-fancy
    gitAndTools.grv
    unstable.git-repo-updater
    glxinfo
    gnumake
    unstable.gnumeric
    gnupg
    go
    unstable.helmfile
    htop
    # START image_optim
    unstable.image_optim
    unstable.advancecomp
    unstable.gifsicle
    unstable.jhead
    unstable.jpegoptim
    unstable.libjpeg
    unstable.optipng
    unstable.pngcrush
    unstable.pngout
    unstable.pngquant
    # unstable.svgo
    # END
    unstable.inkscape
    iftop
    inotify-tools
    unstable.isync
    # unstable.jetbrains.datagrip
    jq
    jnettop
    ksshaskpass
    kdenlive
    kdiff3
    # keychain
    # unstable.kbfs
    # unstable.keybase
    keybase-gui
    unstable.kgpg
    # kops
    krita
    unstable.kubectl
    # kubernetes
    # unstable.kubernetes-helm
    libreoffice
    links
    # unstable.llvm_10
    lsof
    maim
    marble
    mc
    unstable.minikube
    mongodb
    unstable.neomutt
    unstable.notmuch
    unstable.notmuch-mutt
    nox
    unstable.mongodb-compass
    (
      import ./neovim.nix
    )
    networkmanagerapplet
    unstable.ninja
    nix-prefetch-scripts
    nodejs
    nodePackages.eslint
    nmap
    unstable.nnn
    unstable.obs-studio
    # octave
    okular
    openarena
    openconnect
    openconnect_openssl
    openvpn
    pass
    pciutils
    # unstable.pgadmin
    # unstable.pgmanage
    unstable.pinentry
    unstable.pinentry-qt
    unstable.poppler_utils
    unstable.postman
    unstable.powertop
    python-with-my-packages
    unstable.protonvpn-cli
    unstable.qemu_kvm
    # qtpass
    ranger
    # unstable.rescuetime
    ripgrep
    rxvt_unicode-with-plugins
    unstable.s3fs
    scrot
    unstable.siege
    unstable.signal-desktop
    unstable.simplescreenrecorder
    slack
    slop
    sops
    spectacle
    # stalonetray
    unstable.standardnotes
    sqlite
    unstable.syncthing
    unstable.taskwarrior
    unstable.tdesktop
    unstable.terminator
    # termite
    # unstable.terraform
    thunderbird
    tigervnc
    unstable.timewarrior
    tmux
    unstable.todoist
    unstable.tor-browser-bundle-bin
    tree
    unstable.tsung
    udisks2
    unzip
    # vagrant
    unstable.veracrypt
    unstable.vscode-with-extensions
    (
      import ./vim.nix
    )
    # unstable.virtualbox
    unstable.vit
    vlc
    # unstable.wasm-pack
    unstable.wireguard
    unstable.wireguard-tools
    wget
    which
    (wine.override { wineBuild = "wineWow"; })
    xcompmgr
    xorg.xbacklight
    xclip
    unstable.libxml2 # xmllint
    xorg.xev
    xscreensaver
    yarn
    zathura
    zeal
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.gnupg.agent = { enable = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # services.openssh.permitRootLogin = "yes";
  programs.ssh.startAgent = true;

  # Enable virtualisation - otherwise we get missing vboxdrv error
  virtualisation.virtualbox.host.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # The locate service for finding files in the nix-store quickly.
  services.locate.enable = true;

  # Avahi is used for finding other devices on the network.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable upower service
  services.upower.enable = true;
  powerManagement.enable = true;

  # Enable TLP for optimal power saving
  services.tlp.enable = true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;

  # To perform firmware upgrades just activate the service.
  # Then use fwupdmgr to perform updates.
  services.fwupd.enable = true;

  # Enable OpenGL support
  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  hardware.opengl = {
    enable = true;
    package = (pkgs.mesa.override {
      galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
    }).drivers;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
   driSupport32Bit = true;
   extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Make your audio card the default ALSA card
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

  # Disable PC Speaker "audio card"
  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.dpi = 96;
  # services.xserver.xkbOptions = "eurosign:e";
  # services.xserver.xkbOptions = "caps:swapescape";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable Emacs Server
  # services.emacs.enable = true;

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
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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

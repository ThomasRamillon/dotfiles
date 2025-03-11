# Edit thi configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "systematr"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

 

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };


  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # AutoStart
  services.getty.autologinUser = "thomax";
  services.getty.autologinOnce = true;  

# HYPRLAND  
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  # Lancement automatique au boot
  environment.etc."profile.local" = {
    text = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        exec Hyprland
      fi
    '';
    mode = "0755";
  };

  # demons pour usb
  # services.devmon.enable = false;
  # services.gvfs.enable = false;
  # services.udisks2.enable = false;

  # Enable sound with pipewire.

  #services.xserver.videoDrivers = [ "radeon" ];
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomax = {
    isNormalUser = true;
    description = "Thomas";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [ ];
  };
  
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "image/png" = "code";
    "inode/directory" = "nnn";
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unree packages
  nixpkgs.config.allowUnfree = true;


  # package pour hashcat
#  hardware.graphics = {
#    enable = true;
    #driSupport = true;
#    enable32Bit = true;
#  };
  # pour hashcat aussi 
#  hardware.opengl.extraPackages = with pkgs; [
#    rocm-opencl-icd
#    rocm-opencl-runtime
#  ];
  
  # DOCKER
  #virtualisation.docker.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
  #inputs.zen-browser.packages."${system}".twilight  
  ## SYSTEME ET LIBS ##
  pipewire
  wireplumber
  brightnessctl
  pulseaudio
  networkmanager
  ntfs3g # pour mount windows
  stdenv.cc.cc.lib # il y a une dependance nécessaire pour import numpy dans un venv 
  zlib # probablement une lib nécessaire
  glib  
  networkmanagerapplet #for nm-applet & tray dans waybar
  gcc # compilateur
  # fish (remplace bash)
  libnotify # pour tester mako (marche pas)
  
  
  ## CLI APP ##
  vim
  nnn
  curl
  unzip
  openssl
  xorg.xev
  inetutils # telnet notamment    
  htop # voir l'utilisation des ressources
  lshw # voir tout ce qui est hardware
  neofetch # voir le logo nix
  nvtopPackages.amd
  ## TNCY ##
  git
  gitflow # git enhanced
  python3Full  
  sqlite
  openssl # cryptage notamment
  hashcat # craquer des mdp
  #gnupg # pour signer des docs; broken sur nixos

  clang # compilateur
  gnumake 
  # jdk17 # java
  openconnect

  ## GUI APP ##
  vscode
  kitty # terminal 
  obsidian  
  wofi
  godot_4
  discord-ptb
  #ungoogled-chromium
  ghostty
  # proton-pass  
  # (callPackage ./packages/zen.nix {})
  
  ## hypr ##
  waybar
  hyprpaper
  hyprlock
  hyprpicker # marche pas 
  hyprshot 
  # hyprsunset
  mako # demon notification
 
];


  fonts.packages = with pkgs; [
  font-awesome
  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "NerdFontsSymbolsOnly" ]; })  
 ];
  

  # pour gpg
#  services.pcscd.enable = true;
#  programs.gnupg.agent = {
#   enable = true;
#   pinentryPackage = pkgs.pinentry-curses;
#   enableSSHSupport = true;
#  };

  # pour avoir acces a des librairies de base :)  
#  environment = {
#    sessionVariables = {
#      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib;${pkgs.zlib}/lib";
#    };
#  };


  # CIL alias, pour aller plus vite 
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild";
    bn = "shutdown 0";
    poubelle = "nix-collect-garbage";
    nixconf = "sudo nano /etc/nixos/configuration.nix";
    nixhw = "sudo nano /etc/nixos/harware-configuration.nix";
    wount = "sudo mount /dev/nvme0n1p3 ~/win";
    uwount = "sudo umount ~/win";
  };  


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  system.stateVersion = "24.11";

}

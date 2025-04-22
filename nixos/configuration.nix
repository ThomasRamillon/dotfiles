# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, inputs,  ...}:

{

  # FLAKES
  nix = {
    # package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }; 
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  

  imports =
    [ # Include the results of the hardware scan.
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

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

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
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomax = {
    isNormalUser = true;
    description = "toaaaa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages =  with pkgs; [
    inputs.zen-browser.packages."${system}".default

    ## SYS ##
    brightnessctl
    ntfs3g # mount windows
    neofetch # distro logo
    hollywood
    lshw # info hardware
    xorg.xev 
    pulseaudio #provides pactl
    playerctl

    ## CL ##
    unzip
    zip
    nix-index

    ## TUI ##
    btop # task manager
    # nnn # file explorer
    ranger 
    clipse 

    ## GUI ##
    ghostty
    vscode
    discord-ptb
    obsidian 
    #godot-4
    spotify
    kitty

    ## HYPR ## 
    hyprpaper
    hyprlock
    mako
    waybar 
    hyprpicker
    hyprshot 
    hypridle
    hyprpolkitagent
 
    ## TNCY ##
    git
    gitflow 
    python3Full
    clang 
    gnumake
    jdk21 #java
    jetbrains.idea-community #ide java
    bc #calculator
    libgcc # g++ 
    wireshark
    wget # telecharge un fichier à un adresse donnée
   
    ## LIB ##
    zlib
    zlib-ng
    gcc
  ];
  
  # Son
  services.pipewire.pulse.enable = true;
  #hardware.pulseaudio.enable = true;
  

  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
    firefox.enable = true;
  };


  # fonts.packages = with pkgs; [
  #   nerdfonts
    
  # ];
  
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild --flake /etc/nixos";
    bn = "shutdown 0";
    re = "reboot";
    poubelle = "sudo nix-collect-garbage -d";
    flocon = "sudo nix flake";
    nixconf = "sudo nano /etc/nixos/configuration.nix";
    nixhw = "sudo nano /etc/nixos/harware-configuration.nix";
    wount = "sudo mount /dev/nvme0n1p3 ~/win";
    uwount = "sudo umount ~/win";
    nixsh = "nix-shell";
  };  

  
  services.jack = {
    jackd.enable = true;
    alsa.enable = true;
  };
  
  # AutoStart
  services.getty.autologinUser = "thomax";
  services.getty.autologinOnce = true; 
  
  environment.etc."profile.local" = {
    text = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        exec Hyprland
      fi
    '';
  };

#  gtk = {
#    enable = true;
#    theme = { 
#      name = "Adwaita-dark";
#      package = pkgs.gnome.gnome-themes-extra;
#    };
#  };

  # donne accès à certaines lib essentielles (path dédié) 
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
    };
  };

  
  qt = {
    enable = true;
    #platformTheme = "gnome";
    style = "adwaita-dark";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}

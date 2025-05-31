# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, inputs, lib,  ...}:

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "systematr"; # nom de la machine systmateur mieux non?

  networking.networkmanager.enable = true;


  time.timeZone = "Europe/Paris";

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

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console.keyMap = "fr";

  users.users.thomax = {
    isNormalUser = true;
    description = "toaaaa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
  };


  nixpkgs.config.allowUnfree = true;
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
    kitty # ghostty tweaks with ncurse
    libsForQt5.dolphin
    # kdePackages.qtsvg # idk 

    twitch-tui # chat in terminal
    streamlink # put livestream into videoplayer
    celluloid # video player
    mpv # video player but simpler



    ## HYPR ## 
    hyprpaper
    hyprlock
    mako
    waybar 
    hyprpicker
    hyprshot 
    hypridle
    hyprpolkitagent
    wofi
 
    ## TNCY ##
    # gcc
    git
    gitflow 
    python3Full
    # clang 
    # gnumake
    jdk21 #java
    jetbrains.idea-community #ide java
    bc # polish calculator
    # libgcc # g++ 
    wireshark
    wget # telecharge un fichier à un adresse donnée
   
    ## TEST ##
    # dterm 
    dnote 
    dstask

  ];
  
  # Son
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # services.pipewire.pulse.enable = true;
  #hardware.pulseaudio.enable = true;
  
  
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
    firefox.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    patchelf
    # haskellPackages.gi-pangocairo
    atk
    cairo
    gdk-pixbuf
    glib
    # gstreamer
    # gst-plugins-base
    gtk3
    gtksourceview4
    libpeas
    librsvg
    pango
    vte

    dbus
    xorg.libX11
    xorg.libxcb
    xorg.libXi
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver

    gnome2.GConf
    nss
    nspr
    alsa-lib
    cups
    fontconfig
    expat
    # libgtk
  ];


  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only
    # nerd-fonts
    # nerd-fonts._3270
    nerd-fonts.terminess-ttf
    # nerd-fonts.symbols-only
  
  ];
  
  programs.bash.shellAliases = {
    bn = "shutdown 0";
    re = "reboot";
    dodo = "hyprlock && systemctl suspend";
    wount = "sudo mount /dev/nvme0n1p3 ~/win";
    uwount = "sudo umount ~/win";
    # nix
    rebuild = "sudo nixos-rebuild --flake /etc/nixos";
    nxrb = "sudo nixos-rebuild --flake /etc/nixos";
    poubelle = "sudo nix-collect-garbage -d";
    nxfl = "sudo nix flake";
    nxsh = "nix-shell";
    nxcf = "sudo nano /etc/nixos/configuration.nix";
    nxhw = "sudo nano /etc/nixos/harware-configuration.nix";
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
  # environment = {
  #   sessionVariables = {
  #     LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
  #   };
  # };

  
  qt = {
    enable = true;
    #platformTheme = "gnome";
    style = "adwaita-dark";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}

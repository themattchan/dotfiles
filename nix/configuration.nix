# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, builtins, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.audit.enable = false;
  networking.hostName = "adrastea"; # Define your hostname.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  environment.variables = {
    EDITOR="emacs";
    XCURSOR_SIZE="32";
 #   XCURSOR_PATH = "$HOME/.icons";
  };

  environment.sessionVariables.GTK_PATH = "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";
# environment.profileRelativeEnvVars.XCURSOR_PATH = [ "/share/icons" ];

  environment.etc."Xmodmap".text = ''
    clear lock
    clear control
    keycode 66 = Control_L
    add control = Control_L Control_R
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     coreutils
     curl
     dmenu
     emacs
     feh
     firefox
     git
     htop
     i3
     i3lock
     i3status
     networkmanager_openvpn
     networkmanagerapplet
     tree
     unzip
     vim
     w3m
     wget
     which
     xdg_utils
     xterm
     xfce.xfconf
     zip
     xfce.thunar
     # one of these is needed for nm-applet icons
     gnome3.adwaita-icon-theme
     hicolor-icon-theme
     neofetch
     scrot
     plasma5.sddm-kcm

     (sddm.overrideAttrs (oldAttrs: {
       postInstall =
         let 
           simplicityTheme = fetchGit {
             url = "https://gitlab.com/isseigx/simplicity-sddm-theme.git";
           };
           chiliTheme = fetchGit {
             url = "https://github.com/MarianArlt/sddm-chili.git";
           };
	 in
         ''
	   cp -r ${simplicityTheme.outPath}/simplicity $out/share/sddm/themes/
	   cp -r ${chiliTheme.outPath} $out/share/sddm/themes/chili
         ''+oldAttrs.postInstall;
     }))
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.nixosManual.showManual = true;
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput = {
      enable = true;
#      clickMethod = "buttonareas";
      tapping = false;
      naturalScrolling = true;
    };
    dpi = 150;
    windowManager.default = "i3";
    windowManager.i3.enable = true;

    displayManager = {
      sddm.enable = true;
      sddm.enableHidpi=true;
#      sddm.packages = [ callPackage ./chiliTheme.nix {} ];
      sddm.theme="chili";
    };
#    desktopManager.xfce.enable = true;

    xkbOptions = "ctrl:nocaps";
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
     font-awesome_5
     hack-font
     siji
     unifont
    ];
  };

  services.acpid.enable = true;
  powerManagement.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.matt = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/matt";
    group = "users";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;
  programs.light.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}

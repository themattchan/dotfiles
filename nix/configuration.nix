# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, builtins, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.audit.enable = false;
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
    # GDK_SCALE = lib.mkDefault "2";
    # GDK_DPI_SCALE= lib.mkDefault "0.5";
  };

  environment.sessionVariables.GTK_PATH =
    "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";
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
     arandr
     binutils
     blueman
     cacert
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
     neofetch
     networkmanager_openvpn
     networkmanagerapplet
     nmap
     scrot
     thinkfan
     tree
     unzip
     vim
     w3m
     wget
     which
     xautolock
     xscreensaver
     xdg_utils
     xfce.thunar
     xfce.xfconf
     xterm
     zip

     # one of these is needed for nm-applet icons
     gnome3.adwaita-icon-theme
     hicolor-icon-theme

     (sddm.overrideAttrs (oldAttrs: {
       postInstall =
         let
           simplicityTheme = fetchGit {
             url = "https://gitlab.com/isseigx/simplicity-sddm-theme.git";
             rev = "403ba49019b519bfab99988f848a96e96f62b9c0";
           };
           # ## this needs some Qt bullshit...
           # chiliTheme = fetchFromGitHub {
           #   owner = "MarianArlt";
           #   repo = "sddm-chili";
           #   rev = "6516d50176c3b34df29003726ef9708813d06271";
           #   sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
           # };
         in
         ''
         cp -r ${simplicityTheme.outPath}/simplicity $out/share/sddm/themes/
#         cp -r ${chiliTheme.outPath} $out/share/sddm/themes/chili
         ''
         + oldAttrs.postInstall;
     }))
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  services.nixosManual.showManual = true;

  # enable the gpg-agent
  # need to `ssh-add` the keys from `~/.ssh`!!
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.ssh.startAgent = false;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # cups administration page: http://localhost:631/
  # https://nixos.wiki/wiki/Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      brlaser
    ];
  };

  # turn bluetooth control on
  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # enable dconf
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # Enable touchpad support.
#    synaptics.enable = true;
    libinput = {
      enable = true;
      tapping = false;
      naturalScrolling = true;
    };

    windowManager.default = "i3";
    windowManager.i3.enable = true;

    displayManager = {
      sddm.enable = true;
      sddm.enableHidpi=true;
      sddm.theme="simplicity";
    };
    # desktopManager = {
    #   default = "xfce";
    #   xterm.enable = false;
    #   xfce = {
    #     enable = true;
    #     noDesktop = true;
    #     enableXfwm = false;
    #   };
    # };

    # set capslock to control
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

     noto-fonts-cjk
     arphic-uming
     source-han-sans-traditional-chinese
     source-han-serif-traditional-chinese

     source-code-pro
     source-sans-pro
     source-serif-pro
    ];
  };

  # linux vendor firmware update service
  services.fwupd.enable = true;

  # Power management.
  services.acpid.enable = true;
  powerManagement.enable = true;
  services.logind.extraConfig = "HandleLidSwitch=suspend-then-hiernate";
#   services.logind.lidSwitch = "hybrid-sleep";

  # Add my user account
  users.extraUsers.matt = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/matt";
    group = "users";
    extraGroups = [ "wheel" "input" "audio" "networkmanager" ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  # For brightness control.
  programs.light.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}

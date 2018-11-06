with import <nixpkgs>{};
{

# reminder:: install sddm with simplicity theme on nixos
# themes go in /share/sddm/theme
#https://github.com/NixOS/nixpkgs/blob/release-18.09/nixos/modules/services/x11/display-managers/sddm.nix#L268
  wm = {
    inherit (pkgs) i3 i3lock i3status;

    polybar = pkgs.polybar.override {
        i3Support = true;
  #      mpdSupport = true;
        alsaSupport = true;
        pulseSupport = true;
  #      githubSupport = true;
    };

    st = (pkgs.st.overrideAttrs (oldAttrs: {
        configFile = builtins.readFile ./st/config.h;
        patches = [ ./st/st-scrollback-0.8.diff ./st/st-scrollback-mouse-0.8.diff ];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.hack-font];
      }));

  };

  apps = {
    inherit (pkgs)
       firefox
       chromium
       dropbox-cli
       spotify
       abiword
       libreoffice
       ;
    inherit (pkgs.gnome3) cheese;
  };

  # utils and systemsy things
  utils = {
    inherit (pkgs)
       jq
       neofetch
       pandoc
       rofi-unwrapped
       scrot
       ;
    inherit (pkgs.xfce4-13)
       thunar
       ;

    pass = pkgs.pass.withExtensions (p: [ p.pass-import ]);
  };

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic latexmk;
  };

  development = {
    inherit (pkgs)
     coq
     ocaml
     openjdk
#     purescript
     python2
     python3
     sbcl
     sbt
     scala
     stack
     z3
     nodejs-10_x
     ;

    ghc = pkgs.pkgs.haskellPackages.ghcWithPackages (p: [ p.aeson p.network p.lens p.lens-aeson]);

    inherit (pkgs.nodePackages) bower;

#    inherit (pkgs.haskellPackages) purescript;
  };

  fonts = {
    inherit (pkgs)
     font-awesome_5
     hack-font
     siji
     unifont
     ;

   # postInstall = ''
   #   echo "refresh font cache"
   #   mkdir -p  ~/.local/share/fonts/
   #   ln -sf ~/.nix-profile/share/fonts/ ~/.local/share/fonts/nix-fonts
   #   fc-cache -rv
   # '';
  };

}

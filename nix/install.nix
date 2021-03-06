let unstable = import <unstable>{}; in
with import <nixpkgs>{};
{
    inherit (pkgs)
      i3
      i3lock
      i3status
      j4-dmenu-desktop
      lemonbar-xft
      ;

    polybar = pkgs.polybar.override {
        i3Support = true;
        mpdSupport = true;
        alsaSupport = true;
        pulseSupport = true;
    };

    st = pkgs.st.overrideAttrs (oldAttrs: {
        configFile = builtins.readFile ./st/config.h;
        patches = [ ./st/st-scrollback-0.8.diff ./st/st-scrollback-mouse-0.8.diff ];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.hack-font];
    });

    inherit (pkgs)
       firefox
       chromium
       dropbox-cli
       spotify
       abiword
       libreoffice
       evince
       ;
    inherit (pkgs.gnome3) cheese;

    # utils and systemsy things
    inherit (pkgs)
       emacs
#       jq
       neofetch
       pandoc
#       rofi-unwrapped
       scrot
       aspell
       light
       ;
    inherit (pkgs.aspellDicts) en;
    # inherit (pkgs.xfce4-13)
    #    thunar
    #    ;
    jq = unstable.jq;
    pass = pkgs.pass.withExtensions (p: [ p.pass-import ]);

    latex = pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic latexmk;
    };

    inherit (pkgs)
     coq
     ocaml
#     openjdk10
#     purescript psc-package
     python2
     python3
     sbcl
     scala sbt scalafmt
     stack
     z3
     nodejs-10_x
     gcc
     ;

 #   inherit (pkgs.llvmPackages) libcxxClang libcxxStdenv;

    ghc = pkgs.pkgs.haskellPackages.ghcWithPackages (p: [
      p.aeson
      p.containers
      p.comonad
      p.lens
      p.lens-aeson
      p.machines
      p.mtl
      p.network
      p.profunctors
      p.recursion-schemes
      p.servant
      p.transformers
      p.unordered-containers
      p.warp

# p.spdx needs to be jailbroken for this shit to work...
      # p.psc-ide
      # p.ghcid
      # p.Cabal_2_2_0_1
      # p.cabal2nix
    ]);

    inherit (pkgs.nodePackages) bower;

    inherit (pkgs.gnome3) adwaita-icon-theme gnome-terminal;

    inherit (pkgs)
      moka-icon-theme
      numix-gtk-theme;

    inherit (pkgs)
      font-awesome_5
      hack-font
      siji
      unifont
      ;

}

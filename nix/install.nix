with import <nixpkgs>{};
{
  polybar = pkgs.polybar.override {
      i3Support = true;
#      mpdSupport = true;
      alsaSupport = true;
      pulseSupport = true;
#      githubSupport = true;
  };

  pass = pkgs.pass.withExtensions (p: [ p.pass-import ]);

  ghc = pkgs.haskellPackages.ghcWithPackages (p: [ p.aeson p.network p.lens p.lens-aeson ]);

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic latexmk;
  };

  javascript = {
    node = pkgs.nodejs-10_x;
  #  npm = pkgs.npm;
  };

  st = (pkgs.st.overrideAttrs (attrs: {
      configFile = builtins.readFile ./st/config.h;
      patches = [ ./st/st-scrollback-0.8.diff ./st/st-scrollback-mouse-0.8.diff ];
    }));

  apps = {
    inherit (pkgs)
       firefox
       chromium
       dropbox-cli
       spotify
       ;
  };

  utils = {
    inherit (pkgs)
       neofetch
       jq
       pandoc
       rofi-unwrapped
       ;
  };

  development = {
    inherit (pkgs)
     coq
     ocaml
     sbcl
     sbt
     scala
     stack
     z3
     openjdk
     purescript
     ;
  };

  fonts = {
    inherit (pkgs)
     hack-font
     unifont
     siji
     font-awesome_5
     ;

   # postInstall = ''
   #   echo "refresh font cache"
   #   mkdir -p  ~/.local/share/fonts/
   #   ln -sf ~/.nix-profile/share/fonts/ ~/.local/share/fonts/nix-fonts
   #   fc-cache -rv
   # '';
  };

}

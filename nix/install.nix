# install it all
# nix-env --install --file install.nix

# install specific
# nix-env --install --file install.nix --attr <name>

# show installed
# nix-env -q

# have to put
# { allowUnfree = true; }
# in ./config/nixpkgs/config.nix

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

  inherit (pkgs)
     firefox
     chromium
     dropbox-cli
     spotify
     rofi-unwrapped
     neofetch
     pandoc
     jq

     ## development
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

  ## ln -sf ~/.nix-profile/share/fonts/ ~/.local/share/fonts/nix-fonts
  fonts = {
    inherit (pkgs)
     hack-font
     unifont
     siji
#     font-awesome-ttf
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

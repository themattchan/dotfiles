# install it all
# nix-env --install --file install.nix

# install specific
# nix-env --install --file install.nix --attr <name>

# have to put
# { allowUnfree = true; }
# in ./config/nixpkgs/config.nix

let pkgs = import <nixpkgs> {};
in {
  polybar = pkgs.polybar.override {
      i3Support = true;
      mpdSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      githubSupport = true;
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

     # fonts
     hack-font
     unifont
     siji
     font-awesome_5
     ;
}

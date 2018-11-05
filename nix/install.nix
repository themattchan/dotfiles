# nix-env --install --file install.nix
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

  inherit (pkgs)
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

     # fonts
     hack-font
     unifont
     siji
     font-awesome_5
     ;
}

# nix-env --install --file install.nix
let pkgs = import <nixpkgs> {};
in {
   polybar = pkgs.polybar.override {
      i3Support = true;
#      mpdSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      githubSupport = true;
   };

   inherit (pkgs)
     spotify
     rofi-unwrapped
     ;
}

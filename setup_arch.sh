#! /bin/sh

# PACMAN=sudo pacman -Syu --needed
# PACAUR=sudo pacaur -Syu --needed

cd;

PKGS+=" cups cups-filters ghostscript gsfonts cups-pdf libcups"

PKGS+=" emacs htop the_silver_searcher ntp htop pavucontrol"
PKGS+=" zsh git aspell aspell-en"
PKGS+=" elinks irssi wget curl openssh rsync"
#PKGS+=" jdk8-openjdk"
#PKGS+=" scala sbt"
#PKGS+=" haskell-stack"
PKGS+=" ocaml"
PKGS+=" racket"

PKGS+=" vlc"
PKGS+=" gstreamer"
PKGS+=" gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly"
PKGS+=" evince"
PKGS+=" firefox transmission-gtk"


PKGS+=" texlive-most"

PKGS+=" google-chrome"
PKGS+=" dropbox"
PKGS+=" qpdfview"
PKGS+=" z3"

sudo pacman -Syu --needed ${PKGS}


gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
xfconf-query -c xsettings -p /Gtk/KeyThemeName -s Emacs
/usr/bin/setxkbmap -option '' -option 'ctrl:nocaps'


tllocalmgr install cm-super lm lmodern mdframed etoolbox needspace secdot tabu \
           varwidth multirow units siunitx algorithmicx hyphenat enumitem \
           paralist biblatex biblatex-ieee logreq xstring
sudo texhash

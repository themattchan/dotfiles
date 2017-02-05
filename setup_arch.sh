#! /bin/sh

# PACMAN=sudo pacman -Syu --needed
# PACAUR=sudo pacaur -Syu --needed

cd;

sudo pacman -Syu --needed \
     plasma-meta \
     xfce4 \
     xmonad xmonad-contrib 

pacaur -Syu --needed \
     xfce4-goodies xfce4-notifyd
     
sudo pacman -Syu --needed \
     emacs htop the_silver_searcher ntp htop pavucontrol \
     zsh git aspell aspell-en \
     elinks irssi wget curl \
     jdk8-openjdk \
     scala sbt \
     haskell-stack \
     ocaml \
     racket 

sudo pacman -Syu --needed \
     vlc \
     gstreamer \
     gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly \
     evince \
     firefox transmission-gtk \
     

# sudo pacman -Syu --needed \
#      libreoffice-fresh \
#      texlive-most 

pacaur -Syu --needed \
     google-chrome \
     dropbox \
     qpdfview \
     z3

gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
xfconf-query -c xsettings -p /Gtk/KeyThemeName -s Emacs
/usr/bin/setxkbmap -option '' -option 'ctrl:nocaps'

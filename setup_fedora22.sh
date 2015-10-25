#! /bin/sh

cd;

sudo dnf update -y

sudo dnf install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-22.noarch.rpm

sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm

# xfce
sudo dnf group install -y "Xfce Desktop"
# xfce panel plugins, why the fuck aren't these bundled
sudo dnf install -y xfce4-battery-plugin xfce4-cellmodem-plugin xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-dict-plugin xfce4-diskperf-plugin xfce4-embed-plugin xfce4-eyes-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-mailwatch-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin  xfce4-screenshooter-plugin xfce4-sensors-plugin  xfce4-smartbookmark-plugin xfce4-systemload-plugin  xfce4-timer-plugin xfce4-time-out-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin 

# install stuff
sudo dnf install -y \
    # dev tools
    zsh git emacs \
    gcc gdb java ghc \
    
    # LaTeX
    texlive-scheme-basic \ 
    texlive-collection-latex texlive-collection-latexextra texlive-collection-latexrecommended texlive-collection-mathextra texlive-collection-genericextra texlive-collection-genericrecommended texlive-collection-bibtexextra texlive-collection-basic texlive-collection-binextra texlive-collection-fontsextra texlive-collection-fontsrecommended texlive-collection-fontutils texlive-collection-formatsextra \
    
    # browser
    firefox transmission \
    
    # media player + codecs
    vlc \
    gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1 
 
# fedy
su -c "curl https://satya164.github.io/fedy/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer"

# setup things
chsh -s /bin/zsh $(whoami)


#! /bin/sh

cd;

# full system update
sudo dnf update -y

# add repos
sudo dnf install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm
sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
sudo rpm -ivh http://rpm.livna.org/livna-release.rpm

# xfce
sudo dnf group install -y "Xfce Desktop"
# xfce panel plugins, why the fuck aren't these bundled together
sudo dnf install -y xfce4-battery-plugin xfce4-cellmodem-plugin xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-dict-plugin xfce4-diskperf-plugin xfce4-embed-plugin xfce4-eyes-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-mailwatch-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin  xfce4-screenshooter-plugin xfce4-sensors-plugin  xfce4-smartbookmark-plugin xfce4-systemload-plugin  xfce4-timer-plugin xfce4-time-out-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin

# dev tools and command line things
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y zsh git emacs gcc gdb kernel-devel java scala node
sudo dnf install -y haskell-platform @ocaml coq z3 sbcl racket
sudo dnf install -y elinks irssi wget curl
#sudo dnf install -y powertop thinkfan

# LaTeX
sudo dnf install -y \
	 texlive-scheme-basic \
     texlive-collection-latex texlive-collection-latexextra texlive-collection-latexrecommended texlive-collection-mathextra texlive-collection-genericextra texlive-collection-genericrecommended texlive-collection-bibtexextra texlive-collection-basic texlive-collection-binextra texlive-collection-fontsextra texlive-collection-fontsrecommended texlive-collection-fontutils texlive-collection-formatsextra

# pdf viewer
sudo dnf install -y evince

# dock
sudo dnf install -y gnome-do

# web things
sudo dnf install -y firefox transmission

# media player + codecs
sudo dnf install -y vlc \
	 gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1

# fedy
su -c "curl https://satya164.github.io/fedy/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer"

# dropbox
sudo dnf install -y nautilus nautilus-dropbox libgnome hfsplus-tools
sudo yum install thunarx-python Thunar-devel libthunarx-2-dev
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# setup things
chsh -s /bin/zsh $(whoami)

gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
xfconf-query -c xsettings -p /Gtk/KeyThemeName -s Emacs

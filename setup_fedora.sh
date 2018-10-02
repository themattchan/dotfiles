#! /bin/sh

## RUN THIS AS SUDO

FEDORA_VERSION=28

cd;

# full system update
dnf update -y

# add repos
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:snwh:moka/Fedora_25/home:snwh:moka.repo # moka icons
dnf config-manager --add-repo https://build.opensuse.org/project/show/home:paolorotolo:numix
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:manuelschneid3r/Fedora_28/home:manuelschneid3r.repo
dnf install -y --nogpgcheck "http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm"
dnf copr enable -y heliocastro/hack-fonts
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
su -c "curl https://satya164.github.io/fedy/fedy-installer -o fedy-installer && chmod +x fedy-installer && ./fedy-installer"
rm ./fedy-installer
dnf install -y curl
curl -sSL "https://s3.amazonaws.com/download.fpcomplete.com/fedora/${FEDORA_VERSION}/fpco.repo" | tee /etc/yum.repos.d/fpco.repo

## dnf groups
# xfce
dnf group install -y "Xfce Desktop"
# dev tools and command line things
dnf group install -y "Development Tools"

# system utilities
MY_PKGS+=" htop ntp pavucontrol util-linux-user gdouros-symbola-fonts"

# xfce panel plugins, why the fuck aren't these bundled together
MY_PKGS+=" xfce4-battery-plugin xfce4-cellmodem-plugin"
MY_PKGS+=" xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin"
MY_PKGS+=" xfce4-datetime-plugin xfce4-dict-plugin xfce4-diskperf-plugin"
MY_PKGS+=" xfce4-embed-plugin xfce4-eyes-plugin xfce4-fsguard-plugin"
MY_PKGS+=" xfce4-genmon-plugin xfce4-mailwatch-plugin xfce4-mount-plugin"
MY_PKGS+=" xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes-plugin"
MY_PKGS+=" xfce4-places-plugin xfce4-screenshooter-plugin xfce4-sensors-plugin"
MY_PKGS+=" xfce4-smartbookmark-plugin xfce4-systemload-plugin xfce4-timer-plugin"
MY_PKGS+=" xfce4-time-out-plugin xfce4-verve-plugin xfce4-wavelan-plugin"
MY_PKGS+=" xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin"

# dev tools and command qline things
MY_PKGS+=" zsh git emacs the_silver_searcher"
MY_PKGS+=" aspell aspell-en"
MY_PKGS+=" elinks irssi wget curl"
#dnf install -y powertop thinkfan

# generally useful programs
MY_PKGS+=" nautilus nautilus-dropbox libgnome hfsplus-tools"
MY_PKGS+=" thunarx-python Thunar-devel libthunarx-2-dev"
MY_PKGS+=" pass qtpass plank albert"

# interface stuff
MY_PKGS+="moka-icon-theme numix hack-fonts"

# compilers, etc
MY_PKGS+=" gcc gdb kernel-devel"
MY_PKGS+=" java-openjdk-devel maven"
MY_PKGS+=" scala sbt"
MY_PKGS+=" haskell-platform"
MY_PKGS+=" stack"
MY_PKGS+=" @ocaml"
MY_PKGS+=" coq"
MY_PKGS+=" z3"
MY_PKGS+=" sbcl"

# LaTeX
MY_PKGS+=" texlive-scheme-basic"
MY_PKGS+=" texlive-collection-latex"
MY_PKGS+=" texlive-collection-latexextra"
MY_PKGS+=" texlive-collection-latexrecommended"
MY_PKGS+=" texlive-collection-mathextra"
MY_PKGS+=" texlive-collection-genericextra"
MY_PKGS+=" texlive-collection-genericrecommended"
MY_PKGS+=" texlive-collection-bibtexextra"
MY_PKGS+=" texlive-collection-basic"
MY_PKGS+=" texlive-collection-binextra"
MY_PKGS+=" texlive-collection-fontsextra"
MY_PKGS+=" texlive-collection-fontsrecommended"
MY_PKGS+=" texlive-collection-fontutils"
MY_PKGS+=" texlive-collection-formatsextra"
MY_PKGS+=" latexmk"

# media player + codecs
MY_PKGS+=" vlc"
MY_PKGS+=" gstreamer-ffmpeg"
MY_PKGS+=" gstreamer-plugins-base-tools"
MY_PKGS+=" gstreamer-plugins-bad"
MY_PKGS+=" gstreamer-plugins-bad-free-extras"
MY_PKGS+=" gstreamer-plugins-ugly"
MY_PKGS+=" gstreamer1"
MY_PKGS+=" gstreamer1-libav"
MY_PKGS+=" gstreamer1-plugins-base"
MY_PKGS+=" gstreamer1-plugins-ugly"
MY_PKGS+=" gstreamer1-plugins-bad-free"
MY_PKGS+=" gstreamer1-plugins-bad-free-extras"
MY_PKGS+=" gstreamer1-plugins-bad-freeworld"
MY_PKGS+=" gstreamer1-plugins-good"
MY_PKGS+=" gstreamer1-plugins-good-extras"
MY_PKGS+=" pragha"

# useful apps
MY_PKGS+=" cheese keepassx"

# pdf viewer
MY_PKGS+=" evince"

# web things
MY_PKGS+=" firefox chromium transmission"


## install it
dnf install -y ${MY_PKGS}


# --------------------------------------------------------------------------------

# curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
# dnf install -y nodejs
# npm install -g purescript pulp bower

# dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# skype
dnf install -y https://repo.skype.com/latest/skypeforlinux-64-alpha.rpm

# setup things
chsh -s /bin/zsh $(whoami)

gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
xfconf-query -c xsettings -p /Gtk/KeyThemeName -s Emacs
/usr/bin/setxkbmap -option '' -option 'ctrl:nocaps'

xfconf-query -c xsettings -p /Net/EnableEventSounds -s "false"
xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s "false"

xfconf-query -c xfwm4 -p /general/theme -s "Numix"
xfconf-query -c xsettings -p /Net/ThemeName -s "Numix"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Moka"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Hack 9"
xfconf-query -c xsettings -p /Gtk/KeyThemeName -s "Emacs"


#  gtf 1920 1200 60 -x
#
#   # 1920x1200 @ 60.00 Hz (GTF) hsync: 74.52 kHz; pclk: 193.16 MHz
#   Modeline "1920x1200_60.00"  193.16  1920 2048 2256 2592  1200 1201 1204 1242  -HSync +Vsync
#
# [matt@localhost ~]$ xrandr --newmode "1920x1200_60.00"  193.16  1920 2048 2256 2592  1200 1201 1204 1242  -HSync +Vsync
# [matt@localhost ~]$ xrandr --addmode eDP-1 "1920x1200_60.00"
# [matt@localhost ~]$ xrandr --output eDP-1 --mode 1920x1200_60.00
# [matt@localhost ~]$
#

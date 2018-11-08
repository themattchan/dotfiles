#! /bin/sh

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

tllocalmgr install cm-super lm lmodern mdframed etoolbox needspace secdot tabu \
           varwidth multirow units siunitx algorithmicx hyphenat enumitem \
           paralist biblatex biblatex-ieee logreq xstring
sudo texhash


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

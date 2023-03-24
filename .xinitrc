#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

~/Skripte/tap_click.sh &
~/Skripte/natural_scrolling.sh &
~/Skripte/mirror.sh &
~/Skripte/wallpaper.sh &
~/Skripte/polybar.sh &

setxkbmap de

picom --config ~/conf/picom.conf & 
sxhkd -c ~/conf/sxhkd.conf &
bspwm -c ~/conf/bspwm.conf

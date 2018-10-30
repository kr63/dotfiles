#! /bin/sh
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

MY_DE=xmonad
# MY_DE=xfce4
LAPTOP=false

# keyboard layouts
setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led:scroll'
xsetroot -cursor_name left_ptr

if [ $LAPTOP = true ] ; then
    # nvidia prime
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
    # disable touchpad while typing
    syndaemon -i 1 -t -k -d
fi

case $MY_DE in
    xmonad)
        # stalonetray &

        trayer-srg\
            --edge top\
            --SetPartialStrut true\
            --SetDockType true\
            --height 24\
            --transparent true\
            --alpha 0\
            --tint 0x0\
            --distancefrom right\
            --distance 435\
            --widthtype request\
            --expand true\
            --align right\
            --iconspacing 5 &
        exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xmonad
        ;;
    xfce4)
        pnmixer &
        exec ck-launch-session dbus-launch --sh-syntax --exit-with-session xfce4-session
        exec startxfce4
        ;;
esac

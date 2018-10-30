#! /bin/sh

xsetroot -cursor_name left_ptr

trayer\
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
    --align right &

# evolution can't connect to the gmail without stop the service
systemctl stop --user evolution-source-registry.service

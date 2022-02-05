#! /bin/sh

mutter --wayland &
sleep 5
sakura -h -e "sh /usr/bin/wd_startup.sh"

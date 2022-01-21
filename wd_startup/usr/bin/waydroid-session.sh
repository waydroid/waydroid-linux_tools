#!/bin/bash
weston &
export DISPLAY=:1
sleep 3 && \
sakura -h -e "sh /usr/bin/wd_startup.sh" 

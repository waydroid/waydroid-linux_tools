#!/bin/bash

RCol='\e[0m'    # Text Reset

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

# Define variables
home_folder="$(eval echo "~$USER")"
file="$home_folder/.cache/waydroid_settings/wdlaunch"
temp_launch_command=""
fullscreen="waydroid show-full-ui"
restart_required="no"

if waydroid status | grep -q 'STOPPED'; then
  echo "Waydroid needs to be running for this to work, Please launch it and then run this script."
  return
fi

# Read saved launch type
if [ -f $file ]; then
	temp_launch_command=$(cat $file)
	echo "previous setting: $temp_launch_command"
else
	echo "No saved launch config found"
	temp_launch_command=$fullscreen
fi

# Ask what command they want
# To only hide the status bar: adb shell settings put global policy_control immersive.status=*
# To only hide the navigation bar: adb shell settings put global policy_control immersive.navigation=*
# To hide both status and nav bar: adb shell settings put global policy_control immersive.full=*
# Return things to normal: adb shell settings put global policy_control null*

echo -e "${IBlu}What launch method would you like to use?${RCol}"
echo -e "${IBlu}  1 - Fullscreen UI (default)${RCol}"
echo -e "${IBlu}  2 - Kiosk Mode${RCol}"
echo -e "${IBlu}  3 - Multiwindow Mode (Desktop Mode) ${IRed}!!Requires Mutter session!!${RCol}"
echo -e "${IBlu}  4 - Reset all options to default${RCol}"
read -p "Input 1, 2, 3 or 4 for your selection: " choice

case $choice in
  1) sudo waydroid prop set persist.waydroid.multi_windows false
     sed -i '/waydroid.active_apps=Waydroid/d' /var/lib/waydroid/waydroid_base.prop
     mkdir -p "$(dirname $file)" && echo $fullscreen > $file
     echo "Fullscreen mode is set";;
  2) echo -e "${IGre}List of apps:  ${RCol}"
     waydroid app list
     echo ""
     echo -e "${IBlu}Please enter the packageName you would like to launch by default: ${RCol}"
     read -p "Input: " appname     
     temp_launch_command="waydroid app launch $appname"
     mkdir -p "$(dirname $file)" && echo $temp_launch_command > $file
     echo ""
     echo -e "${IBlu}Do you want to hide the (a)Navbar, (b)Statusbar (c)Both or (d) Neither?: ${RCol}"
     read -p "Input a, b, c, or d: " choice2
     case $choice2 in
		a) echo "settings put global policy_control immersive.navigation=*" | sudo waydroid shell
		   echo "Navbar hidden" ;;
		b) echo "settings put global policy_control immersive.status=*" | sudo waydroid shell
		   echo "Status bar is hidden";;
		c) echo "settings put global policy_control immersive.full=*" | sudo waydroid shell
		   echo "Both navbar and Status bar are hidden";;
		d) echo "settings put global policy_control null*" | sudo waydroid shell
		   echo "Default behivour is set for navbar and status bar";;
		*) echo "Unrecognized selection: $choice" ;;
	 esac
	 sudo waydroid prop set persist.waydroid.multi_windows false
     sed -i '/waydroid.active_apps=Waydroid/d' /var/lib/waydroid/waydroid_base.prop
     restart_required="yes"
     echo "Kiosk Mode is set" ;;     
  3) sudo waydroid prop set persist.waydroid.multi_windows true
     echo "waydroid.active_apps=Waydroid" >> /var/lib/waydroid/waydroid_base.prop
     mkdir -p "$(dirname $file)" && echo $temp_launch_command > $file
     restart_required="yes"
     echo "Multiwindow (Desktop) mode is set" ;;
  4) sudo waydroid prop set persist.waydroid.multi_windows false
     sed -i '/waydroid.active_apps=Waydroid/d' /var/lib/waydroid/waydroid_base.prop
     mkdir -p "$(dirname $file)" && echo $fullscreen > $file
     restart_required="yes"
     echo "All settings set to default" ;;
  *) echo "Unrecognized selection: $choice" ;;
esac

if [ "$restart_required" == "yes" ]; then
	echo -e "${IRed}A restart of the Waydroid container service is required. Doing that now${RCol}"
	sudo systemctl restart waydroid-container.service
fi



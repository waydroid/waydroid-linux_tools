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
winfo1="Use (${IBlu}waydroid session stop/start${RCol}), (${IBlu}sudo systemctl restart waydroid-container.service${RCol}) or other commands to troubleshoot from a second terminal tab."
winfo2="Use (${IGre}win+tab${RCol}) to switch between this terminal and the Waydroid instance."
winfo3="Use (${IGre}ctrl+shift+t${RCol}) to create a new terminal tab"
winfo4="Use (${IGre}ctrl+c${RCol}) from this tab to force stop the current running session"
winfo5="Use (${IGre}ctrl+alt+bkspc${RCol}) or close this terminal app to force log-out"
winfo6="You can run 'sh configure_launch_type.sh' to setup the default behaviour. Options are: Fullscreen, Kiosk Mode & Desktop Mode"
winfoend="${IWhi}Have Fun!!${RCol}"
home_folder="$(eval echo "~$USER")"
launch_file="$home_folder/.cache/waydroid_settings/wdlaunch"

# Read saved launch type : sh ~/.cache/waydroid_settings/wdlaunch
if [ -f $launch_file ]; then
	launch_command=$(cat $launch_file)
else
	echo -e "Initial launch setup not found. Using default fullscreen mode"
	launch_command="waydroid show-full-ui"
fi

# Display network info
echo ""
echo "Network Info:"
ip -c a show

# Display navigation information
echo ""
echo $winfo1
echo $winfo2
echo $winfo3
echo $winfo4
echo $winfo5
echo $winfo6
echo ""
echo $winfoend

# Check for session state
echo ""
echo "${BBlu}Checking Waydroid Session${RCol}"

if waydroid status | grep -q 'STOPPED'; then
  echo "It's Stopped, starting now..."
  $launch_command
else
  echo "Old Waydroid session is still ruinning and needs to be restarted"
  sudo systemctl restart waydroid-container.service
  $launch_command
fi

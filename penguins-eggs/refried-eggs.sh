#!/bin/bash

# Refried-Eggs 

# A simple script to repack a distro based on the current customizations
# To further customize, use the ~/backup/skel folder to place target 
# branding assets that you want to have carried over to the new user profile

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
build_folder="$home_folder/.cache/refried-eggs"
BLOCKLIST="/etc/skel/.config/geany /etc/skel/.config/GitKraken \
/etc/skel/.config/Google /etc/skel/.config/BraveSoftware \
/etc/skel/.config/chromium /etc/skel/.config/gsconnect \
/etc/skel/.config/google-chrome-beta /etc/skel/.config/google-chrome-unstable \
/etc/skel/.config/libaccounts-glib \
/etc/skel/.config/python_keyring /etc/skel/.config/fontconfig \
/etc/skel/.local/share/kwalletd /etc/skel/.local/share/Google \
/etc/skel/.local/share/tracker /etc/skel/.local/share/krita* "
external_packages="gitkraken rpi-imager imager stacer bleachbit code"
omitted_packages="filezilla filezilla-common gnome-builder ubuntu-cleaner"
wd_data_loc="/var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid"

if [ ! -f /usr/bin/eggs ]; then
	echo -e "${IRed}  penguins-eggs is not installed. Please install and try running again. ${RCol}"
	return 1
fi

# Ask what command they want

if [ ! -d $build_folder ]; then
    mkdir $build_folder
fi

echo -e "${IBlu}What do you want to do with eggs?${RCol}"
echo -e "${IBlu}  1 - Wipe & rebuild ISO${RCol}"
echo -e "${IBlu}  2 - Generate Backup Folder with your customizations${RCol}"
echo -e "${IBlu}  3 - Wipe Waydroid data and reinit waydroid images${RCol}"
echo -e "${IBlu}  4 - ${RCol}"

read -p "Input 1, 2, 3 or 4 for your selection: " choice

case $choice in
  1) echo -e "${IYel}  Cleaning Up ${RCol}"
     sudo rm -rf /home/eggs/
     sudo rm -rf $build_folder/Waydroid-Linux*.iso
     sudo rm -rf $build_folder/Waydroid-Linux*.sha
     sudo rm -rf /etc/skel/
     # Remove
     for i in $external_packages; do
      sudo apt remove -y $i
     done
     for i in $omitted_packages; do
      sudo apt remove -y $i 
     done
     #~ sudo apt autoremove -y
     read -p "press any key to continue"
     echo -e "${IYel}  Rebuilding skel and locals ${RCol}"
     sudo eggs calamares --install
     sudo eggs tools:skel
     sudo cp -Rp $home_folder/backup/skel/ /etc/
     echo -e "${IYel}  Removing blocklisted items ${RCol}"
     sudo rm -rf $BLOCKLIST
     echo -e "${IYel}  Updating yolk ${RCol}"
     if [ ! -d /usr/local/yolk ]; then
          sudo rm -rf /usr/local/yolk
          sudo cp -r /var/local/yolk /usr/local/
     fi
     read -p "press any key to continue"
     echo -e "${IYel}  Refrying your eggs ${RCol}"
     sudo eggs dad
     echo -e "${IYel}  Moving .iso to a folder you can access ${RCol}"
     sudo mv /home/eggs/*.iso $build_folder
     sudo chown admin $build_folder/Waydroid-Linux*.iso
     echo -e "${IYel}  Restoring ommitted packages ${RCol}"
     # Install
     sudo apt update
     for i in $omitted_packages; do
      sudo apt-get install -y $i 
     done
     sudo apt --fix-broken install
     for i in $external_packages; do
      sudo dpkg -i $home_folder/Downloads/$i*
     done
     sudo apt --fix-broken install

     echo -e "${IGre}  All set. ISO can be found in $build_folder${RCol}";;
  2) echo -e "${IYel}  Gathering resources ${RCol}"
     mkdir -p $home_folder/backup
     mkdir -p $home_folder/backup/skel
     mkdir -p $home_folder/backup/skel/.local
     mkdir -p $home_folder/backup/skel/.local/share
     sudo cp -Rp $home_folder/.themes $home_folder/backup/skel/
     sudo cp -Rp $home_folder/.icons $home_folder/backup/skel/
     sudo cp -Rp $home_folder/.backgrounds $home_folder/backup/skel/
     sudo cp -Rp $home_folder/.local/share/applications $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/backgrounds $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/icons $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/nautilus $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/nautilus-python $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/nemo $home_folder/backup/skel/.local/share/
     sudo cp -Rp $home_folder/.local/share/nemo-python $home_folder/backup/skel/.local/share/
     echo -e "${IGre}  All set. You can find what was copied in $home_folder/backup ${RCol}";;
  3) echo -e "${IYel}  Cleaning Up and reiniting Waydroid ${RCol}"
     sudo rm -rf $wd_data_loc
     sudo waydroid init -f
     echo -e "${IGre}  All set. ${RCol}";;
  4) ;;
  *) echo "Unrecognized selection: $choice" ;;
esac




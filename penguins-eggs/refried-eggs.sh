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

# home_folder="$(eval echo "~$USER")"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
username="$(who mom likes | sed -n 's/^\([^ ]*\).*/\1/p')"
if [ ! $username ]; then
   username=$(echo "$USER")
fi
pre_home_folder="/home/$username"
home_folder=$(echo $pre_home_folder | sed 's%/$%%')
build_folder="$home_folder/refried-eggs/out"
temp_folder="$home_folder/refried-eggs/tmp"
base_build_folder="$home_folder/refried-eggs"
BLOCKLIST="/etc/skel/.config/geany /etc/skel/.config/GitKraken \
/etc/skel/.config/Google /etc/skel/.config/BraveSoftware \
/etc/skel/.config/chromium /etc/skel/.config/gsconnect \
/etc/skel/.config/google-chrome-beta /etc/skel/.config/google-chrome-unstable \
/etc/skel/.config/libaccounts-glib \
/etc/skel/.config/python_keyring /etc/skel/.config/fontconfig \
/etc/skel/.local/share/kwalletd /etc/skel/.local/share/Google \
/etc/skel/.local/share/tracker /etc/skel/.local/share/krita* \
/etc/skel/snap/gitkraken /etc/skel/snap/firefox \
/etc/skel/var/lib/flatpak/app/com.visualstudio.code"
external_packages="gitkraken rpi-imager imager stacer bleachbit code"
omitted_packages="filezilla filezilla-common gnome-builder ubuntu-cleaner"
wd_data_loc="/var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid"
added_apps="nomachine"
added_snap_apps="gitkraken firefox chromium"
ommitted_snap_apps="gitkraken"
added_flatpak_apps="com.visualstudio.code org.chromium.Chromium"

echo "Script Directory: $SCRIPT_DIR"
echo "Home Folder: $home_folder"
echo "Build Folder: $build_folder"
echo ""

# Functions

# Generate the backup folder based on content in .local, .cache, etc. 
doGenerateBackup(){
   echo -e "${IYel}  Gathering resources ${RCol}"
   echo -e "${IGre}  Starting backup generation ${RCol}"
   mkdir -p $home_folder/backup
   mkdir -p $home_folder/backup/skel
   mkdir -p $home_folder/backup/skel/.local
   mkdir -p $home_folder/backup/skel/.local/share
   mkdir -p $home_folder/backup/skel/.config
   mkdir -p $home_folder/backup/skel/.cache

   # themes & icons if any
   if [ -d $home_folder/.themes ]; then
      sudo cp -Rp $home_folder/.themes $home_folder/backup/skel/
   fi
   if [ -d $home_folder/.icons ]; then
      sudo cp -Rp $home_folder/.icons $home_folder/backup/skel/
   fi
   if [ -d $home_folder/.local/share/icons ]; then
      sudo cp -Rp $home_folder/.local/share/icons $home_folder/backup/skel/.local/share/
   fi

   # backgrounds (part 1)
   if [ ! -d $home_folder/.backgrounds ]; then
      cp -Rp $SCRIPT_DIR/skel/.backgrounds $home_folder
      sudo cp -Rp $SCRIPT_DIR/skel/.backgrounds/* /usr/share/backgrounds
   fi
   sudo cp -Rp $home_folder/.backgrounds $home_folder/backup/skel/

   # applications
   if [ ! -d $home_folder/.local/share/applications ]; then
      cp -Rp $SCRIPT_DIR/skel/.local/share/applications $home_folder.local/share/
   fi
   sudo cp -Rp $home_folder/.local/share/applications $home_folder/backup/skel/.local/share/

   # backgrounds (part 2)
   if [ ! -d $home_folder/.local/share/backgrounds ]; then
      cp -Rp $SCRIPT_DIR/skel/.local/share/backgrounds $home_folder.local/share/
   fi
   sudo cp -Rp $home_folder/.local/share/backgrounds $home_folder/backup/skel/.local/share/

   # any custom extensions or actions for nemo & nautilus as well
   sudo cp -Rp $home_folder/.local/share/nautilus $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/nautilus-python $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/nemo $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/nemo-python $home_folder/backup/skel/.local/share/

   # Now for the rest of the customizations
   sudo cp -Rp $home_folder/.local/bin $home_folder/backup/skel/.local/
   sudo cp -Rp $home_folder/.local/share/gnome* $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/wpm $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/evolution $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/flatpak $home_folder/backup/skel/.local/share/
   sudo cp -Rp $home_folder/.local/share/webkitgtk $home_folder/backup/skel/.local/share/
   if [ -d $home_folder/.local/share/waydroid ]; then
      sudo cp -Rp $home_folder/.local/share/waydroid $home_folder/backup/skel/.local/share/
   fi

   # Now for the configs
   sudo cp -Rp $home_folder/.config/gnome* $home_folder/backup/skel/.config/
   sudo cp -Rp $home_folder/.config/weston.ini $home_folder/backup/skel/.config/
   sudo cp -Rp $home_folder/.cache/gnome* $home_folder/backup/skel/.cache/
   sudo cp -Rp $home_folder/.cache/waydroid* $home_folder/backup/skel/.cache/
   sudo cp -Rp $home_folder/waydroid-package-manager $home_folder/backup/skel/
   sudo chown -R $username $home_folder/backup
   echo -e "${IGre}  All set. You can find what was copied in $home_folder/backup ${RCol}"

}

# Wipe all of Waydroid current environmtnt, and re-init with a fresh version
doWipeWaydroidAndReinit(){
   echo -e "${IYel}  Cleaning Up and reiniting Waydroid ${RCol}"
   sudo rm -rf $wd_data_loc
   sudo waydroid init -f
   echo -e "${IGre}  All set. ${RCol}"
}

# Generate new skel and update yolk
doGenerateSkelAndLocals(){
   echo -e "${IYel}  Cleaning Up ${RCol}"
   sudo rm -rf /home/eggs/
   sudo rm -rf $build_folder/*.iso
   sudo rm -rf $build_folder/*.sha
   sudo rm -rf /etc/skel/
   sudo rm -rf /var/local/yolk
   sudo rm -rf /usr/local/yolk
   echo -e "${IYel}  Rebuilding skel and locals ${RCol}"
   sudo eggs calamares --install
   sudo eggs tools:skel
   sudo cp -Rp $home_folder/backup/skel/ /etc/
   echo -e "${IYel}  Removing blocklisted items ${RCol}"
   sudo rm -rf $BLOCKLIST
   echo -e "${IYel}  Updating yolk ${RCol}"
   sudo apt --purge autoremove
   if [ ! -d /var/local/yolk ]; then
      echo "Generating new yolk"
      sudo eggs dad -d
   elif [[ ! -d /usr/local/yolk ]] && [[ -d /var/local/yolk ]]; then
      echo "Copying yolk now"
      sudo cp -r /var/local/yolk /usr/local/
   elif [[ -d /usr/local/yolk ]] && [[ -d /var/local/yolk ]]; then
      echo "Refreshing yolk now"
      sudo rm -rf /usr/local/yolk
      sudo cp -r /var/local/yolk /usr/local/
   fi
   # read -p "press any key to continue"
}

# Cleanup old eggs packaged iso, then regenerate skell and repackage the iso
doWipeAndRebuild(){
   doGenerateSkelAndLocals

   # Remove added apps
   sudo apt remove $added_apps
   # Remove added snap apps
      sudo mv $home_folder/snap $temp_folder
   # Move ommitted apps
   for oapp in $ommitted_snap_apps; do
      mkdir -p $temp_folder/osnap
      sudo mv /var/lib/snap/$oapp $temp_folder/osnap/
   done
   # Remove added flatpak apps
   for pack in $added_flatpak_apps; do
      mkdir -p $temp_folder/flatpak
      sudo mv /var/lib/flatpak/app/$pack $temp_folder/flatpak/
   done
   # remove any added bloat before packaging
   sudo rm -rf /home/eggs/*.iso 
   echo -e "${IYel}  Refrying your eggs ${RCol}"
   sudo eggs dad
   echo -e "${IYel}  Moving .iso to a folder you can access ${RCol}"
   sudo mv /home/eggs/*.iso $build_folder
   sudo chown $username $build_folder/*.iso
   echo -e $(ls -a $build_folder/*.iso)
   echo -e "${IYel}  Restoring ommitted packages ${RCol}"
   sudo apt install $added_apps
   # Remove added snap apps
   sudo mv $temp_folder/snap $home_folder
   # Move ommitted apps
   for oapp in $ommitted_snap_apps; do
      sudo mv $temp_folder/osnap/$oapp /var/lib/snap/
   done   
   # Remove added flatpak apps
   for pack in $added_flatpak_apps; do
      sudo mv $temp_folder/flatpak/$pack /var/lib/flatpak/app/
   done
   # Install
   sudo apt update
   sudo apt --fix-broken install
   echo -e "${IGre}  All set. ISO can be found in $build_folder${RCol}"
}

# Begin Operations

if [ ! -f /usr/bin/eggs ]; then
	echo -e "${IRed}  penguins-eggs is not installed. Please install and try running again. ${RCol}"
	return 1
fi

# Verify folders are created and properly owned
if [ ! -d $build_folder ]; then
   echo "mkdir -p $build_folder"
   mkdir -p $base_build_folder
   mkdir -p $build_folder
   sudo chown -R $username $base_build_folder
fi 
if [ ! -d $temp_folder ]; then
   echo "mkdir -p $temp_folder"
   mkdir -p $temp_folder
   sudo chown -R $username $temp_folder
fi 

# Ask what command they want

# Display Options

echo -e "${IBlu}What do you want to do with eggs?${RCol}"
echo -e "${IBlu}  1 - Wipe & rebuild ISO${RCol}"
echo -e "${IBlu}  2 - Generate Backup Folder with your customizations${RCol}"
echo -e "${IBlu}  3 - Wipe Waydroid data and reinit waydroid images${RCol}"
echo -e "${IBlu}  4 - Generate just skel and locals${RCol}"

read -p "Input 1, 2, 3 or 4 for your selection: " choice

case $choice in
  1) echo -e "${IYel} $choice ${RCol}"
     doWipeAndRebuild 
     echo "";;
  2) echo -e "${IYel} $choice ${RCol}"
     doGenerateBackup 
     echo "";;
  3) echo -e "${IYel} $choice ${RCol}"
     doWipeWaydroidAndReinit 
     echo "";;
  4) echo -e "${IYel} $choice ${RCol}"
     doGenerateSkelAndLocals 
     echo "";;
  *) echo "Unrecognized selection: $choice"
     echo "" ;;
esac




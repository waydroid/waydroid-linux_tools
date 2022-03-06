#!/bin/bash

# Ubuntu Debloater

# A simple script to debloat Ubuntu, adapted from origonal to fit our needs
# source: https://www.reddit.com/r/Ubuntu/comments/ijbf4z/a_ubuntu_debloat_script/

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

sudo apt install ubuntu-gnome-desktop -y
sudo snap remove snap-store -y
sudo snap remove gtk-common-themes -y
sudo snap remove gnome-3-34-1804 -y
sudo snap remove core18 -y
sudo apt purge snapd -y
echo "${IBlu}Snap and Snapd are removed!${RCol}"
sudo apt-mark hold snap snapd
echo "${IBlu}Snap/Snapd are now blocked from Ubuntu!${RCol}"
sudo apt purge yelp -y
echo "${IBlu}The unhelpful help app is removed!${RCol}"
sudo apt purge gnome-sudoku -y
sudo apt purge gnome-mines -y
sudo apt purge gnome-mahjongg -y
echo "${IBlu}I dont know the pakage name of solitaire.${RCol}"
echo "${IBlu}but I removed all the gnome games${RCol}"
sudo apt install gnome-software -y
#~ sudo apt install gnome-shell gnome-cards-data libgtk2-perl cups-pdf smbclient unrar fonts-noto-cjk-extra desktop-base hplip-doc hplip-gui python3-notify2 lirc raptor2-utils rasqal-utils librdf-storage-postgresql librdf-storage-mysql librdf-storage-sqlite librdf-storage-virtuoso redland-utils gstreamer1.0-plugins-bad breeze-icon-theme fonts-crosextra-caladea fonts-crosextra-carlito sg3-utils samba python3-renderpm-dbg python-reportlab-doc remmina-plugin-exec remmina-plugin-spice remmina-plugin-www ttf-lyx libotr5 -y 
sudo apt purge gnome-software-plugin-snap -y
echo "${IBlu}Now you have a REAL SOFTWARE CENTER!${RCol}"
sudo apt purge thunderbird
sudo apt install -y flatpak gnome-software-plugin-flatpak
echo "${IBlu}FlatPak survived!${RCol}"
sudo apt purge shotwell -y
echo "${IBlu}i dont use shotwell${RCol}"
sudo apt purge seahorse -y
echo "${IBlu}seahorse removed${RCol}"
sudo apt purge remmina -y
echo "${IBlu}remmina removed${RCol}"
sudo apt purge gnome-sudoku gnome-mines gnome-mahjongg aisleriot -y
echo "${IBlu}gnome-sudoku removed${RCol}"
sudo apt purge libreoffice* -y
echo "${IBlu}libreoffice removed${RCol}"
sudo apt purge yelp* -y
echo "${IBlu}yelp removed${RCol}"
sudo apt purge evince -y
echo "${IBlu}evince removed${RCol}"
sudo apt purge thunderbird -y
echo "${IBlu}thunderbird removed${RCol}"
sudo apt purge gnome-todo  -y
echo "${IBlu}gnome-todo  removed${RCol}"
sudo apt purge rhythmbox rhythmbox-plugins rhythmbox-plugin-alternative-toolbar -y
echo "${IBlu}rhythmbox  removed${RCol}"
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y
echo "${IBlu}Now ubuntu is updated!${RCol}"
sudo apt install gnome-tweaks gnome-shell-extension-prefs -y
echo "${IBlu}Now you can customise GNOME${RCol}"
sudo apt purge evince -y
echo "${IBlu}evince/documents removed${RCol}"
sudo apt purge ubuntu-report popularity-contest apport whoopsie -y
sudo apt autoremove -y
echo "${IGre}Yay ubuntu stoped spying on you!${RCol}"


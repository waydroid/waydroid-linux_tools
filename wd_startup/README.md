# Waydroid Session Startup

These scripts are intended to aide in configuring and running the Waydroid-only sessions for Weston and Mutter

To install and test, clone the repo, and cd into the directory, then:

	sudo cp -R usr/* /usr/

## Folder Contents:

 - usr/share/wayland-sessions/* - contains the waydroid only session configs for Weston and Mutter
 - usr/bin/* - Contains two shell scripts for the Waydroid-only sessions, as well as the session launch script and configurator. 
 
## Configurator Options (requires session to be running to configure):
 - Fullscreen UI (default mode)
 - Kiosk Mode:
 	- Asks user what app they want to set to launch by default (after listing all installed apps)
 	- Allows user to hide the (a)Navbar, (b)Statusbar (c)Both or (d) Neither
 - Multiwindow Mode with visible desktop (Desktop Mode) !!Requires Mutter session!!
 - Reset all options to default

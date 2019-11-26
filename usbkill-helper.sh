#!/bin/bash

# set anybar 
function anybar { 
	# Colors
	# - white
	# - red
	# - orange
	# - yellow
	# - green
	# - cyan
	# - blue
	# - purple
	# - black
	# - question
	# - exclamation	
	echo -n $1 | nc -4u -w0 localhost ${2:-1738};
}

# root check
# if [ "$EUID" -ne 0 ]; then
# 	echo "Please run as root"
# 	exit
# fi

function uk_open {
	echo '
             _     _     _ _ _  
            | |   | |   (_) | | 
  _   _  ___| |__ | |  _ _| | | 
 | | | |/___)  _ \| |_/ ) | | | 
 | |_| |___ | |_) )  _ (| | | | 
 |____/(___/|____/|_| \_)_|\_)_)
                          helper
 '
 	echo
}

# Check if installed and version output
function uk_check_installed {
	installed=$(usbkill>/dev/null 2>&1)
	if $installed | grep "command"; then 
		echo "USBKill not installed."
		exit

	else
		sudo usbkill --version
		echo

	fi
}

# plist
function uk_check_plist {
	launchctl=$(sudo launchctl list USBKill)
	echo $launchctl
}

# continue with this?
function uk_check_status {
	pid=$(sudo launchctl list|grep USBKill|awk '{print $1}')
	if [ "$pid" = "-" ]; then
		status=0
		anybar white
	else
		status=1
		anybar exclamation
	fi	
	export pid
	export status
}

function uk_output_status {
    case $status in
        0)
			echo "Disabled"
			;;

		1) 	
			echo "Enabled | PID $pid"
            ;;
    esac
}

function uk_start {
	sudo launchctl start USBKill
	sleep 2
}

function uk_stop {
	sudo launchctl stop USBKill
	sleep 2
}

function uk_toggle {
	case $status in
		0)
			uk_start
			;;
		1)
			uk_stop
			;;
	esac	
}

# what are we doing?
function uk_init() {
	uk_open
	uk_check_status

    case $1 in
        plist)
			uk_check_plist
            ;;
        
        start)
            uk_start
            ;;

        stop)
            uk_stop
            ;;

        toggle)
			uk_toggle
            ;;
    esac
    uk_check_status
    uk_output_status
}

# lets go!
uk_init $1
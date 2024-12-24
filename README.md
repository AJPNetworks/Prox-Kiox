# Prox-Kiox (version 1.4.5) (Early Development)

## About

### This Project was idealized by a member of the Harvey's Virtual Environment Discord community and brought together by myself.  All credit for the idea goes the HSVE Community.

### Prox-Kiox is simply an install script that will essentially turn any Proxmox install into a kiosk setup, allowing for full UI managemnt of Proxmox from its main display out.

### It will install a window manager as well as Firefox in order to achieve this by opening a window automatically and placing it in full screen mode after navigating to the correct location, being http://127.0.0.1:8006.

### You can find more about Harvey's Virtual Environment at the following

### https://discord.gg/WGUdajWzxz

### https://hsve.org/

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Donate](#donate)
- [License](#license)

## Installation

### Automatic install

This may not work or may be instable

~`sh <(curl -sS https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh)`~

### WGET Download

Download the install script using wget

`wget https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/install.sh && chmod +x install.sh`

From here you can look at the usage section below to determine if its
necessary to modify the sleep times. After they have been changed or not
you can simply run the script using the following

`./install.sh`

### Manual Install

First, Update the running server with

`apt-get update && apt-get upgrade -y`

Next, we need to install the following dependencies

`apt-get install -y firefox-esr xinit x11-utils openbox`

An easy way to be able to call this script whenever is by creating a bash
command We first need to create the file that houses the script with the
following command and then nano into it.

`touch /usr/bin/prox-kiox && nano /usr/bin/prox-kiox`

The following code should be placed in the file

```bash
#!/bin/bash
KIOSK_URL=${KIOSK_URL:=https://127.0.0.1:8006}
if pgrep -x "firefox-esr" >/dev/null; then
    clear
    echo "Prox-Kiox already running"
    return 0
fi

profile_dir=$(find "$HOME/.mozilla/firefox/" -name "*.default-esr" -type d)
if [ -z "$profile_dir" ]; then
    echo ""
    echo "Firefox profile directory not found."
    return 1
fi
prefsfile="$profile_dir/sessionstore-backups"

rm -rf "${prefsfile:?}"/*

mode=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --kiosk)
            mode="kiosk"
            shift
            ;;
        *)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

nohup startx &
sleep 1
export DISPLAY=:0
sleep 1
nohup openbox &
while true; do
    result=$(xdpyinfo 2>&1)
    if [[ $result == *"unable to open display"* ]]; then
        echo "Display not available yet"
        sleep 0.25
    else
        echo "X server is running and display is available."
        sleep 0.25
        break
    fi
done
sleep 1

if [[ $mode = kiosk ]]; then
    nohup firefox-esr --kiosk "${KIOSK_URL}" &
else
    nohup firefox-esr "${KIOSK_URL}" &
fi

wait $!

if pgrep -x "xinit" >/dev/null; then
    echo "Killing xinit process"
    killall xinit
fi

if pgrep -x "firefox-esr" >/dev/null; then
    echo "Killing firefox-esr process"
    killall firefox-esr
fi
clear
echo "-----------------"
echo "Exiting Prox-Kiox"
echo "-----------------"
```

We need to ensure it can be ran so we will add execute permissions to it

`chmod +x /usr/bin/prox-kiox`

Now its all set up, we can go ahead and run the following to get it started

`prox-kiox`

Now you should be able to see FireFox running and the PVE webui screen.

## Usage

You can use either of the three methods to install but the most stable is
going to be with wget.

After installing, its as simple as running `prox-kiox` in the cli to get it
all started. We can also add `--kiosk` if we want it to be full screen and
feel more immersive.

## Uninstall

At any time, you may run the uninstaller script ant it will clean the
system of all packages that were installed and remove the autorun file so
there's no issues after the fact. You can do so with the following

`sh <(curl -sS https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/uninstall.sh)`

Or you may use the wget method as like above but using uninstall.sh
instead, like this

Download the install script using wget

`wget https://raw.githubusercontent.com/AJPNetworks/Prox-Kiox/main/uninstall.sh && chmod +x uninstall.sh`

From here you can look at the usage section below to determine if its
necessary to modify the sleep times. After they have been changed or not
you can simply run the script using the following

`./uninstall.sh`

Please not that these scripts do not delete themselves, so you will need to
run

```bash
rm /path/to/script/install.sh
rm /path/to/script/uninstall.sh
```

## Known Issues

None :)

## Donate

If you found this project helpful, please consider donating to the project
throu PayPal, always appreciated.

https://www.paypal.me/kn0t5

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE)
file for more information.

## Disclaimer

This project is experimental and not official. Any use of this project may
put your resources at a higher risk of failure. The publisher nor the
contributors shall hold any liability for any damages caused by the user or
the project. Use at your own risk.

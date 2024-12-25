#!/bin/bash

killall -q xinit
killall -q firefox-esr

rm -f /usr/bin/prox-kiox
rm -rf /root/.mozilla
rm -rf /etc/firefox-esr

apt-get remove -y firefox-esr xinit x11-utils openbox
apt-get autoremove -y

echo "Prox-Kiox Successfully Uninstalled. Sorry to see you go :(";

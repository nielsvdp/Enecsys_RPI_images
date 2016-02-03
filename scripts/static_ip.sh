#!/bin/bash

## Copyright (c) 2015 Jeroen van Marion <jeroen@vanmarion.nl>
##
## Permission to use, copy, modify, and distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##
## version	: 2.0
## language	: english
## date		: january 24 2016


getinfo()
{
  read -p "Set your router gateway ip address (NOT the enecsys gateway)(example: 192.168.10.1):  " routerip
  read -p "Set the netmask: (example: 255.255.255.0):  " netmask
  read -p "Set the ip of your raspberry: (vg: 192.168.10.23):  " staticip
}

writeinterfacefile()
{
cat << EOF > $1
# This file describes the network interfaces available on your system
# and how to activate them.
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
address $staticip
netmask $netmask
gateway $routerip

allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
EOF

  echo ""
  echo "The new settings will be applyed on the primary network interface in '$1' "
  echo "After a reboot you can find your rpi on this ipaddress: $staticip"
  echo ""
  exit 0
}

file="/etc/network/interfaces"
if [ ! -f $file ]; then
  echo ""
  echo "The file '$file' doesnt exists. "
  echo ""
  exit 1
fi

echo "This script is build to change the primary network settings with 3 questions"
echo ""

getinfo
echo ""
echo "Your new network settings:"
echo "Primary interface: eth0" 
echo "Router gateway:   $routerip"
echo "Netwerk mask: $netmask"
echo "Raspberry Ip address:   $staticip"
echo ""

while true; do
  read -p "Is dit correct? [y/n]: " yn
  case $yn in
    [Yy]* ) writeinterfacefile $file;;
    [Nn]* ) getinfo;;
        * ) echo "Verify with y or n";;
  esac
done

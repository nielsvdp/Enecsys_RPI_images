#!/bin/bash

## Copyright (c) 2016 Jeroen van Marion <jeroen@vanmarion.nl>
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
## version	: 2.4
## date		: february 3 2016
## features	: enecsys dashboard download and install
## cleanup of files after installation
## run download script for dashboard install
## run from home/pi directory with sudo !!

## working for dashboard version 2.3 OS: Debian Jessie

###########################################################################

## date format ##
today=$(date '+%d_%m_%Y_%H-%M-%S')

echo "Start in /home/pi directory"
echo "start downloading Enecsys Dashboard latest version from Github: "
echo ""

#go the pi home directory first
echo "Start in the home directory"
echo ""
cd /home/pi
mkdir dash_temp
cd /home/pi/dash_temp

#get latest files
wget https://github.com/nlmaca/Enecsys_Dashboard/archive/master.zip

#unpack the zip file
unzip master.zip

###### time to run setup
getinfo()
{
	read -p "set your webdirectory (vb /var/www/html/enecsys = enecsys): " webdirectory

}

writeinterfacefile()
{
# if config file exists, create a backup to the home/pi directory
file_config="/var/www/html/$webdirectory/inc/general_conf.inc.php"
if [ -e "$file_config" ]; then
	echo ""
    echo "Config File exists. Creating copy of it to your home directory"
	echo ""
	cp /var/www/html$webdirectory/inc/general_conf.inc.php /home/pi/BACKUP_general_conf.inc.php_$today
	chown pi:pi /home/pi/BACKUP_general_conf.inc.php_$today
	chmod 644 /home/pi/BACKUP_general_conf.inc.php_$today
else 
	echo ""
    echo "general_conf.inc.php does not exist. a new one will be created based on next questions"
	echo ""
fi 


#check if directory exists, else create it
if [ -d "/var/www/html/$webdirectory" ]; then
	echo "Directory already exists, old files will be removed and replaced with new ones"
	sudo rm -R /var/www/html/$webdirectory/*
	cd /home/pi/dash_temp/Enecsys_Dashboard-master
	sudo cp -R * /var/www/html/$webdirectory
	sudo chmod 777 /var/www/html/$webdirectory/inc/general_conf.inc.php
	echo ""
else 	
	sudo mkdir /var/www/html/$webdirectory
	cd /home/pi/dash_temp/Enecsys_Dashboard-master
	sudo cp -R * /var/www/html/$webdirectory
	sudo chmod 777 /var/www/html/$webdirectory/inc/general_conf.inc.php
	echo ""
fi

# temp zip will be deleted to keep things clean
rm -r /home/pi/dash_temp

echo "for all settings to be working, you need to reboot your raspberry when ready: sudo reboot"
echo ""
echo "After the reboot, Run the (web)installer on:"
IP=$(echo `ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`)
directory=/$webdirectory/INSTALL/install.php
result=$IP$directory
echo $result

exit 0
}

file="/var/www/html/$webdirectory/inc/general_conf.inc.php"

getinfo
echo ""
echo "Check if these settings are correct:"
echo "Webdirectory: $webdirectory"

while true; do
  read -p "Everything correct? [y/n]: " yn
  case $yn in
    [Yy]* ) writeinterfacefile $file;;
    [Nn]* ) getinfo;;
        * ) echo "Verify please with y or n";;
  esac
done



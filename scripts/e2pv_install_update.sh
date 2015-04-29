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
## version	: 1.1
## date		: april 26 2015
## features	: e2pv installation or update. retreive latest files from master branch. create and or backup current config.
## cleanup of files after installation
## run download script for e2pv setup
## run from home/pi directory as normal user

## updates: fixed some variables that needed to be ignored when creating the basic config


## todo: check if crontab exists. if exists, then skip, else create and echto. 
## crontab -l | grep -q '/home/pi/enecsys/e2pv.php'  && echo 'entry exists' || echo 'entry does not exist'

###########################################################################

## date format ##
NOW=$(date +"%F")
NOWT=$(date +"%T")


#get latest files / Credits: Omoerbeek :D
wget https://github.com/omoerbeek/e2pv/archive/master.zip

#unpack the zip file
unzip master.zip

#create the directory for it
#will give error if exists
mkdir /home/pi/enecsys

# check if config file exists to keep saved data
file_config="/home/pi/enecsys/config.php"
if [ -e "$file_config" ]; then
	echo ""
    echo "File exists. Creating copy"
	echo ""
	cp /home/pi/enecsys/config.php /home/pi/enecsys/config.php_original_$NOWT
else 
	echo ""
    echo "config.php does not exist. a new one will be created based on next questions"
	echo ""
fi 

cp e2pv-master/config.php e2pv-master/e2pv.php e2pv-master/LICENSE e2pv-master/README.md /home/pi/enecsys

# temp zip will be deleted to keep things clean
rm -r master.zip e2pv-master/

###### time to run setup

getinfo()
{
	read -p "Set the no of inverters:  " idcount
	read -p "Set your apikey from pvoutput:  " pvapikey
	read -p "Set your systemid from pvoutput:  " pvsystemid
	read -p "Set LIFETIME in [0/1] default =1:  " pvlifetime
	read -p "Send data as DC or AC default=0 (DC/AC) [0/1] :  " pvdcac
}

writeinterfacefile()
{
cat << EOF > $1
<?php
define('IDCOUNT', $idcount);
define('APIKEY', '$pvapikey');
define('SYSTEMID', '$pvsystemid');

define('LIFETIME', $pvlifetime);       // see README.md
define('MODE', 'AGGREGATE'); // 'AGGREGATE' or 'SPLIT'
define('EXTENDED', 0);       // Send state data? Uses donation only feature
// AC is default 0. See README.md
define('AC', $pvdcac);             // Send DC data or AC (DC * Efficiency)

// If mode is SPLIT, define the Enecsys ID to PVOutput SystemID mapping for each
// inverter.
//  \$systemid = array(
//  NNNNNNNNN => NNNNNN,
//  NNNNNNNNN => NNNNNN,
//  ...
//);

// If mode is SPLIT, optionally define the Enecsys ID to APIKEY mappings
// If an id is not found, the default APIKEY from above is used.
// \$apikey = array(
// NNNNNNNNN => 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
// NNNNNNNNN => 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
//);

// The following inverter ids are ignored (e.g. the neighbours' ones)
\$ignored = array(
// NNNNNNNNN,
// ...
);


// Optional MySQL defs, uncomment to enable MySQL inserts, see README.md
//define('MYSQLHOST', 'localhost');
//define('MYSQLUSER', 'myuser');
//define('MYSQLPASSWORD', 'mypw');
//define('MYSQLDB', 'mydbname');
//define('MYSQLPORT', '3306');
?>
EOF

echo ""
echo "The new settings are stored in '$1' "
echo ""
exit 0
}

file="/home/pi/enecsys/config.php"

clear
echo "Credits for the script: https://github.com/omoerbeek/e2pv"
echo "For detailed installation/configuration please check the github link"
echo "only basic settings, for advanced edit $file_config manually"
echo "All questions have to be set. there is no check on this"
echo "If you are updating and dont know your setting anymore you can find them  here: /home/pi/enecsys/config.php /home/pi/enecsys/config.php_original_$NOWT"
echo "" 

getinfo
echo ""
echo "Check if these settings are correct:"
echo "Nr of inverters: $idcount"
echo "Your apikey from pvoutput: $pvapikey"
echo "Your systemid from pvoutput: $pvsystemid"
echo "LIFETIME setting: $pvlifetime"
echo "Send data as DC or AC: $pvdcac"
echo ""

while true; do
  read -p "Everything correct? [y/n]: " yn
  case $yn in
    [Yy]* ) writeinterfacefile $file;;
    [Nn]* ) getinfo;;
        * ) echo "Verify please with y or n";;
  esac
done



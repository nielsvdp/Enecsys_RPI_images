# Enecsys_RPI_Images
is based on the need for a Solar Dashboard to monitor on a local server. to monitor the enecsys inverters 

I created a complete image for the raspberry pi. 

Tweakers topic: 
http://gathering.tweakers.net/forum/list_messages/1627615/0

i created the manual on the first page for a complete manual installation. but for users who dont have any experience it can be tricky. 

I will create more images, but this is the one that will only get the information from the enecsys gateway and send it straight
to pvoutput. 

#what does this image have
- its a raspbian wheezy (16-02-2015)
- its up to date and upgraded
- gpu memory is set to 16MB
- overclocked to 800Mhz (no heatsink needed)
- it has php5 installed for the script to run
- it has the cronjob already configured to be able to run the script
  @reboot php /home/pi/enecsys/e2pv.php
- it has a script installed to be able to easy configure your network (staticip.sh)
  can be downloaded seperate if you already have an image installed
- it has the e2pv easy install script installed. i only set it up with the basic requirements for pvoutput

* It does NOT contain the settings for the apache webserver or mysql settings. You have to manually install apache en mysql for that and reconfigure the /home/pi/enecys/config.php for that.

-- for more detailed information check the author of the script: 
https://github.com/omoerbeek/e2pv

#Download link:
https://mega.co.nz/#!ootwiJZB!4cwoCQckZ_u5OzetpweA4QDXkFWynx1GoazDB9vz_uM

unzip it, and write it your microSD card. Downsized the image so it fit on a 8GB card.

#Installation / Configuration

A raspberry pi B+ 512MB
8gb micro sd card

- unzip it and copy it to your sd card with win32diskmanager or any other tool. (it can take a while).
- from there on, put the sd in your rpi and start it up.
- track your rpi over the network to find its ip address (i used Fing (available for Apple/Android)

login through putty (change the ip address with the one you scanned on your network
http://i.imgur.com/ltiFSpv.jpg

```
user: pi
password: raspberry
```

from there on you're in the right directory. 

#Do you have a RPI 2 ?
before running the scripts below its best to upgrade first. The image can also be installed on a rpi 2. its best to upgrade the software after the image burn. 
follow the steps above about the login procedure. 
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
```
after this do a reboot first. 
```
sudo reboot
```

then you can proceed from the step below


#run script staticip

configure your network settings. set the rpi to a static ipaddress (run with sudo!!). this script will write the changes to your primary network interface, so be sure that they are right ;).

needed:
- Your router ipaddress (gateway) - NOT the enecsys gateway!
- subnetmask
- preferable ipaddress of your rpi (needs to be unused in your network), or the one you are using to connect to the pi.

```
sudo ./staticip.sh
```
example: http://i.imgur.com/Mm6Skez.jpg?1

Reboot the RPI to complete the changes and to check if the changes are correctly set after an reboot.

#run script e2pv_install_update

2nd script is the download, installation and configuration of omoerbeek his script to read the enecsys gateway and output the data to pvoutput. this script will only use the basic settings. for more advanced stuff check his github page. 

needed: 
- pvoutput account
- pvoutput apikey
- pvoutput systemid

run the script: (from /home/pi) as normal pi user
```
./e2pv_install_update.sh
```

follow the questions and you're all set. 

example: http://i.imgur.com/tGUUcKK.jpg


reboot the rpi for completing the install and automatic starting the cronjob.
```
sudo reboot
```

#enecsys gateway change
change the ipadress to your freshly installed rpi ipaddress, leave the port to 5040 and you should see data coming to your pvoutput account. give it about 10 -20 minutes. (need light of course 0; )

http://i.imgur.com/ubp9LMs.jpg

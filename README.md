# Enecsys_RPI_Images
is based on the need for a Solar Dashboard to monitor on a local server. to monitor the enecsys inverters 

Got many questions if the install procedure could be simplified without needing advanced knowledge. I hope i did a pretty good job on this

Tweakers topic: 
http://gathering.tweakers.net/forum/list_messages/1627615/0

I created 2 images cause there is a new release on debian OS. 
Debian Wheezy (+ install scripts separate for current users)
Debian Jessie (+ install scripts separate for new installs and current Jessie users)

#Image: Debian Wheezy & Jessie
- its up to date and upgraded (30-01-2016)
- gpu memory is set to 16MB
- overclocked to 900Mhz (no heatsink needed)
- it has php5, apache2, mysql, phpmyadmin pre installed

From there you can run the scripts which you can download separate for installing the e2pv script and the dashboard, as well as the other scripts needed to connect everything together
Download link: 
* unzip it, and write it to your micro(sd) card (minium 8GB size)

#Download link Wheezy: 
in progress

#Download link Jessie:
https://mega.nz/#!aJ9FkQrC

unzip it, and write it your microSD card. Downsized the image so it fit on a 8GB card.

#Installation / Configuration

A RPI B+ 512MB or RPI 2 1GB
8gb micro sd card

- unzip it and copy it to your sd card with win32diskmanager or any other tool. (it can take a while).
- from there on, put the sd in your rpi and start it up.
- track your rpi over your wifi network to find its ip address (i used Fing (available for Apple/Android)

login through putty (change the ip address with the one you scanned on your network
http://i.imgur.com/ltiFSpv.jpg

```
user: pi
password: raspberry
```

#scripts:
You can download these to your rpi and run them in this order with sudo rights:
works on both:
- static_ip.sh 
- reset_mysql_rootpass.sh
- create_database.sh
- e2pv_install.sh

works on Jessie:
- install_dashboard_jessie.sh

works on Wheezy:
- install_dashboard_wheezy.sh

For Jessie:
```
cd /home/pi
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/static_ip.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/reset_mysql_rootpass.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/create_database.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/e2pv_install.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/install_dashboard_jessie.sh
```
set them to executable
```
chmod +x static_ip.sh reset_mysql_rootpass.sh create_database.sh e2pv_install.sh install_dashboard_jessie.sh
```

For Wheezy:
```
cd /home/pi
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/static_ip.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/reset_mysql_rootpass.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/create_database.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/e2pv_install.sh
wget https://raw.githubusercontent.com/nlmaca/Enecsys_RPI_images/master/scripts/install_dashboard_wheezy.sh
```
set them to executable
```
chmod +x static_ip.sh reset_mysql_rootpass.sh create_database.sh e2pv_install.sh install_dashboard_wheezy.sh
```
#Note:
make sure to run the scripts in the correct order.some scripts has to run with sudo rights, but not all. Copy paste the commands should help you.

#1. run script static_ip.sh
this script will write the changes to your primary network interface, so be sure that they are right ;).

needed:
- Your router ipaddress (gateway) - NOT the enecsys gateway!
- subnetmask
- preferable ipaddress of your rpi (needs to be unused in your network), or the one you are using to connect to the pi.

```
sudo ./static_ip.sh
```

#2. run script reset_mysql_rootpass.sh
current mysql root password: d@mpDime27
change this one to one you like and save it. (you need the new passsword in step 3 and save it somewhere save)
```
sudo ./reset_mysql_rootpass.sh 
```

#3. run script create_database.sh
To be able to log the input of your inverters you need to create a new database for it. This can only be done as root mysql user, so you need the new password from step 2
Remember to save these credentials, cause you need them later on.
needed: the changed mysql root password (see step 2)
needed: databasename (think of one you like, or: enecsys)
needed: username (think of one you like or: enecsys)
needed: password (think of one you like)
```
sudo ./create_database.sh
```

#4. run script e2pv_install.sh (Don't run as sudo!!)
Time to setup the e2pv script. credits: https://github.com/omoerbeek/e2pv
Needed: mysql credentials from step 3 
needed: pvoutput apikey from your account
needed: pvoutput systemid
needed: how many inverters you have
```
./e2pv_install.sh
```

#5. isntall the dashboard
Time to install the latest dashboard (run with sudo!)
* This process also works for upgrades (it will remove the old files)
needed: to which directory you want to install (so you can see it in your browser as http://your_rpi_address/directory)
needed: mysql credentials from step2
```
sudo ./install_dashboard_jessie.sh
```
reboot the rpi for completing the install and automatic starting the cronjob.
```
sudo reboot
```


#6. enecsys gateway change
change the ipadress to your freshly installed rpi ipaddress, leave the port to 5040 and you should see data coming to your pvoutput account. give it about 10 -20 minutes. (need light of course 0; )

http://i.imgur.com/ubp9LMs.jpg

#7. Final step
reboot the raspberry to confirm all changes. 
```
sudo reboot
```
After the reboot you can find your dashboard on the url you got from the installer

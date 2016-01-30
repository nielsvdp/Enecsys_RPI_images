#!/bin/bash
 
echo -n "Enter the MySQL root password: "
read rootpw
echo -n "Set the new database name: "
read dbname
echo -n "Set the new database username: "
read dbuser
echo -n "Set the database user password: "
read dbpw
 
db="create database $dbname;GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpw';FLUSH PRIVILEGES;"
mysql -u root -p$rootpw -e "$db"
 
if [ $? != "0" ]; then
 echo "[Error]: Database creation failed"
 exit 1
else
 echo "------------------------------------------"
 echo " Database has been created successfully ,save these credentials!! "
 echo "------------------------------------------"
 echo " Ddatabase Info: "
 echo ""
 echo " Database Name    : $dbname"
 echo " Database User    : $dbuser"
 echo " Database Password: $dbpw"
 echo ""
 echo "------------------------------------------"

fi
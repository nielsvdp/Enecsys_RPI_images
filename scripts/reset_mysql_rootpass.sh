#!/bin/bash
 
echo -n "Enter the current MySQL root password: "
read rootpw
echo -n "Enter the new MySQL root password: "
read newrootpw

mysqladmin -u root -p$rootpw password $newrootpw
 
if [ $? != "0" ]; then
 echo "[Error]: MySQL user root password change failed. Run script again"
 exit 1
else
 echo "------------------------------------------"
 echo " Database has been created successfully "
 echo "------------------------------------------"
 echo " DB Info: "
 echo ""
 echo " Old root password: $rootpw"
 echo " New root password: $newrootpw"
 echo ""
 echo "------------------------------------------"
fi
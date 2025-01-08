#!/bin/bash

URL='https://www.tooplate.com/zip-templates/2131_wedding_lite.zip'
ART_NAME='2131_wedding_lite'
TEMPDIR="/tmp/webfiles"

# set Variables for Ubuntu 
PACKAGE="nginx wget unzip"
SVC="nginx"

echo "Running Setup"
# Installing nginx
echo "#########################################"
echo "Installing nginx"
echo "#########################################"
sudo apt update 
sudo apt-get -y install $PACKAGE > /dev/null
echo 

echo "#########################################"
echo "sart nginx service"
echo "#########################################"
sudo systemctl enable $SVC
sudo systemctl start $SVC
echo 

#Create temporary directory
echo "#########################################"
echo "Starting artifact deployment"
echo "#########################################"
mkdir -p $TEMPDIR
cd $TEMPDIR
echo 

wget $URL> /dev/null
unzip $ART_NAME.zip > /dev/null
sudo cp -r $ART_NAME/* /var/www/html

echo 

# Clean Up
echo "########################################"
echo "Removing Temporary Files"
echo "########################################"
rm -rf $TEMPDIR
echo "cleanup done"
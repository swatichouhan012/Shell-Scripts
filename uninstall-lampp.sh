#!/bin/bash

 #######################################
 # Bash script to uninstall an LAMP stack in ubuntu
 # Author: Swati Chouhan

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset
# Regular Colors
Green='\033[0;32m'        # Green

# Remove PHP
echo -e "$Green \n Removing php.... $Color_Off"
sudo apt-get remove --purge 'php*'

# Remove mysql
echo -e "$Green Removing mysql server.... $Color_Off"
sudo apt-get remove --purge 'mysql*'

# Remove phpmyadmin
echo -e "$Green Removing phpmyadmin.... $Color_Off"
sudo apt-get remove --purge 'phpmyadmin*'

#Remove Apache
echo -e "$Green Removing apache.... $Color_Off"
sudo apt-get remove --purge 'apache2*'

#Remove Global Drush
echo -e "$Green Removing global drush using composer... $Color_Off"
composer global remove drush/drush

#Remove Visual code
echo -e "$Green Removing global drush using composer... $Color_Off"
sudo apt-get remove --purge code
echo "Remove finish...."


 #!/bin/bash

 #######################################
 # Bash script to install an LAMP stack in ubuntu
 # Author: Swati Chouhan


 #COLORS
 # Reset
 Color_Off='\033[0m'       # Text Reset

 # Regular Colors
 Green='\033[0;32m'        # Green

 # Check if running as root

 if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
 fi
 # Ask value for mysql root password
 read -s -p 'db_mysql_password [secretpasswd]: ' db_mysql_password

 # Update system
 echo "$Green \n Updating system ... $Color_Off"
 sudo apt-get update

 ## Install APache2
 echo "$Green \n Installing Apache2.... $Color_Off"
 sudo apt-get install apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y

 ## Install PHP
 echo "$Green \n Installing PHP.... $Color_Off"
 apt-get install php libapache2-mod-php php-mysql -y

 # Install MySQL database server
 echo -e "$Green \n Installing MYSQL.... $Color_Off"
 export DEBIAN_FRONTEND="noninteractive"
 debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_mysql_password"
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_mysql_password"
 apt-get install mysql-server -y

 # Enabling Mod Rewrite
 echo "$Green \n Enable Mod Rewrite module.... $Color_Off"
 sudo a2enmod rewrite
 sudo php5enmod mcrypt

 ## Install PhpMyAdmin
 echo "$Green \n Installing Phpmyadmin.... $Color_Off"
 sudo apt-get install phpmyadmin -y

 ## Configure PhpMyAdmin
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

 # Set Permissions
 echo "$Green Setting permission.... $Color_Off"
 sudo chown -R www-data:www-data /var/www

 # Restart Apache
 echo "$Green \n Apache Restarting.... $Color_Off"
 sudo service apache2 restart

 # Install Visual code
 echo "$Green \n Installing Visual code editor.... $Color_Off"
 sudo apt-get install code

# Download latest composer snapshot and run it by php
echo "$Green \n Installing global composer... $Color_Off"
sudo wget https://getcomposer.org/composer.phar

# Move composer to /bin/composer
echo "$Green \n Moving Composer to /bin/composer... $Color_Off"
sudo mv composer.phar /bin/composer

# Install git
echo "$Green \n Installing git... $Color_Off"
sudo apt-get install git

# Check versions of all installed tools using loop.
for tools in 'php' 'mysql' 'code' 'git' 'composer' 'code'
  do
    $tools --version
  sleep 2
  done

echo "Finished Script...."

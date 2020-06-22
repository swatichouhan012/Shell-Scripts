#!/bin/bash

##################################
# BASH Shell script to create Multisite in drupal 8
# Author Swati Chouhan


# Reset
Color_Off='\033[0m'       # Text Reset
# Regular Colors
Green='\033[0;32m'        # Green

 # Check if running as root
if [ "$(id -u)" != "0" ]
	then
		echo "This script must be run as root"
		exit
fi

# Domain name
read -p "Enter domain name for multisite: " name
if [ -z "${name}" ];
	then
	 echo "Domain not should not be empty"
	 exit
fi

# Web root name
read -p "Enter Drupal root folder where you want to create multisite : " web_root
if [ -z "${web_root}" ];
	then
	 echo "Webroot directory should not be empty"
	 exit
fi

# Check web root
if [ -d "$web_root" ]
	then
		echo "Webroot directory exist..."
else
  echo "Directory is not exist...."
  exit
fi

# Create database for multisite
read -p "Enter mysql username: " mysql_un
read -p "Enter mysql password: " mysql_pw
read -p "Enter database name: " db_name
if mysql -u"$mysql_un" -p"$mysql_pw" -e "USE $db_name";then
  echo "Database exists"
else
  mysql -u"$mysql_un" -p"$mysql_pw" -e "CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8 COLLATE utf8_general_ci"
  echo "$db_name Database Created successfully..."
fi


email='webmaster@localhost'
site_enable='/etc/apache2/sites-enabled/'
sites_available='/etc/apache2/sites-available/'
sites_available_domain=$sites_available$name.conf
echo "Creating a vhost for $sites_available_domain with a webroot $web_root"

### create virtual host rules file
echo "
    <VirtualHost *:80>
      ServerAdmin $email
      ServerName $name
      DocumentRoot $web_root/web
      <Directory $web_root/web>
        Options Indexes FollowSymLinks
        AllowOverride all
      </Directory>
    </VirtualHost>" > $sites_available_domain
echo -e $" \nNew Virtual Host Created\n $Color_Off"

sed -i "1s/^/127.0.0.1 $name\n/" /etc/hosts

a2ensite $name
service apache2 reload

# Drupal multisite setup
sitesFile="$web_root/web/sites/sites.php"
sign='$'
ms="${sign}sites"

if [ -f "$sitesFile" ]; then
    cd "$web_root/web/sites"
    sudo mkdir $name
    sudo chmod -R 777 $name
    cp default/default.settings.php "$name/settings.php"

    sudo chmod -R 777 "$name/settings.php"

    cd "$name"
    #Add Database detail here

    echo "${sign}databases['default']['default'] = array (
      'database' => '$db_name',
      'username' => '$mysql_un',
      'password' => '$mysql_pw',
      'prefix' => '',
      'host' => 'localhost',
      'port' => '3306',
      'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
      'driver' => 'mysql',
    );" >> settings.php
  else
    cd "$web_root/web/sites"
    cp example.sites.php sites.php
    sudo chmod -R 777 "$sitesFile"
    #sed -i "1s/^/$sites['$name'] = '$name';\n/" sites.php
    echo "$ms['$name'] = '$name';" >> sites.php
    sudo mkdir $name
    sudo chmod -R 777 $name

    cp default/default.settings.php "$name/settings.php"

    sudo chmod -R 777 "$name/settings.php"

    cd "$name"
    #Add Database detail here

    echo "${sign}databases['default']['default'] = array (
      'database' => '$db_name',
      'username' => '$mysql_un',
      'password' => '$mysql_pw',
      'prefix' => '',
      'host' => 'localhost',
      'port' => '3306',
      'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
      'driver' => 'mysql',
    );" >> settings.php
fi

echo -e "$Green \nMultisite setup for $webroot done... please check at http://$name $Color_Off"

#!/bin/bash

##################################
# BASH Shell script to create virtual host
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
read -p "Enter domain name : " name
if [ -z "${name}" ];
	then
	 echo "Domain not should not be empty"
	 exit
fi

# Web root name
read -p "Enter full path of webfolder : " web_root
if [ -z "${web_root}" ];
	then
	 echo "Webroot directory should not be empty"
	 exit
fi

# Check web root
if [ -d "$web_root" ]
	then
		web_root_dir = "$web_root"
else
	echo "web root directory does not exist. Do you want to create ?";
	select directory in yes no
		do
			case $directory in
				yes)
					mkdir "$web_root"
					chown $USER:$USER "$web_root"
					chmod -R 777 "$web_root"
					cd "$web_root"
					touch index.php
					echo "<?php echo 'Welcome to $name' ?> " > index.php
					echo "Created directory /var/www/html/$web_root"; break;;
				no)
					echo "You selected no"; exit;;
				*)
					echo "Invalid choice";;
			esac
		done
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
      DocumentRoot $web_root
      <Directory $web_root/>
        Options Indexes FollowSymLinks
        AllowOverride all
      </Directory>
    </VirtualHost>" > $sites_available_domain
echo -e $" \nNew Virtual Host Created\n $Color_Off"

sed -i "1s/^/127.0.0.1 $name\n/" /etc/hosts

a2ensite $name
service apache2 reload

echo -e "$Green \nVirtual host created please check at http://$name $Color_Off"

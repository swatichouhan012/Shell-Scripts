#!/bin/bash

 #######################################
 # Bash script to Login aws using ssh
 # Author: Swati Chouhan

select site in drupal8 drupal_demo
do
  case $site in
      drupal8)
        #ssh -i ../aws/test2.pem ec2-user@ec2-3-133-109-224.us-east-2.compute.amazonaws.com
        ssh -i file.pem username@public_domain_name
        ;;
      drupal_demo)
        echo "Drupal demo selected"
      ;;
      *) echo "ERROR: Invalid selection"
      ;;
  esac
done

echo "Completed...."

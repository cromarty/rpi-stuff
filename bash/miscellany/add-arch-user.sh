#!/bin/bash
#
# Add a user and include all the necessary groups on Arch Linux.
# Takes a single argument which is the user name.
#


if [ $(id -u) -ne 0 ]; then
     echo "Script must be run as root, try 'sudo ./add-arch-user.sh'"
     exit 1
fi

if [ -z $1 ]; then
    echo "No user name provided, script will exit"
         exit 1
fi

echo "Adding the user: $1..."
useradd -m -g users -G audio,lp,storage,video,wheel,games,power -s /bin/bash $1
if [ $? -ne 0 ]; then
     echo "Failed to create the user: $1.  Script will exit"
          exit 1
fi

echo "Setting the password for user: $1..."
passwd $1
if [ $? -ne 0 ]; then
     echo "There was a failure setting the password for user: $1"
          exit 1
fi

echo "All done.  User $1 added successfully and password updated"





         
	 

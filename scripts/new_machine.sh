#!/bin/bash
set -eux

handle_exit() {
    echo ''
    echo 'Ctrl-C, exiting.'
    exit
}

trap 'handle_exit' INT

echo "Updating and upgrading..."
apt update
apt dist-upgrade -y
read -p "Install essential tools [y/N? " REPLY
if [[ $REPLY =~ ^[yY]$ ]]
then
    apt install -y sudo vim tmux git
fi
read -p "Name for new user (leave empty to skip): " REPLY
if ! [[ $REPLY =~ ^\s*$ ]]
then
    NEWUSER=$REPLY
    echo "Creating user $NEWUSER."
    useradd -m -U -s /bin/bash $NEWUSER
    echo "Set password for $NEWUSER"
    passwd $NEWUSER
    apt install -y sudo
    usermod -aG sudo $NEWUSER
    su - $NEWUSER
fi

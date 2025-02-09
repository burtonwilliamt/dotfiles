#!bin/bash
set -eu

handle_exit() {
    echo ''
    echo 'Ctrl-C, exiting.'
    exit
}

trap 'handle_exit' INT

cd ~
read -p "Do you want to install dotfiles? [Y/n]" -n 1 REPLY
if [[ $REPLY =~ ^\s*$ ]] || [[ $REPLY =~ ^[yY]$ ]]
then
    mkdir -p ~/github
    cd ~/github
    # TODO: Check if the dotfiles already exist.
    git clone https://github.com/burtonwilliamt/dotfiles.git
    cd dotfiles
    sh ./scripts/dotfiles.sh
fi

read -p "Do you want to setup docker? [Y/n]" -n 1 REPLY
if [[ $REPLY =~ ^\s*$ ]] || [[ $REPLY =~ ^[yY]$ ]]
then
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get -y install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world
fi

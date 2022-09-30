#!/bin/bash

sudo apt update && sudo apt upgrade -y &&
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install ca-certificates curl gnupg lsb-release git -y &&
sudo mkdir -p /etc/apt/keyrings &&
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update &&
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y &&

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo "Docker setup complete, please run './Noderunner.sh' to setup Cardano node, ogmios, kupo or Carp docker containers."


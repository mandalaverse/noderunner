#!/bin/bash

git clone https://github.com/CardanoSolutions/kupo
git clone https://github.com/CardanoSolutions/ogmios

docker build -t cnode-ogmios-kupo . &&

echo "To start the docker container please run the following command: "
echo "docker run -it --name cardano-node-ogmios -p 1337:1337 -p 1442:1442 -v cardano-node-ogmios-db:/db cnode-ogmios-kupo:latest"

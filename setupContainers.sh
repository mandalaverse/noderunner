#!/bin/bash

git clone https://github.com/CardanoSolutions/kupo
git clone https://github.com/CardanoSolutions/ogmios

docker build -t cnode-ogmios-kupo . &&

echo "To start the docker container please run the following command: "
echo "docker run -itd --name cardano-node-ogmios -p 1337:1337 -p 1442:1442 -v cardano-node-db:/db -v kupo-db:/kupodb cnode-ogmios-kupo:latest"
echo "If you want to see your services logs you can use command: docker logs -f cnode-ogmios-kupo:latest"


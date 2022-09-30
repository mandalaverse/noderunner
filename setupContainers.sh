#!/bin/bash

welcome () {
	echo "WELCOME TO NODERUNNER"
	echo "Your Cardano Stack Helper"
}

menu () {
	echo "MENU"
	echo "A: Spinup Cardano Node with Ogmios Docker container"
	echo "B: Spinup Kupo Docker Container"
	echo
	read menuItem

	if [ $menuItem == "A" ] || [ $menuItem == "a" ]; then
		ogmios
	else
		menu
	fi

	if [ $menuItem == "B" ] || [ $menuItem == "b" ]; then
		kupo
	else
		menu
	fi
}

ogmios () {
	git clone https://github.com/CardanoSolutions/ogmios &&
	cd ogmios &&
	docker build -t cardano-node-ogmios . &&
	echo "docker run -it --name cardano-node-ogmios -p 1337:1337 -v cardano-node-db:/db -v cardano-node-config:/config/cardano-node/config.json -v cardano-node-ipc:/ipc/node.socket cardano-node-ogmios"
}

kupo () {
	git clone https://github.com/CardanoSolutions/kupo &&
	cd kupo &&
	docker build -t kupo . &&
	exho "docker run -it --name kupo p 1442:1442 -v kupo-db:/db -v cardano-node-ipc:/ipc/node.socket -v cardano-node-config:/config/cardano-node/config.json kupo --node-socket /ipc/node.socket --node-config /config/cardano-node/config.json --host 0.0.0.0 --workdir /db"
}

welcome
menu

# docker run -it --name cardano-node-ogmios -p 1337:1337 -v cardano-node-db:/db -v cardano-node-config:/config/cardano-node/config.json -v cardano-node-ipc:/ipc/node.socket cardano-node-ogmios
# docker run -it --name kupo 				-p 1442:1442 -v kupo-db:/db 		-v cardano-node-ipc:/ipc/node.socket 					-v cardano-node-config:/config/cardano-node/config.json kupo --node-socket /ipc/node.socket --node-config /config/cardano-node/config.json --host 0.0.0.0 --workdir /db
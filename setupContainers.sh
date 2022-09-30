#!/bin/bash

welcome () {
	echo "WELCOME TO NODERUNNER"
	echo "Your Cardano Stack Helper"
}

menu () {
	echo "MENU"
	echo "A: Spin up Cardano Node with Ogmios Docker container"
	echo "B: Spin up Kupo Docker Container"
	echo "C: Spin up Carp indexer and Webserver(Not implmented yet")
	read menuItem

	if [ $menuItem == "A" ] || [ $menuItem == "a" ]; then
		ogmios
	elif [ $menuItem == "B" ] || [ $menuItem == "b" ]; then
		kupo
	else
		menu
	fi
}

ogmios () {
	git clone https://github.com/CardanoSolutions/ogmios &&
	cd ogmios &&
	docker build -t cardano-node-ogmios . &&
	echo "docker run -itd --name cardano-node-ogmios -p 1337:1337 -v cardano-node-db:/db -v cardano-node-config:/config/cardano-node -v cardano-node-ipc:/ipc cardano-node-ogmios"
}

kupo () {
	git clone https://github.com/CardanoSolutions/kupo &&
	cd kupo &&
	docker build -t kupo . &&
	exho "docker run -itd --name kupo -p 1442:1442 -v kupo-db:/db -v cardano-node-ipc:/ipc -v cardano-node-config:/config/cardano-node kupo --node-socket /ipc/node.socket --node-config /config/cardano-node/config.json --host 0.0.0.0 --workdir /db"
}

welcome
menu
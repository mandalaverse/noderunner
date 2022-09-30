#!/bin/bash

welcome () {
	echo "WELCOME TO"
	echo "#     # ####### ######  ####### ######  #     # #     # #     # ####### ######  
##    # #     # #     # #       #     # #     # ##    # ##    # #       #     # 
# #   # #     # #     # #       #     # #     # # #   # # #   # #       #     # 
#  #  # #     # #     # #####   ######  #     # #  #  # #  #  # #####   ######  
#   # # #     # #     # #       #   #   #     # #   # # #   # # #       #   #   
#    ## #     # #     # #       #    #  #     # #    ## #    ## #       #    #  
#     # ####### ######  ####### #     #  #####  #     # #     # ####### #     # "
	echo "Your Cardano Stack Helper"
}

menu () {
	echo "MENU"
	echo "A: Spin up Cardano Node with Ogmios Docker container"
	echo "B: Spin up Kupo Docker Container"
	echo "C: Spin up Postgresql for carp Indexer" 
	echo "D: Spin up Carp Indexer (Only indexs CIP25 metadata with label 721)"
	echo "E: Spin up Carp Wbserver to query metadata"
	echo
	read menuItem

	if [ $menuItem == "A" ] || [ $menuItem == "a" ]; then
		ogmios
	elif [ $menuItem == "B" ] || [ $menuItem == "b" ]; then
		kupo
	elif [ $menuItem == "C" ] || [ $menuItem == "c" ]; then
		postgresql
	elif [ $menuItem == "D" ] || [ $menuItem == "d" ]; then
		carp-indexer
	elif [ $menuItem == "E" ] || [ $menuItem == "e" ]; then
		carp-webserver			
	else
		menu
	fi
}

ogmios () {
	git clone https://github.com/onchainapps/ogmios &&
	cd ogmios &&
	docker build -t cardano-node-ogmios . &&
	echo "docker run -itd --name cardano-node-ogmios -p 1337:1337 -v cardano-node-db:/db -v cardano-node-ipc:/ipc -v cardano-node-config:/config cardano-node-ogmios"
}

kupo () {
	git clone https://github.com/onchainapps/kupo &&
	cd kupo &&
	docker build -t kupo . &&
	echo "docker run -itd --name kupo -p 0.0.0.0:1442:1442 -v kupo-db:/db -v cardano-node-ipc:/ipc -v cardano-node-config:/config kupo --node-socket /ipc/node.socket --node-config /config/cardano-node/config.json --host 0.0.0.0 --workdir /db --prune-utxo --since 16588737.4e9bbbb67e3ae262133d94c3da5bffce7b1127fc436e7433b87668dba34c354a"
}

postgresql () {
	echo "docker run -itd --name postgres -p 0.0.0.0:5432:5432 -v carp-postgres-db:/var/lib/postgresql/data -e POSTGRES_LOGGING=true -e POSTGRES_DB=carp -e POSTGRES_USER=carp -e POSTGRES_PASSWORD=carpdb postgres"
}

carp-indexer () {
	git clone https://github.com/onchainapps/carp &&
	cd carp &&
	docker build -t carp-indexer . &&
	echo "docker run -itd --name carp-indexer -v cardano-node-ipc:/app/node-ipc -e NETWORK=mainnet -e SOCKET=/app/node-ipc/node.socket -e DATABASE_URL=postgresql://carp:carpdb@localhost:5432/carp carp-indexer"
}

carp-webserver () {
	git clone https://github.com/onchainapps/carp &&
	cd carp/webserver &&
	docker build -t carp-webserver . &&
	echo "docker run -it --name carp-webserver --network host -e DATABASE_URL=postgresql://carp:carpdb@localhost:5432/carp carp-webserver"
}

welcome
menu
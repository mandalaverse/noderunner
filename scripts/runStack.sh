#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# cardano-node-ogmios.sh
#
#   Runs a cardano-node, ogmios and kupo instances side-by-side, and 'monitor' all processes. If one dies, exits.
#   This script is meant to be used within a container to provide a cardano-node+ogmios+kupo as a single service.
#   
# Usage: ./runStack.sh Kupo is set to prune UTXOs and only keep the most recent ones and to also sync for every,
#         address with at least one active UTXO since the shelley era.

ogmios \
  --host 0.0.0.0 \
  --node-config /config/cardano-node/config.json \
  --node-socket /ipc/node.socket &
ogmios_status=$?

if [ $ogmios_status -ne 0 ]; then
  echo "Failed to start ogmios: $ogmios_status"
  exit $ogmios_status
fi

kupo \
  --node-socket /ipc/node.socket \
  --node-config /config/cardano-node/config.json \
  --host 0.0.0.0 \
  --port 1442 \
  --since 4492799.f8084c61b6a238acec985b59310b6ecec49c0ab8352249afd7268da5cff2a457 \
  --match */* \
  --log-level Debug \
  --prune-utxo \
  --in-memory &

cardano-node run \
  --topology /config/cardano-node/topology.json \
  --database-path /db \
  --port 3000 \
  --host-addr 0.0.0.0 \
  --config /config/cardano-node/config.json \
  --socket-path /ipc/node.socket

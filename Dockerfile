#  This Source Code Form is subject to the terms: of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.
#                                                                              #
# ------------------------------- SETUP  ------------------------------------- #

# ------------------------------- SETUP ENV----------------------------------- #

ARG CARDANO_NODE_VERSION=1.35.3

FROM --platform=${TARGETPLATFORM:-linux/amd64} nixos/nix:2.11.0 as build

ARG CARDANO_CONFIG_REV=f1263df513f4cc5666bc49245e07fd3055097fee

RUN echo "substituters = https://cache.nixos.org https://hydra.iohk.io" >> /etc/nix/nix.conf &&\
    echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" >> /etc/nix/nix.conf

# ------------------------------- SETUP Ogmios Build Env---------------------- #
WORKDIR /app
RUN nix-shell -p git --command "git clone https://github.com/input-output-hk/cardano-configurations.git"

WORKDIR /app/ogmios
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install && cachix use cardano-ogmios
COPY ./ogmios/default.nix default.nix
COPY ./ogmios/server server
RUN nix-build -A platform.amd64 -o dist
RUN cp -r dist/* . && chmod +w dist/bin && chmod +x dist/bin/ogmios
COPY scripts scripts

WORKDIR /app/cardano-configurations
RUN nix-shell -p git --command "git fetch origin && git reset --hard ${CARDANO_CONFIG_REV}"

# ------------------------------- SETUP Ogmios Build Env---------------------- #
WORKDIR /app/kupo
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install && cachix use kupo
COPY ./kupo/ .
RUN nix-build -A kupo.components.exes.kupo -o dist
RUN cp -r dist/* . && chmod +w dist/bin && chmod +x dist/bin/kupo

#                                                                              #
# --------------------------- BUILD (ogmios) --------------------------------- #
#                                                                              #

FROM --platform=${TARGETPLATFORM:-linux/amd64} busybox:1.35 as ogmios

ARG NETWORK=mainnet

LABEL name=ogmios
LABEL description="A JSON WebSocket bridge for cardano-node."

COPY --from=build /app/ogmios/bin/ogmios /bin/ogmios
COPY --from=build /app/cardano-configurations/network/${NETWORK} /config

EXPOSE 1337/tcp
HEALTHCHECK --interval=10s --timeout=5s --retries=1 CMD /bin/ogmios health-check

STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/ogmios"]

#                                                                              #
# ---------------------------- BUILD (kupo) ---------------------------------- #
#                                                                              #

FROM --platform=${TARGETPLATFORM:-linux/amd64} busybox:1.35 as kupo

LABEL name=kupo
LABEL description="A fast, lightweight & configurable chain-index for Cardano."

COPY --from=build /app/kupo/bin/kupo /bin/kupo

EXPOSE 1442/tcp
STOPSIGNAL SIGINT
HEALTHCHECK --interval=10s --timeout=5s --retries=1 CMD /bin/kupo health-check
ENTRYPOINT ["/bin/kupo"]


#
#---------------BUILD CARP-----------------------#
#FROM rust:1.61 AS x-builder

#LABEL name=carpo
#LABEL description=""

#WORKDIR /indexer

#COPY ./carp/indexer ./

#RUN cargo build --release -p carp -p migration

#WORKDIR /ops

#RUN cp /indexer/target/release/carp .
#RUN cp /indexer/target/release/migration .

#COPY ./carp/indexer/genesis ./genesis
#COPY ./carp/indexer/execution_plans ./execution_plans

############################################################

#FROM debian:stable-slim AS carp
#ENV TZ=Etc/UTC
#ARG APP=/app
#COPY --from=x-builder /ops ${APP}
#WORKDIR ${APP}
#USER nonroot
#ENTRYPOINT ["./carp"]

#                                                                              #
# --------------------- RUN (cardano-node, ogmios, kupo) --------------------- #
#                                                                              #

FROM inputoutput/cardano-node:${CARDANO_NODE_VERSION} as cardano-node-ogmios

ARG NETWORK=mainnet
ENV TINI_VERSION v0.19.0

LABEL name=cardano-node-ogmios
LABEL description="A Cardano node, side-by-side with its JSON WebSocket bridge."

COPY --from=build /app/ogmios/bin/ogmios /bin/ogmios
COPY --from=build /app/kupo/bin/kupo /bin/kupo
COPY --from=build /app/cardano-configurations/network/${NETWORK} /config

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini && mkdir -p /ipc

WORKDIR /root

# Ogmios, Kupo, cardano-node, ekg, prometheus
EXPOSE 1337/tcp 1442/tcp 3000/tcp 12788/tcp 12798/tcp
HEALTHCHECK --interval=10s --timeout=5s --retries=1 CMD /bin/ogmios health-check

STOPSIGNAL SIGINT
COPY scripts/runStack.sh runStack.sh
ENTRYPOINT ["/tini", "-g", "--", "/root/runStack.sh" ]

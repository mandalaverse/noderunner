![image](https://user-images.githubusercontent.com/50184793/184235833-a1b4a0e7-c665-406e-834b-7ae530d62c8f.png)
![image](https://user-images.githubusercontent.com/50184793/193358575-f6c8834a-d919-48b6-973c-aa9490caa3ee.png)

<br/>
***If you are a Cardano tool developer and you would like to see your tool added to the Noderunner stack PLEASE feel free to create an issue and we will be extremly happy to accomodate your tools.***

<hr/>
<details>
  <summary><b>Instructions</b></summary>
  Noderunner currently only supports linux, what this really means though is I have only tested it on distros like Debian and openSuse.
  However since everything is setup to run on docker containers, I believe as long as you have docker installed on your system and follows the   traditional CLI commands, you sohuld be able to build the enviroment just using the Dockerfiles'.
  
 There is however two bash scripts included here. One will setup Docker for you currently only tested on Debain 11(`setupDockerDebian.sh`), and the second one is will help you setup the Docker containers.
 
 As mentined above, if you already have docker setup running the `Noderunner.sh` bash should be enough to get you going.
 
 First step first, clone this repo to wherever you want to run this stack on. <br/>
 Remember it is recomended you have at least 12GB Ram, Quad core CPU and 250GB SSD. <br/>
 I run this on a i3-10th Gen, 16GB Ram and 500GB NVME and it flys.
 
 Single Step: `git clone https://github.com/onchainapps/noderunner && cd noderunner && ./Noderunner.sh` <br/><br/>
  
 Step 1: `git clone https://github.com/onchainapps/noderunner`<br/>
 Step 2: `cd noderunner`<br/>
 Step 3: `./Noderunner` (Only if you have Docker Setup)  
  
 When you run the `Noderunner.sh` you should see the following menu.
 
![image](https://user-images.githubusercontent.com/50184793/193358570-e816646f-277b-4e9e-97e4-ee5acefadd60.png)
 
 You have to setup each of the services in the order they show up in the menu, but you are not required to set them all up.
 
 What this means is, Cardano node and Ogmios docker container is crucial for Kupo and Carp to function. However just having Ogmios already gives us a ton of usefull API calls to query the Cardano blockchain.
 
 Kupo, will build an index of every post shelly era address and their active UTXOs and keep track of them when they're spend.
 
 Carp, will build an index of all label 721 metadata on the chain so we can query it for NFT metadata of course. Carp currently is the biggest HD space hugger. But it's not because it's not efficient or anything like that, it's lightning fast and an amazing piece fo software.  It's just a very new piece of software so few things that are down dcSparks pipeline to help with this.
 
 Even though CARP uses Oura under the hood, it's missing one config params that we can pass the since param, and when creating tasks we're not allowed to tell it to only save blocks that have TXs with metadata label 721.
 
 What happens now is, CARP saves every single blocks information to the DB wetehr it has metadata in it or not and it does it from the beggening of the chain, however it does only save metadata for label 721 😁. Anyways once dcSPark releases an update with these changes you will be able to update your docker container, might require a DB wipe.
 
 With all this said, Kupo has plans and methods to also pull metadata for a NFT from the chain, currently it's a bit more complex but it is possible. So what does this give us. Well as I mentioned aboce even though CARP is an amazing piece of software, if you're just after needing UTXO, Datum and NFT metadata info. In the future when Kupo has full metadata indexing iplemented it might be better to more efficient to just run a full Cardano Node/Ogmios/Kupo stack, and no worry about having to spin up the postgresql and CARP docker containers. Becasue in this case CARP is a bit over kill just so you can have your FT/NFT metadata.
 
 However CARP will always be part of the Noderunner stack and always available and kept current you never know what your dapp requirments might be :).
</details>
<hr/>

**Left to do**

- [x] Create a docker container that will run the, *Cardano node, Ogmios, Kupo*, Stack by default and Carp/Oura as an option.

- [x] Add Carp/Oura as start up option after specifing execution plans and also start the web-server api to search CARP db.
 
- [x] Create bash scripts that will install the whole stack on a slew of operating systems and CPU architectures(Partially done).

- [ ] Create simple web interface that'll allow you to administer the services.

- [ ] Add IPFS gateway as option to stack.

<hr/>
<details>
  <summary><b>Mission and Current situation</b></summary>

Currently if you're building a dapp on cardano you have one of few choices on how to aggregate the Cardano blockchain data your dapp might need to function properly.

One of the most widely used and easiest solution thus far has been dbSync. However, using dbSync is rather resource intensive and even after full sync still takes up quite a bit of HD space and takes quite a while to sync on top of need the cardano node to sync as well.

There is also services like Blockfrost where a user can sign up for an account, receive an API key and use blockfrost REST API to access whatever data you might need but it doesn't really give you a dApp and if Blockfrost services go down so does your dApp.

However, there are several projects developed as of recent that give you the power of dbSync and are more efficient and a lot less cumbersome on resource utilization. They are not replacements for dbSync per say and usually you have to bundle one or two of these services together to achieve what DB sync offers in one service. Yet, in return there can be 3 or 4 micro-services for example that still take up and use a lot less resources then dbSync does.

For example DB sync system requirements currently are:
```
32 Gigabytes of RAM or more.
4 CPU cores or more.
160 Gigabytes or more of disk storage. (Note this is without full cardano node sync which adds extra 60Gb or so for about a total of 220Gb right out the door.)
```

Noderunner:
```
12 Gigabytes of RAM or more.
4 CPU cores or more
160Gb or more this is with a full cardano-node synced and Kupo with every shelley erra address and their current UTXOs and monitors for changes it has ```--prune-utxo``` flag turned on.
```

The idea for Noderunner is to have a reusable development stack that's easily replicatable by the end user as well or any developer. Where a dApp developer can give the end user the option to connect to their own self hosted version of Noderunner. Think of [LAMP](https://en.wikipedia.org/wiki/LAMP_%28software_bundle%29) stack which you can download linux distros that have the stack pre-installed ready for developers to start building their applications. 



The three major components of Noderunner are: Cardano Node, Ogmios, Kupo. All three pieces of software are open source and are developed by Cardano developers for Cardano developers. 

With these three tools running you will be able to have access to full UTXO history of an address, when they were created and spent, you can search by address or even by datum hash. You will also have access to assets metadata as long as they were created under the Metadata label 721.

And you will have access to data like Pool information, pool delegators, stake address information on which pool it's delegating too all for a fraction of a cost in resources DB sync takes and absolutely a LOT more feasible for a user to run at home.
</details>

**Components explained**

<details>
  <summary><b>Ogmios</b></summary>

![ogmios-logo-white](https://user-images.githubusercontent.com/50184793/184235372-8b563be8-c368-43c6-a87b-fceda0710e5a.png)
https://github.com/CardanoSolutions/ogmios – by Cardano Solutions developed by KtorZ:

Ogmios is a lightweight bridge interface for cardano-node. It offers a WebSocket API that enables local clients to speak Ouroboros' mini-protocols via JSON/RPC.

Ogmios plays several key rolls in Noderunner Eco system. Number one it connects directly to Cardano Nodes IPC socket and most importantly can aggregate requested information from Cardano Node based on the JSON RPC call you specify. With Ogmios you can information like: 
```
-blockHeight: The chain’s highest block number.
-chainTip: The chain’s current tip.
-currentEpoch: The current epoch of the ledger.
-currentProtocolParameters: The current protocol parameters.
-delegationsAndRewards: Current delegation settings and rewards of given reward accounts.
-eraStart: The information regarding the beginning of the current era.
-eraSummaries: Era bounds and slotting parameters details, required for proper slot arithmetic.
-genesisConfig: Get a compact version of the era’s genesis configuration.
-ledgerTip: The most recent block tip known of the ledger.
-nonMyopicMemberRewards: Non-myopic member rewards for each pool. Used in ranking.
-poolIds: The list of all pool identifiers currently registered and active.
-poolParameters: Stake pool parameters submitted with registration certificates.
-poolsRanking: Retrieve stake pools ranking (a.k.a desirabilities).
-proposedProtocolParameters: The last update proposal w.r.t. protocol parameters, if any.
-rewardsProvenance: Get details about rewards calculation for the ongoing epoch.
-stakeDistribution: Distribution of the stake across all known stake pools.
-systemStart: The chain’s start time (UTC).
-utxo: Current UTXO, possibly filtered by output reference.
```
For more on Omgios and its API please visit: https://ogmios.dev/

**Sync Time**
There is no sync time for Ogmios.
</details>

<details>
  <summary><b>Kupo</b></summary>
  
![kupo](https://user-images.githubusercontent.com/50184793/184235554-51547d71-41e4-498c-a681-ed15f60799ca.png)
<hr/>
https://github.com/CardanoSolutions/kupo by Cardano Solutions developed by KtorZ:

Kupo is fast, lightweight and configurable chain-index for the Cardano blockchain. It synchronizes data from the blockchain according to patterns matching addresses present in transaction outputs and builds a lookup table from matches to their associated output references, values and datum hashes.

Kupo is one of my favorite tools on Cardano. With the fact that being able to query the cardano node for UTXOs by Address is being deprecated Kupo becomes almost a must have tool for any Cardano developer.

With Kupo you are able to sync a index of Addresses and their UTXO state. It’ll flag unspent UTXOs for an address and it will flag spent ones and also tell you when when they were spent and which TX.

Kupo also goes a step further for the vasil/Babbage era and it will also lets you search UTXOs by their datum hash.

Kupo can also search whch synced addresses hold a policy id and or asset you specify.

Kupo in the very near future will also have an API end point to search for Policy/Asset Metadata making it pretty much a one stop shop

**Connection and Sync time**
Kupo can connect to either your Ogmios instance or through your Cardano nodes IPC socket to sync it’s database. Kupo takes about 24 hours to sync if you start from the Shelley ERA. And takes about 45Gb of hd space on Mainnet with every single address and it’s UTXO indexed currently existing on Cardano blockchain. However if you use the flag to prune used UTXOs and only keep the active ones it only has a 5.1GB foot print!!!
</details>

<details>
  <summary><b>Carp/Oura</b></summary>
  
https://dcspark.github.io/carp by Dc Spark <br />
https://github.com/txpipe/oura/releases by TxPipe Development lead by scarmuega

So why bundle Carp and Oura under the same category even though they're developed by two different groups?

Well, main reason is cause Cardano eco system is pretty fucking bad ass and developers like to collaborate. 

But also because Carp runs Oura under the hood to aggregate the data from cardano-node, then Carp takes this information and neatly places it into postgre sql for us.

Oura is a rust-native implementation of a pipeline that connects to the tip of a Cardano node through a combination of Ouroboros mini-protocol (using either a unix socket or tcp bearer), filters the events that match a particular pattern and then submits a succint, self-contained payload to pluggable observers called "sinks".

**Connection and Sync time**
Oura in Noderunner instance connects N2C to Cardano nodes socket directly to aggregate the mainnet asset metadata and it’s final database takes up about 4.5Gb of hd space and takes about 24hours to sync.
</details>

<details>
  <summary><b> Conclusion</b></summary>

With these three services and Cardano Node we are able to aggregate and create a small Eco system for our selves where we have access to pretty much all data that should suffice for majority of dapps created or being created at a fraction of the resources cost if you were needing to spin up db sync.

Now you will still need to sync your Cardano Node which takes the longest of the three to sync up and is the most resource heavy.

We will also provide DB boot strapping services for each service mentioned if you so choose to use them.

</details>

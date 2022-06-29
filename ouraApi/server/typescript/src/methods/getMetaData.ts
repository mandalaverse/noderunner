import { GetMetaData } from "../generated-typings";
import { MongoClient } from 'mongodb';

const getMetaData: GetMetaData = (policyID, assetName) => {
  return Promise.resolve(
    mongoDbGetAsset(policyID, assetName)
  );
};

const mongoDbGetAsset = async ( policyID: string, assetName: string ) => {
  // Connection URL
  const url = 'mongodb://localhost:27017';
  const client = new MongoClient(url);
  const dbName = 'nftmetadata';

  await client.connect();
  console.log('Connected successfully to server');
  const db: any = client.db(dbName);
  const collection: any = db.collection('testnet');

  const findResult: any = await collection.find({}, {"metadata.map_json.68f160cd5597a4e0253b227e44e07aa81c79264bd8b424f9baa0c87d.Test952": 1, "_id": 0}).toArray();
  console.log('Found documents =>', findResult);

  return(findResult);
};

export default getMetaData;

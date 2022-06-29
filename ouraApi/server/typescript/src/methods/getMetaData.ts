import { GetMetaData } from "../generated-typings";
import { MongoClient } from 'mongodb';

const getMetaData: GetMetaData = (policyID, assetName) => {
  return Promise.resolve(
    mongoDbGetAsset(policyID, assetName)
  );
};

const mongoDbGetAsset: GetMetaData = async (policyID, assetName) => {
  // Connection URL
  const url = 'mongodb://localhost:27017';
  const client = new MongoClient(url);
  const dbName = 'nftmetadata';

  await client.connect();
  console.log('Connected successfully to server');
  const db = client.db(dbName);
  const collection = db.collection('testnet');

  const findResult: any = await collection.find({}).toArray();
  console.log('Found documents =>', findResult);

  return(findResult);
};

export default getMetaData;

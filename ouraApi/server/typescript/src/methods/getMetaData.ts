import { GetMetaData } from "../generated-typings";
import { MongoClient } from 'mongodb';

const getMetaData: GetMetaData = (policyID, assetName) => {
  return Promise.resolve(
    mongoDbGetAsset(policyID, assetName)
  );
};

const mongoDbGetAsset = async ( policyID: any, assetName: any ) => {
  // Connection URL
  const url = 'mongodb://localhost:27017';
  const client = new MongoClient(url);
  const dbName = 'nftmetadata';

  await client.connect();
  console.log('Connected successfully to server');
  const db: any = client.db(dbName);
  const collection: any = db.collection('testnet');
  const obj: any = `metadata.map_json.${policyID}.${assetName}`;
  console.log(obj);
  const findResult: any = await collection.find({ [obj]: { $exists: true } }).toArray();
  
  console.log('Found documents =>', findResult);

  return(findResult);
};

export default getMetaData;

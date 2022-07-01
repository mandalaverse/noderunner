import { GetMetaData } from "../generated-typings";
import { MongoClient } from 'mongodb';
require('dotenv').config();

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
  const collection: any = db.collection(process.env.COLL);
  const obj: any = `metadata.map_json.${policyID}.${fromHex(assetName)}`;
  console.log(obj);
  const findResult: any = await collection.find({ [obj]: { $exists: true }}, { projection: { [obj]: 1 }}).toArray();
  
  console.log('Found documents =>', findResult);

  return(findResult);
};

export const fromHex = ( hex: any ) => Buffer.from( hex, "hex" );

export default getMetaData;

export type PolicyID = string;
export type AssetName = string;
export type StringDoaGddGA = string;
/**
 *
 * Generated! Represents an alias to any of the provided schemas
 *
 */
export type AnyOfPolicyIDAssetNameStringDoaGddGA = PolicyID | AssetName | StringDoaGddGA;
export type GetMetaData = (policyID: PolicyID, assetName: AssetName) => Promise<StringDoaGddGA>;
# Policy Object

## Summary
The Policy Object is defined by the client at the time of the payload's encryption. It contains the information required by the KAS to make an access decision during decryption.  The policyObject is stored in the [manifest.json](manifest-json.md) for a TDF, and sent to the KAS along with an entity object so that the KAS may make an access decision.

The KAS uses the Policy Object to make its decision to grant access to the TDF payload.  The entity or user requesting access must be in the `dissem` (dissemination) list _AND_ must possess  entity attributes (as returned by the EAS) that satisfy all the data [Attributes](AttributeObject.md).

## Example

```javascript
{
"uuid": "1111-2222-33333-44444-abddef-timestamp",
"body": {
    "dataAttributes": [<Attribute Object>],
    "dissem": ["user-id@domain.com"]
  },
"tdf_spec_version:": "x.y.z"
}
```

## uuid

|Parameter|Type|Description|
|---|---|---|
|`uuid`|String|A unique [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) for the TDF's policy.|

## body

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`body`|Object|Object which contains information about the policy required for the KAS to make an access decision.|Yes|
|`body.dataAttributes`|Array|An array of attributes a user would need to request access to key. In other words, attributes a user must possess to be able to decrypt the content. An Attribute Object is defined in defined in its own section: [Attribute Object](AttributeObject.md).|Yes|
|`body.dissem`|Array|An array of unique userIds. It's used to explicitly list users/entities that should be given access to the payload, and should be given as an id used to authenticate the user against the EAS.|Yes|

## schemaVersion

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|No|

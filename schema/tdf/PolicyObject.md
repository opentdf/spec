# Policy Object

## Summary

The Policy Object is defined by the client at the time of the TDF creation. It contains the information required by a Policy Enforcement Point (PEP) to make an access decision. The Policy Object is stored in the [manifest.json](Manifest.md) for a TDF.

A PEP uses the Policy Object to decide whether to grant access to the TDF payload. The entity or user requesting access must be in the `dissem` (dissemination) list _AND_ must possess entitlements that satisfy all the data [Attributes](AttributeObject.md).

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
|`body`|Object|Object which contains information about the policy required for the PEP to make an access decision.|Yes|
|`body.dataAttributes`|Array|An array of attributes a user needs to request access. An Attribute Object is defined in its own section: [Attribute Object](AttributeObject.md).|Yes|
|`body.dissem`|Array| An array of unique user IDs. It is used to explicitly list users/entities that should be given access to the payload.|Yes|

## tdf_spec_version

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|No|

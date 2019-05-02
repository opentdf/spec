# Attribute Object

## Summary
An Attribute Object contains attribute information the TDF3 system uses to enforce access control. Attributes are used in both a [Policy Object](PolicyObject.md) as well as an [Entity Object](EntityObject.md). _How_ the attributes are used to grant/revoke access to decrypt a payload is determined by the EAS. The KAS, in turn, ensures that the entity attempting to decrypt has been granted this access.

The object contains a URL which acts as a reference for the attributes (to be implemented), as well as with a collection of attribute values. The attributes defined therein are used in determining access.

## Version

The current schema version is `1.0.0`.

## Example

```javascript
{
  "attribute": "https://example.com/attr/Classification/value/ts",
  "displayName": "classification",
  "pubKey": "pem encoded public key of the attribute",
  "kasURL": "https://kas.example.com/",
  "schemaVersion:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`attribute`|String|The unique resource locator of the attribute that this EAS supports/issues. Represented in the form of a URL.|Yes|
|`displayName`|String|Human readable name of the attribute.|Yes|
|`publicKey`|PEM|PEM encoded public key of the KAS that can make policy decisions for this attribute.|Yes|
|`kasURL`|URL|Base URL of the KAS that can make access control decisions for this attribute.|Yes|
|`schemaVersion`|String|Version number of the AtributeObject schema.|No|

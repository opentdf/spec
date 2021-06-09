# Attribute Object

## Summary
An Attribute Object contains attribute information the TDF system uses to enforce access control. Attributes are used in both the [PolicyObject](PolicyObject.md) to define the attributes that a subject "needs" to gain access in an ABAC sense, and in the [ClaimsObject](ClaimsObject.md) to assert the attributes that a subject "has" to satisfy the ABAC needs.

The _attribute_ field must be both unique and immutable as it is the reference id for the attribute. All of the other fields are mutable. The attribute string contains three pieces of information - the authority namespace (https://example.com), the attribute name (classification), and the attribute value (topsecret).

The public key is used to wrap the object key or key splits on TDF file creation. On decrypt, the kasUrl defines where this key or key split can be rewrapped. For policies that do not include attributes these values are extracted from a _default_ attribute. Every [ClaimsObject](ClaimsObject.md) to a subject who may write attribute-free policies should include one and only one _default_ attribute.

The AttributeObject does not define how the attribute will be used. The KAS uses attribute policies from the cognizant authority to make its policy decisions. Clients writing policies should use best available information from their organizations to select which AttributeObjects to include to protect the policy.  

## Version

The current schema version is `4.0.0`.

## Example

```javascript
{
  "attribute": "https://example.com/attr/classification/value/topsecret",
  "isDefault": true,
  "displayName": "classification",
  "pubKey": "pem encoded public key of the attribute",
  "kasUrl": "https://kas.example.com/",
  "schemaVersion:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`attribute`|String|Also known as the "attribute url."  The unique resource name for the attribute represented as a case-insensitive URL string.  |Yes|
|`isDefault`|Boolean|If "true" this flag identifies the attribute as the default attribute. If missing (preferred) or false then the attribute is not the default attribute.|No|
|`displayName`|String|A human-readable nickname for the attribute for convenience.|Yes|
|`pubKey`|PEM|PEM encoded public key for this attribute. Often other attributes will use the same pubKey.|Yes|
|`kasUrl`|URL|Base URL of a KAS that can make access control decisions for this attribute.|Yes|
|`schemaVersion`|String|Version number of the AttributeObject schema.|No|

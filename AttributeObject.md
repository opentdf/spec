# Attribute Object

## Summary
An Attribute Object contains attribute information the TDF3 system uses to enforce attribute-based access control (ABAC). Attributes are used in both the [PolicyObject](PolicyObject.md) to define the attributes that a subject "needs" to gain access in an ABAC sense, and in the [ClaimsObject](ClaimsObject.md) to assert the attributes that an actor "has".
Access decisions are made by comparing the attributes a subject has with the attributes a policy requires.

Attributes that a subject (or actor, or entity) "has" are referred to as "subject attributes".

Attributes that subjects "need" in order to access data are referred to as "object attributes".

The _attribute_ field must be both unique and immutable as it is the reference id for the attribute. All of the other fields are mutable. The attribute string contains three pieces of information - the authority namespace, the attribute name, and the attribute value.

When encrypting, the client determines which attributes a subject must have in order to decrypt the payload and applies those attributes to the file's [Policy Object](PolicyObject.md).

When a decrypt is requested, the KAS checks the [Policy Object](PolicyObject.md) against the [Claims Object](ClaimsObject.md) from the requesting client to 
ensure the attributes that an entity "has" satisfies those that an entity "needs".

If this check succeeds, the KAS permits a decrypt operation and returns a valid key which the client can decrypt and use to expose the file contents.

The public key is used to wrap the object key or key splits on TDF3 file creation. On decrypt, the kasUrl defines where this key or key split can be rewrapped.

The AttributeObject alone does not define how the KAS will compare a subject attribute to an object attribute when making an access decision.
The KAS uses the namespaced object attributes in the [PolicyObject](PolicyObject.md) look up attribute policies from the cognizant authority
to make its policy decisions. Clients writing policies should use best available information from their organizations to select which AttributeObjects to include to protect the policy.

## Example

```javascript
{
  "attribute": "https://example.com/attr/classification/value/topsecret",
  "isDefault": true,
  "displayName": "classification",
  "pubKey": "pem encoded public key of the attribute",
  "kasUrl": "https://kas.example.com/",
  "tdfVersion:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`attribute`|String|Also known as the "attribute url."  The unique resource name for the attribute represented as a case-insensitive URL string. This field must be both unique and immutable as it is the reference id for the attribute. The attribute URL string contains three pieces of information - in the above example, the authority namespace (https://example.com), the attribute name (classification), and the attribute value (topsecret). |Yes|
|`isDefault`|Boolean|If "true" this flag identifies the attribute as the default attribute. If missing (preferred) or false then the attribute is not the default attribute.|No|
|`displayName`|String|A human-readable nickname for the attribute for convenience.|Yes|
|`pubKey`|PEM|PEM encoded public key for this attribute. Often other attributes will use the same pubKey.|Yes|
|`kasUrl`|URL|Base URL of a KAS that can make access control decisions for this attribute.|Yes|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|No|


# Attribute Object

## Summary
An Attribute Object contains attribute information the TDF system uses to enforce attribute-based access control (ABAC). 

Attributes are used in both the [Policy Object](PolicyObject.md) to define the attributes that an entity "needs" to gain access to data in an ABAC sense, 
and in the [Entitlement Object](EntitlementObject.md) to assert the attributes that an entity "has".

Access decisions are made by comparing the attributes all entities have with the attributes a data policy requires.

Attributes that an entity (or actor, or subject) "has" are referred to as "entity entitlements" and are represented by [Entitlement Objects](EntitlementObject.md) 

Attributes that entities "need" in order to access data are referred to as "data attributes" and are represented by [Policy Objects](PolicyObject.md)

The set of all entity entitlements involved in a request are referred to as "claims" and are represented by a [Claims Object](ClaimsObject.md) 

The _attribute_ field must be both globally unique and immutable as it is the reference id for the attribute. 
All of the other fields are mutable. The attribute string contains three pieces of information - the authority namespace, the attribute name, and the attribute value.

When encrypting, the client determines which attributes an entity must have in order to decrypt the payload and applies those attributes to the file's [Policy Object](PolicyObject.md).

When a decrypt is requested, the KAS checks the [Policy Object](PolicyObject.md) against the [Claims Object](ClaimsObject.md) from the requesting client to 
ensure the attributes that an entity "has" satisfies those that an entity "needs".

If this check succeeds, the KAS permits a decrypt operation and returns a valid key which the client can decrypt and use to expose the file contents.

The AttributeObject alone does not define how the KAS will compare an entity's attribute to an object attribute when making an access decision.
The KAS uses the namespaced object attributes in the [Policy Object](PolicyObject.md) to look up attribute policies from the cognizant authority
to make its policy decisions. Clients writing policies should use best available information from their organizations to select which AttributeObjects to include to protect the policy.

## Example

```javascript
{
  "attribute": "https://example.com/attr/classification/value/topsecret"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`attribute`|String|Also known as the "attribute url."  The unique resource name for the attribute represented as a case-insensitive URL string. This field must be both unique and immutable as it is the reference id for the attribute. The attribute URL string contains three pieces of information - in the above example, the authority namespace (https://example.com), the attribute name (classification), and the attribute value (topsecret). |Yes|

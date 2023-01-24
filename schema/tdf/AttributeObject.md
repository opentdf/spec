# Attribute Object

## Summary
An Attribute Object contains attribute information the TDF system uses to enforce attribute-based access control (ABAC). 

Attributes are used in both the [Policy Object](PolicyObject.md) to define the attributes that an entity "needs" to gain access to data in an ABAC sense, 
and in the [Entitlement Object](EntitlementObject.md) to assert the attributes that an entity "has".

Access decisions are made by comparing the attributes all entities have with the attributes a data policy requires.

Attributes that a single entity (a system actor or subject) "has" are referred to as "entity entitlements" and are represented by [Entity Entitlement Objects](EntitlementObject.md) 

Attributes that entities "need" in order to access data are referred to as "data attributes" and are represented by [Data Policy Objects](PolicyObject.md)

The set of all entity entitlements involved in a request are referred to as "claims" and are represented by a [Claims Object](ClaimsObject.md) 

Attributes themselves are represented as URIs. 

Given the example attribute URI `https://demo.com/attr/Blob/value/Green`, the named parts of the URI are:

| Name | Example Value | Description | 
| ---- | ------------- | ----------- |
| **Attribute Namespace** | `https://demo.com` | Typically a standard DNS name. It is recommended that the root DNS name of the authoritative owner of the attribute be used as the Attribute Namespace. |
| **Attribute Name** | `Blob` | Attribute Names are not globally unique. |
| **Attribute Canonical Name** | `https://demo.com/attr/Blob` | Combination of `Attribute Namespace` and `Attribute Name`, separated by the string `/attr/`. Attribute Canonical Names are the _globally unique_ part of the attribute. |
| **Attribute Value** | `Green` | Attribute Values are not globally unique. |
| **Attribute Instance** | `https://demo.com/attr/Blob/value/Green` | Combination of `Attribute Canonical Name` + a single `Attribute Value`, separated by the string `/value/`. The complete representation of an actionable authorization attribute, as found in data and entity policy documents. |
| **Attribute Definition** | `{rule_type: AllOf, valid_values: [Green, Red, Purple]}` | Authorization-relevant metadata (rule type: AllOf/AnyOf/Hierarchy, allowed values, etc) associated with a specific, globally unique `Attribute Canonical Name`. Stored/managed by the authoritative owner of the attribute, separately from data or entity policy. |

> Key Point: Attribute Namespaces are not globally unique by themselves. Attribute Names are not globally unique by themselves. The combination of **both Namespace and Value** (the Canonical Name) _must_ be globally unique, and _must_ globally identify the Attribute.

> Key Point: As Attribute Canonical Names are globally unique, and Attribute Definitions are associated with a specific Attribute Canonical Name, it follows that there can be _only one_ Attribute Definition globally, for a given Canonical Name.

> Key Point: Only an Attribute Instance (Canonical Name + Value) can used for authorization decisions, or added to [Data Policy Objects](PolicyObject.md) or [Entity Entitlement Objects](EntitlementObject.md)

When encrypting, the client determines which Attribute Instances an entity must have in order to decrypt the payload and appends those Attribute Instance URIs to the data's [Data Policy Object](PolicyObject.md).

When a decrypt is requested, the KAS checks the [Data Policy Object](PolicyObject.md) against the [Claims Object](ClaimsObject.md) from the requesting client to 
ensure that the entity Attribute Instances match the data Attribute Instances, using the Attribute Definitions currently associated with each individual data Attribute Instance to determine comparison rules (AnyOf/AllOf/Hierarchy).

If this check succeeds, the KAS permits a decrypt operation and returns a valid key which the client can decrypt and use to expose the data contents.

## Data policy payload example

```javascript
{
  "attribute": "https://example.com/attr/classification/value/topsecret"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`attribute`|String|The full Attribute Instance (Canonical Name + Value). |Yes|

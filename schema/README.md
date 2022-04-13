# TDF Schemas

Attributes are represented by [Attribute Objects](AttributeObject.md)

Attributes that an entity (or actor, or subject) "has" are referred to as "entity entitlements" and are represented by [Entitlement Objects](EntitlementObject.md)

Attributes that entities "need" in order to access data are referred to as "data attributes" and are represented by [Policy Objects](PolicyObject.md)

The set of all entity entitlements involved in a request are referred to as "claims" and are represented by a [Claims Object](ClaimsObject.md)

A TDF file consists of:

* Encrypted payload
* [manifest.json](manifest-json.md).

The [TDF protocol](https://github.com/virtru/tdf3-spec/tree/master/protocol) also defines the following objects:

* A [Attribute Object](AttributeObject.md) created by an attribute authority.
* A [Policy Object](PolicyObject.md) created by the client and used by the [Key Access Service](https://developer.virtru.com/docs/how-to-host-a-kas) (KAS).
  * Policy Objects contain [Attribute Objects](AttributeObject.md), describing the object (or data) attributes.
* A [Entitlement Object](EntitlementObjects.md) describing the entitlements of a single entity (or actor, or subject).
  * Entitlement Objects contain [Attribute Objects](AttributeObject.md), describing individual entity (or actor, or subject) attributes.
* A [Claims Object](ClaimsObject.md) created by the [Attribute Provider](../protocol/README.md) and issued by an OIDC IdP
  * Claims Objects contain [Entitlement Objects](EntitlementObjects.md), describing the entitlements of all entities (PE or NPE) involved in an access decision.

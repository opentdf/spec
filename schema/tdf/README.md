# TDF Schemas

Attributes are represented by [Attribute Objects](AttributeObject.md)

Attributes that entities "need" in order to access data are referred to as "data attributes" and are represented by [Policy Objects](PolicyObject.md)

A TDF file consists of:

* Encrypted payload
* [manifest.json](manifest-json.md).

The [TDF protocol](https://github.com/opentdf/spec/tree/master/protocol) also defines the following objects:

* A [Attribute Object](AttributeObject.md) created by an attribute authority.
* A [Policy Object](PolicyObject.md) created by the client and used by the *Key Access Service*(KAS).
  * Policy Objects contain [Attribute Objects](AttributeObject.md), describing the object (or data) attributes.
* A [Entitlement Object](EntitlementObject.md) describing the entitlements of a single entity (or actor, or subject).
  * Entitlement Objects contain [Attribute Objects](AttributeObject.md), describing individual entity (or actor, or subject) attributes.
* A [Claims Object](ClaimsObject.md) created by the [Attribute Provider](../../protocol/README.md) and issued by an OIDC IdP
  * Claims Objects contain [Entitlement Objects](EntitlementObjects.md), describing the entitlements of all entities (PE or NPE) involved in an access decision.

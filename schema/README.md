# TDF Schemas

A TDF file consists of:

* Encrypted payload
* [manifest.json](manifest-json.md).

The [TDF protocol](https://github.com/virtru/tdf3-spec/tree/master/protocol) also defines the following objects:

* A [Attribute Object](AttributeObject.md) created by an attribute authority.
* A [Policy Object](PolicyObject.md) created by the client and used by the [Key Access Service](https://developer.virtru.com/docs/how-to-host-a-kas) (KAS).
  * Policy Objects contain [Attribute Objects](AttributeObject.md), describing the object (or data) attributes.
* A [Claims Object](ClaimsObject.md) created by the [Attribute Provider](../protocol/README.md) and issued by an OIDC IdP
  * Claims Objects contain [Attribute Objects](AttributeObject.md), describing the subject (or actor) attributes.

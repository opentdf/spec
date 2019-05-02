The following specification pages outline details regarding the main pieces of information required by the TDF system:

* A [Policy Object](PolicyObject.md) created by the client and used by the [Key Access Service](https://developer.virtru.com/docs/how-to-host-a-kas) (KAS)
* An [Entity Object](EntityObject.md) created by the [Entity Attribute Service](https://developer.virtru.com/docs/how-to-host-an-eas) (EAS)
* A [manifest.json](manifest-json.md) and payload comprising the final encrypted `.tdf` file

![diagram](https://files.readme.io/d5f0f01-spec_parts.png "Association diagram")

_An overview of how the Policy Object, Entity Object and manifest are related._

## Schema Version

Each schema contains a `schemaVersion`, which maps back to this spec and defines the format consumers should expect. Currently the `schemaVersion` is *optional* for backwards-compatibility reasons. We intend to make this field *required* on the next major version change.

## Format Validation

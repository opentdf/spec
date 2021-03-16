# Entity Object

## What is this?

The Entity Object is a JSON object used to ensure that individuals (entities) attempting to decrypt an encrypted file under the Trusted Data Format has all permissions required to do so.

## How does it work?

When an entity wishes to decrypt a file, the following steps using the Entity Object are made:

1. The client requests an Entity Object from the EAS (Entity Attribute Service). The EAS processes this request by first authenticating the entity, and if that entity has successfully authenticated, creates and signs a valid Entity Object which is then returned to the client. This Entity Object contains [Attributes](AttributeObject.md) to which the entity has access.

2. The client requests a decrypt from the Key Access Server (KAS) and in the process passes this Entity Object to it. The KAS ensures that the requestor has the correct permissions to access the contents of the file, by examining the validity of the Entity Object's signature, and if the entity has all the required Attributes and is on the [Policy Object](PolicyObject.md). If all of this has been met with success, the KAS will permit a decrypt of the file.


## Example

```javascript
{
  "userId": "user@virtru.com",
  "aliases": [],
  "attributes": [
    {
      "jwt": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJodHR..."
    },
    {
      "jwt": "eyJhbGciOiJSUzI1NiIsInR5cCI6IPuQedtw5mNsJ0uDK4UdCChw..."
    }
  ],
  "publicKey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy18Efi6+3vSELpbK58gC\nA9vJxZtoRHR604yi707h6nzTsTSNUg5mNzt/nWswWzloIWCgA7EPNpJy9lYn4h1Z\n6LhxEgf0wFcaux0/C19dC6WRPd6 ... XzNO4J38CoFz/\nwwIDAQAB\n-----END PUBLIC KEY-----",
  "cert": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2...",
  "schemaVersion:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`userId`|String|An id used to identify the entity, such as email, that will be used to authenticate against the EAS.|Yes|
|`aliases`|Array|`aliases` are not yet implemented, but will provide further flexibility by assigning additional aliases to a user. This can remain empty for the time being.|Yes|
|`attributes`|Array|An array of signed [Attribute Object](AttributeObject.md)s. At most one of these may be a _default_ AttributeObject.|Yes|
|`attributes.jwt`|String|An [Attribute Object](AttributeObject.md) that has been signed with the EAS private key as a [JWT](https://jwt.io/).|Yes|
|`publicKey`|String|The entity's public key, in a PEM-encoded format.|Yes|
|`signerPublicKey`|String|A second public key used for signing KAS requests, in a PEM-encoded format. When using TDF3 with elliptic curve cryptography, the public key may use ECDH and the signing key ECDSA.|Optional, depends on choice of algorithm|
|`cert`|String|The [Entity Object](EntityObject.md) contents (without `cert`) that has been signed with the EAS private key, as a [JWT](https://jwt.io/). The KAS uses this field to validate the authenticity of the Entity Object. |Yes|
|`schemaVersion`|String|Version number of the Entity Object schema.|No|


## Version

The current schema version is `1.1.1`.

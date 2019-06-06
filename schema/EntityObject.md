# Entity Object

## Summary
The Entity Object, along with its validation on the KAS, provides a means to ensure that the requestor of a decrypt operation on an encrypted payload has current and correct permissions (via attributes) to do so. Before a decrypt action can be taken, an Entity Object is fetched from an EAS (Entity Attribute Service) and is sent to the KAS. The KAS then grants access to the payload (by way of a decrypted key) if and only if the requestor's Entity Object details coincide with those given in the [Policy Object](PolicyObject.md).

## Version

The current schema version is `1.1.0`.

## Example

```javascript
{
  "userId": "user@virtru.com",
  "auth": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
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
|`userId`|String|A user id used to identify the user, such as email, that will be used to authenticate against the EAS.|Yes|
|`auth`|Object|JWT containing arbitrary supplementary identifying information from the EAS's auth scheme. KAS can use this to auth internal and downstream operations.
|`aliases`|Array|`aliases` are not yet implemented, but will provide further flexibility by assigning additional aliases to a user. This can remain empty for the time being.|Yes|
|`attributes`|Array|An array of signed [Attribute Object](AttributeObject.md)s. At most one of these may be a _default_ AttributeObject.|Yes|
|`attributes.jwt`|String|An [Attribute Object](AttributeObject.md) that has been signed with the EAS private key as a [JWT](https://jwt.io/).|Yes|
|`publicKey`|String|The entity's public key, in a PEM-encoded format.|Yes|
|`cert`|String|The [Entity Object](EntityObject.md) contents (without `cert`) that has been signed with the EAS private key, as a [JWT](https://jwt.io/).|Yes|
|`schemaVersion`|String|Version number of the EntityObject schema.|No|

[comment]: <> (should publicKey be of type PEM?)
[comment]: <> (what about required col?)

# Claims Object

## What is this?

The Claims Object is a JSON object used to ensure that TDF Clients
attempting to decrypt an encrypted file under the Trusted Data Format
has all permissions required to do so.

## How does it work?

When an TDF Client wishes to decrypt a file, the following steps using
the Claims Object are made:

1. The client requests a Claims Object by first authenticating via the
OpenID Connect (OIDC) Identity Provider (IdP) with Custom Claims
support (in this case Keycloak), and if authentication succeeds, a
[TDF Claims Object](../schema/ClaimsObject.md) is obtained from
Attribute Provider and signed by the IdP.  The signed OIDC JWT is
returned to the client with the Claims Object inside. The Claims
Object contains [ClaimsAttributes](ClaimsAttributeObject.md) to which
the TDF Client has access.


2. The client requests a decrypt from the Key Access Server (KAS), 
presenting the OIDC JWT (containing the Claims Object) as a bearer token to the KAS. 
The KAS ensures that the requestor has the correct permissions to access
the contents of the file by:
- Examining the validity of the OIDC JWT signature.
- Determining if the TDF Client has all the required Attributes and is on
  the [Policy Object](PolicyObject.md).

If these requirements are met, the KAS will permit a decrypt of the file.


## Example

```javascript
{
  "userId": "user@virtru.com",
  "aliases": [],
  "attributes": [
    {
      "obj": {"attribute": "https://example.com/attr/Classification/value/S"}}
    },
    {
      "obj": {"attribute": "https://example.com/attr/COI/value/PRX"}}
    }
  ],
  "publicKey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy18Efi6+3vSELpbK58gC\nA9vJxZtoRHR604yi707h6nzTsTSNUg5mNzt/nWswWzloIWCgA7EPNpJy9lYn4h1Z\n6LhxEgf0wFcaux0/C19dC6WRPd6 ... XzNO4J38CoFz/\nwwIDAQAB\n-----END PUBLIC KEY-----",
  "schemaVersion:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`userId`|String|An id used to identify the entity, such as email.|Yes|
|`aliases`|Array|`aliases` are not yet implemented, but will provide further flexibility by assigning additional aliases to a user. This can remain empty for the time being.|Yes|
|`attributes`|Array|An array of [Claims Attribute Object](ClaimsAttributeObject.md)s. At most one of these may be a _default_ ClaimsAttributeObject.|Yes|
|`attributes.obj`|String|An [Claims Attribute Object](ClaimsAttributeObject.md)).|Yes|
|`publicKey`|String|The TDF Client's public key, in a PEM-encoded format.|Yes|
|`signerPublicKey`|String|A second public key used for signing KAS requests, in a PEM-encoded format. When using TDF with elliptic curve cryptography, the public key may use ECDH and the signing key ECDSA.|Optional, depends on choice of algorithm|
|`schemaVersion`|String|Version number of the Claims Object schema.|No|


## Version

The current schema version is `4.0.0`.

# Claims Object

## What is this?

The Claims Object is a JSON object used to ensure that actors
attempting to decrypt an encrypted file under the Trusted Data Format
has all permissions required to do so.

The term `Actors` is a generic term that refers to both Person Entities (PE)
and Non-Person Entities (NPE). Actors are also sometimes referred to as "subjects"
in ABAC systems.

## How does it work?

When an actor wishes to decrypt a file, the following steps using
the Claims Object are made:

1. The TDF client requests an OIDC Bearer Token by first authenticating via the
OpenID Connect (OIDC) Identity Provider (IdP) with Custom Claims
support (in this case Keycloak), and if actor authentication succeeds, a
[TDF Claims Object](../schema/ClaimsObject.md) is obtained from
Attribute Provider and signed by the IdP.  The signed OIDC Bearer Token is
returned to the client with the Claims Object inside. The Claims
Object contains [AttributeObjects](AttributeObject.md) the actor has 
been entitled with.

2. The client requests a decrypt from the Key Access Server (KAS), 
presenting the OIDC Bearer Token (containing the Claims Object) to the KAS. 
The KAS ensures that the requestor has the correct permissions to access
the contents of the file by:

- Examining the validity of the OIDC Bearer Token signature.
- Validating that the Claims Object contains the client's public signing key.
- Validating that the request signature in the client payload can be validated
with the client's public signing key embedded in the OIDC Bearer Token
- Determining if the TDF Client has all the required Attributes and is on
  the [Policy Object](PolicyObject.md).

If these requirements are met, the KAS will permit a decrypt of the file.

## Example

```javascript
{
  "subject_attributes": [
    {"attribute": "https://example.com/attr/Classification/value/S", "displayName": "classification"},
    {"attribute": "https://example.com/attr/COI/value/PRX", "displayName": "category of intent"}
  ],
  "client_public_signing_key": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy18Efi6+3vSELpbK58gC\nA9vJxZtoRHR604yi707h6nzTsTSNUg5mNzt/nWswWzloIWCgA7EPNpJy9lYn4h1Z\n6LhxEgf0wFcaux0/C19dC6WRPd6 ... XzNO4J38CoFz/\nwwIDAQAB\n-----END PUBLIC KEY-----",
  "tdf_spec_version:": "x.y.z"
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`subject_attributes`|Array|An array of [Attribute Objects](AttributeObject.md) that entitle the actor(also known as 'the subject').
|`client_public_signing_key`|String|The TDF Client's public signing key, in a PEM-encoded format. |Yes|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|No|

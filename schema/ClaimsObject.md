# Claims Object

## What is this?

The Claims Object is a JSON object used to ensure that entities
attempting to decrypt an encrypted file under the Trusted Data Format
have all permissions required to do so.

The term `Entity` is a generic term that refers to both Person Entities (PE)
and Non-Person Entities (NPE). Entities are also sometimes referred to as "actors" or "subjects"
in ABAC systems.

Under this definition, *both* the human user attempting to authenticate, and the specific TDF client they are using to authenticate with would be classified as Entities - a PE and an NPE respectively.

## How does it work?

When an entity (either on behalf of itself, or another entity) wishes to decrypt a file, 
the following happens:

1. The TDF client requests an OIDC Bearer Token (either on behalf of itself, or another entity) 
by first authenticating via the
OpenID Connect (OIDC) Identity Provider (IdP) with Custom Claims
support (in this case Keycloak), and if entity authentication succeeds, a
[TDF Claims Object](../schema/ClaimsObject.md) is obtained from
Attribute Provider and signed by the IdP.  The signed OIDC Bearer Token is
returned to the client with the Claims Object inside. 

The Claims Object contains one or more [Entitlement Objects](EntitlementObject.md) entitling all entities
involved in the authentication request.

2. The client requests a decrypt from the Key Access Server (KAS), 
presenting the OIDC Bearer Token (containing the Claims Object) to the KAS.
The KAS ensures that all entities entitled in the OIDC bearer token have the 
correct permissions to access the contents of the file by:

- Examining the validity of the OIDC Bearer Token signature.
- Validating that the Claims Object contains the client's public signing key.
- Validating that the request signature in the client payload can be validated
with the client's public signing key embedded in the OIDC Bearer Token
- Determining if all the entities entitled in the presented bearer token have all the required Attributes,
according to PDP rules.

If these requirements are met, the KAS will permit a decrypt of the file.

## Example

```javascript
{
  "entitlements":[
    {
      "entity_identifier":"cliententityid-14443434-1111343434-asdfdffff",
      "entity_attributes":[
        {
          "attribute":"https://example.com/attr/Classification/value/S",
          "displayName":"classification"
        },
        {
          "attribute":"https://example.com/attr/COI/value/PRX",
          "displayName":"category of intent"
        }
      ]
    },
    {
      "entity_identifier":"dd-ff-eeeeee1134r34434-user-beta",
      "entity_attributes":[
        {
          "attribute":"https://example.com/attr/Classification/value/U",
          "displayName":"classification"
        },
        {
          "attribute":"https://example.com/attr/COI/value/PRZ",
          "displayName":"category of intent"
        }
      ]
    }
  ],
  "tdf_spec_version:":"x.y.z"
}
```

| Parameter                   | Type   | Description                                                                                                                              | Required?          |
|-----------------------------|--------|------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| `entitlements`              | Array  | An array of [Entitlement Objects](EntitlementObject.md) for each entity (PE or NPE) involved in the authentication request.              | Yes                |
| `tdf_spec_version`          | String | Semver version number of the TDF spec.                                                                                                   | No                 |
| `client_public_signing_key` | String | [DEPRECATED] The TDF Client's public signing key, in a PEM-encoded format. Replaced by cnf claim and the DPoP protocol.                  | No                 |

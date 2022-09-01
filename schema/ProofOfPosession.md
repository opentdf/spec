# Proof of Possession Key

## What is this?

The Proof of Posession key is the public half of a session-level public/private
key pair that allows the client application to sign each exchange with KAS or other backend services.

It is stored in the JWT as the custom claim, `pop_key`,
in JWK format.*

> Note: This was previously included within th [`tdf_claims`](./ClaimsObject.md) as `client_public_signing_key` in PEM format

## How does it work?

1. TDF clients may request an OIDC requests an OIDC Bearer Token (either on behalf of itself, or another entity) 
by first authenticating via the
OpenID Connect (OIDC) Identity Provider (IdP),
passing along a signing key with the request.
In some scenarios, a key may be added using an exchange or refresh.

2. The client requests a decrypt from the Key Access Server (KAS), 
presenting its annotated JWT with PoP key and entitlement claims.

## Example

```javascript
{
  "pop_key":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy18Efi6+3vSELpbK58gC\nA9vJxZtoRHR604yi707h6nzTsTSNUg5mNzt/nWswWzloIWCgA7EPNpJy9lYn4h1Z\n6LhxEgf0wFcaux0/C19dC6WRPd6 ... XzNO4J38CoFz/\nwwIDAQAB\n-----END PUBLIC KEY-----",
  "tdf_spec_version:":"x.y.z"
}
```

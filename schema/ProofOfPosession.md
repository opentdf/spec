# Proof of Possession

In order to allow extended offline flows, and to deal with potential leaks of bearer tokens,
we enforce the use of proof of token possession, as currently described in 
[this IETF draft](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop).

## What is this?

The proof of possession works by having the client generate an ephemeral key pair, which it
then associates with an access_token via a code or token exchange. This produces
an access token with an explicit binding (via the `cnf` claim) to the public
key of the value. Then, the client can issue DPoP proofs that will be allow servers
to trust that the client has possession of the private key.

## How does it work?

1. TDF clients may request an OIDC requests an OIDC Bearer Token (either on behalf of itself, or another entity) 
by first authenticating via the
OpenID Connect (OIDC) Identity Provider (IdP),
passing along a signing key with the request.
In some scenarios, a key may be added using an exchange or refresh.

2. The client requests a decrypt from the Key Access Server (KAS), 
presenting its annotated JWT with PoP proof and entitlement claims in the access token.

## Example

```javascript
TK
```

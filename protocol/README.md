# Open TDF Protocol

This document describes the canonical system architecture used to encrypt and decrypt TDF ciphertext.

## Architecture

The canonical architecture contains four major components.

* *TDF Client* - Initiates and drives the TDF encryption and decryption workflows. Only component with access to the content (ciphertext or plaintext). 
  * May be entitled as Non-Person Entity acting on behalf of itself, OR on behalf of a Person Entity.
* *OpenID Connect (OIDC) Identity Provider (IdP)* - This system could be any OIDC IdP software. Any OIDC-compliant IdP software may be used, provided it supports custom claims and *Demonstration of Proof of Possession (DPoP)*.
  * Supporting this protocol must include:
    * Obtaining a session-bound TDF Client public signing key. This may be via a client side channel, or an addditional request. Implements may choose a custom HTTP header sent with the OIDC authentication request, or an identity provider (IdP) web hook that fires during a token or code exchange.
    * Constructing and sending a web service request to an ABAC entitlement PDP (e.g. the OpenTDF Entitlement PDP), including sufficient information to identify all entities requesting the token grant, and any additional IdP context data for those entities.
    * Including within the returned signed access token both the evidence of the client's public key in the `cnf` claim, and the entitlements in the `tdf_claims`.[^client_public_signing_key]
  * A list of Certified OpenID Connect applications can be found at:  https://openid.net/developers/certified/  OpenTDF has chosen [Keycloak] as its reference implementation IdP. [^why-keycloak]
* *Entitlement Policy Decision Point (PDP)* (AP) - A web service that receives requests which contain information about the authenticated entities from an OIDC IdP with custom claims support (e.g. Keycloak with OpenTDF Protocol Mapper), and returns custom TDF OIDC claims in response. It is the responsibility of Entitlement PDP to transform incoming 3rd party IdP claims/metadata to a set of outgoing [Attribute Objects](../schema/tdf/AttributeObject.md). It returns a TDF [Claims Object](../schema/tdf/ClaimsObject.md).
* *Key Access Service* (KAS) - Responsible for authorizing and granting TDF Clients access to rewrapped data key material. If authorized, TDF Clients (on behalf of themselves, or other entities) can use this rewrapped data key to decrypt TDF ciphertext. A valid OIDC token containing [`tdf_claims`](../schema/tdf/ClaimsObject.md) and [`dpop` (Demonstration Proof of Possession)](../schema/tdf/ProofOfPossession.md) must be used as a bearer token when communicating with KAS. KAS will verify the authenticity of the bearer token, the request signature, and then the policy claims within that bearer token. An otherwise valid and trusted OIDC token without valid TDF Claims will be rejected.

## General Authentication Protocol

OIDC Auth with a DPoP (Demonstration Proof of Possession) scheme is used for **all** TDF Client interactions with backend TDF services:

1. The TDF Client requests an OIDC Bearer Token (either on behalf of itself, or another entity)
by first authenticating via the OpenID Connect (OIDC) Identity Provider (IdP) with Custom Claims
support (in this example, Keycloak). As part of this authentication process, the TDF Client **must** convey a DPoP key to the IdP.
    * To change (or rotate) its DPoP key, a client must obtain a new OIDC access token from the IdP containing its own new public signing key.
    * The TDF Client's signing keypair is ephemeral and the _private_ signing key must be known only to the TDF Client.
    * Measures should be taken to protect all TDF Client private keys, but the mechanisms for doing so are outside the scope of this spec.

1. If entity authentication succeeds, a
[TDF Claims Object](../schema/tdf/ClaimsObject.md) is obtained from
Entitlement PDP.
A hash of the signing public key is embedded within the [JWT's `cnf.jkt` claim](../schema/tdf/ProofOfPossession.md).
The signed OIDC Bearer Token is then returned to the TDF Client, containing the complete [TDF Claims Object](../schema/tdf/ClaimsObject.md).
    * The [TDF Claims Object](../schema/tdf/ClaimsObject.md) contains one or more [Entitlement Objects](../schema/tdf/EntitlementObject.md) entitling all entities
involved in the authentication request.

1. The TDF Client must convey the IdP-signed OIDC Bearer Token as a JWT to backend services with all requests, and a DPoP proof generated from its _private signing key_
    * The DPoP proof claims must include a `body_hash` claim, which is a hash of the request body.
1. All backend services are required to _minimally_:
    * Validate AuthN:
      * Examine the validity of the OIDC Bearer Token signature and other assertions by contacting the issuing IdP.
      * Validate the [`DPoP`](../schema/tdf/ProofOfPossession.md) header
1. Backend services acting as Access PEPs must _additionally_ validate AuthZ:
    * Validate that the access token contains a valid [TDF Claims Object](../schema/tdf/ClaimsObject.md) under the `tdf_claims` key,
    * Validate AuthZ by presenting the attributes for all authenticated entities to an Access PDP.

If these requirements are met, a TDF Client may be considered authenticated and authorized.

### Diagrams

The following sequence diagrams illustrate the TDF Client workflow for encrypting or decrypting TDF ciphertext. The canonical TDF architecture supports two modes of operation: _online mode_ and _offline mode_, which have distinct workflows as shown below.

_Online mode_ is the default mode, where the [wrapped data key](../schema/tdf/KeyAccessObject.md) and [authorization policy](../schema/tdf/PolicyObject.md) for TDF ciphertext is committed to KAS in-band as part of the `encrypt` operation. This means that the `encrypt` will succeed if and only if all resources are prepared to facilitate an immediate decrypt.

_Offline mode_ requires that the TDF Client previously obtained a
long-lived TDF JWT with embedded Claims Object via
online OIDC authentication.  Or, the TDF Client has otherwise obtained
a valid signed JWT with embedded Claims Object through offline means
(e.g. generated by a script using the IdP signing key).  TDF Clients
running in this mode commit the [authorization
policy](../schema/tdf/PolicyObject.md) out-of-band, or when decrypt is
first performed. This significantly reduces latency at the cost of a
slightly larger TDF manifest (as the entire wrapped key and policy
information must be included).

### IdP Direct Authentication, Encrypt

![IdP Direct Authentication](../diagrams/OIDC_direct_auth.png)

### IdP Direct Authentication, Decrypt

![IdP Direct Authentication Decrypt](../diagrams/OIDC_direct_auth_decrypt.png)

### IdP Token Exchange, Encrypt

![IdP Token Exchange](../diagrams/OIDC_token_exchange.png)

#### IdP Brokered Authentication, Encrypt

![IdP Brokered Authentication](../diagrams/OIDC_brokered_auth.png)

[Keycloak]: https://www.keycloak.org/

[^client_public_signing_key]: Clients in version [4..4.2) may include the signing key in the `tdf_claims` object in the `client_public_signing_key` field, instead of the `cnf`.

[^why-keycloak]: [From Wikipedia](https://en.wikipedia.org/wiki/Keycloak):  "Keycloak is an open source software product to allow single sign-on with Identity and Access Management aimed at modern applications and services. As of March 2018 this JBoss community project is under the stewardship of Red Hat.  Keycloak is licensed under Apache 2.0."

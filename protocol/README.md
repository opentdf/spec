`# Protocol

This document describes the canonical system architecture used to encrypt and decrypt TDF ciphertext.

## Architecture

The canonical architecture contains four major components.

* *TDF Client* - Initiates and drives the TDF encryption and decryption workflows. Only component with access to the content (ciphertext or plaintext). 
  * May be entitled as Non-Person Entity acting on behalf of itself, OR on behalf of a Person Entity.
* *OpenID Connect (OIDC) Identity Provider (IdP)* - This system could be any OIDC IdP software.Any OIDC-compliant IdP software may be used, provided it supports custom claims and *Demonstration of Proof of Possession (DPoP)*.
  * Receive a TDF Client public key from a custom HTTP header sent with the OIDC authentication request, or via a side channel or additional request.
  * Construct and send an Attribute Provider web service request, including sufficient information to identify the client and its capabilities.
  * In the signed access JWT, include the evidence of the client's public key in the `cnf` claim, and the entitlements in the `tdf_claims`.
  * A list of Certified OpenID Connect applications can be found at:  https://openid.net/developers/certified/  OpenTDF has chosen Keycloak as its reference implementation IdP.
    * From Wikipedia:  "Keycloak is an open source software product to allow single sign-on with Identity and Access Management aimed at modern applications and services. As of March 2018 this JBoss community project is under the stewardship of Red Hat.  Keycloak is licensed under Apache 2.0."
    * *OpenTDF Protocol Mapper* (PM) is OpenTDF's Keycloak-specific reference implementation of the above functionality.
* *Entitlement Policy Decision Point (PDP)* (AP) - A web service that receives requests which contain information about the authenticated entities from an OIDC IdP with custom claims support (ex: Keycloak with OpenTDF Protocol Mapper), and returns custom TDF OIDC claims in response. It is the responsibility of Entitlement PDP to transform incoming 3rd party IdP claims/metadata to a set of outgoing [Attribute Objects](../schema/AttributeObject.md). It returns a TDF [Claims Object](../schema/ClaimsObject.md).
* *Key Access Service* (KAS) - Responsible for authorizing and granting TDF Clients access to rewrapped data key material. If authorized, TDF Clients (on behalf of themselves, or other entities) can use this rewrapped data key to decrypt TDF ciphertext. A valid OIDC token containing [`tdf_claims`](../schema/ClaimsObject.md) and [`dpop` (Demonstration Proof of Posession)](../schema/ProofOfPossession.md) must be used as a bearer token when communicating with KAS. KAS will verify the authenticity of the bearer token, the request signature, and then the policy claims within that bearer token. An otherwise valid and trusted OIDC token without valid TDF Claims will be rejected.

## General Authentication Protocol

OIDC Auth with a DPoP (Demonstration Proof of Posession) scheme is used for **all** TDF Client interactions with backend TDF services:

1. The TDF Client requests an OIDC Bearer Token (either on behalf of itself, or another entity)
by first authenticating via the OpenID Connect (OIDC) Identity Provider (IdP) with Custom Claims
support (in this example, Keycloak). As part of this authentication process, the TDF Client **must** convey a DPoP key to the IdP.
    * To change (or rotate) its DPoP key, a client must obtain a new access token from the IdP iwth the new public signing key.
    * The TDF Client's signing keypair is ephemeral and the _private_ signing key must be known only to the TDF Client.
    * Measures should be taken to protect all TDF Client private keys, but the mechanisms for doing so are outside the scope of this spec.

1. If entity authentication succeeds, a
[TDF Claims Object](../schema/ClaimsObject.md) is obtained from
Entitlement PDP.
A hash of the signing public key is embedded within the [JWT's `cnf.jkt` claim](../schema/ProofOfPosession.md).
The signed OIDC Bearer Token is then returned to the TDF Client, containing the complete [TDF Claims Object](../schema/ClaimsObject.md).
    * The [TDF Claims Object](../schema/ClaimsObject.md) contains one or more [Entitlement Objects](EntitlementObject.md) entitling all entities
involved in the authentication request.

1. The TDF Client must convey the IdP-signed OIDC Bearer Token as a JWT to backend services with all requests, and a DPoP proof with its _private signing key_
    * The DPoP proof claims must include a `body_hash` claim, which is a hash of the request body.
1. Backend services are required to:
    * Validate AuthN:
      * Examine the validity of the OIDC Bearer Token signature and other assertions by contacting the issuing IdP.
      * Validate that the [`DPoP`](../schema/ProofOfPosession.md) header
    * Validate AuthZ (if necessary)
      * Determine if all the entities entitled in the presented bearer token have all the required Attributes for a given operation, as per service requirements.

If these requirements are met, a TDF Client may be considered authenticated and authorized.

### Diagrams

The following sequence diagrams illustrate the TDF Client workflow for encrypting or decrypting TDF ciphertext. The canonical TDF architecture supports two modes of operation: _online mode_ and _offline mode_, which have distinct workflows as shown below.

_Online mode_ is the default mode, where the [wrapped data key](../schema/KeyAccessObject.md) and [authorization policy](../schema/PolicyObject.md) for TDF ciphertext is committed to KAS in-band as part of the `encrypt` operation. This means that the `encrypt` will succeed if and only if all resources are prepared to facilitate an immediate decrypt.

_Offline mode_ requires that the TDF Client previously obtained a
long-lived TDF JWT with embedded Claims Object via
online OIDC authentication.  Or, the TDF Client has otherwise obtained
a valid signed JWT with embedded Claims Object through offline means
(ex: generated by a script using the IdP signing key).  TDF Clients
running in this mode commit the [authorization
policy](../schema/PolicyObject.md) out-of-band, or when decrypt is
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


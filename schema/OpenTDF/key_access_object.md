# Key Access Object

A Key Access Object, found within the `keyAccess` array in [`encryptionInformation`](./encryption_information.md), stores information about how a specific payload encryption key (or key split/share) is stored and accessed, typically via a Key Access Server (KAS).

## Example

```json
{
  "type": "wrapped",
  "url": "https://kas.example.com:5000",
  "kid": "6f3b6a82-2f30-4c8a-aef3-57c65b8e7387", // Optional KAS Key ID
  "sid": "split-id-1", // Optional Split ID
  "protocol": "kas",
  "wrappedKey": "OqnOE...B82uw==", // Base64 encoded wrapped key
  "policyBinding": {
    "alg": "HS256",
    "hash": "BzmgoIxZzMmIF42qzbdD4Rw30GtdaRSQL2Xlfms1OPs=" // Base64 encoded hash
  },
  "encryptedMetadata": "ZoJTNW24UMhnXIif0mSnqLVCU=" // Base64 encoded encrypted metadata
}
```

## Fields

| Parameter         | Type   | Description                                                                                                                                                                                                                                                                                                                                                                                                                                        | Required? |
| ----------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| type              | String | Specifies how the key is stored/accessed.<br/>**Possible Values:**<ul><li>remote: Key stored remotely (legacy, details TBD).</li><li>wrapped: Default. The wrappedKey field contains the payload key encrypted with the KAS key identified by url (and optionally kid).</li><li>remoteWrapped: Key is wrapped, but managed by a distinct CKS (details TBD).</li></ul>                                                                              | Yes       |
| url               | String | The base URL of the Key Access Server (KAS) responsible for this key or key share.                                                                                                                                                                                                                                                                                                                                                                 | Yes       |
| protocol          | String | Protocol used to interact with the url. Currently, only kas is specified.                                                                                                                                                                                                                                                                                                                                                                          | Yes       |
| wrappedKey        | String | The Base64 encoded payload symmetric key (or key share), encrypted ("wrapped") using the public key of the KAS identified by url (and optionally kid).                                                                                                                                                                                                                                                                                             | Yes       |
| policyBinding     | Object | An object containing a keyed hash binding the policy string from [encryptionInformation](./encryption_information.md) to this specific wrappedKey. This prevents policy tampering without access to the key share.                                                                  | Yes       |
| kid               | String | Optional. An identifier for the specific public key at the KAS (url) used to wrap the wrappedKey. This could be a key fingerprint, UUID, etc. Aids key rotation.                                                                                                                                                                                                                                                                                   | No        |
| sid               | String | Optional. A Key Split (or Share) Identifier. If present, it indicates this wrappedKey represents only a share of the full payload key. Multiple keyAccess objects with different sid values (but potentially the same type/url) might need to be combined (e.g., via XOR) by the client after receiving unwrapped shares from respective KASes to reconstruct the final payload key. The encryptionInformation.type (split) governs this behavior. | No        |
| encryptedMetadata | String | Optional. Base64 encoded, encrypted metadata associated with this key access entry. Contains client-provided information (e.g., request context) passed to the KAS during rewrap requests. The KAS decrypts this using its private key. The content is freeform and SHOULD NOT be used for primary access decisions.                                                                                                                               | No        |

## Policy Binding Object (keyAccess.policyBinding)

This nested object provides the cryptographic binding between the policy and the key share.

|   |   |   |   |
|---|---|---|---|
|Parameter|Type|Description|Required?|
|alg|String|The algorithm used to generate the hash. HS256 (HMAC-SHA256) is commonly used.|Yes|
|hash|String|A Base64 encoding of HMAC(KEY, POLICY), where:<br/>- POLICY: The Base64 encoded policy string from encryptionInformation.policy.<br/>- HMAC: The algorithm specified by alg (e.g., HMAC-SHA256).<br/>- KEY: The plaintext symmetric key corresponding to the wrappedKey in this Key Access Object (i.e., the key share itself). The KAS verifies this binding upon receiving a rewrap request before proceeding.|Yes|
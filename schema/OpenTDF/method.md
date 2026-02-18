# Method Object

The `method` object, nested within [`encryptionInformation`](./encryption_information.md), describes the symmetric encryption algorithm and parameters used to encrypt the payload.

## Example

```json
"method": {
  "algorithm": "AES-256-GCM",
  "isStreamable": true,
  "iv": "D6s7cSgFXzhVkran" // Base64 encoded IV
}
```

## Fields

| Parameter    | Type    | Description                                                                                                                                                                                                         | Required? |
| ------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| algorithm    | String  | The symmetric encryption algorithm used. AES-256-GCM is the recommended and commonly implemented algorithm.                                                                                                         | Yes       |
| isStreamable | Boolean | Indicates if the payload was encrypted in segments suitable for streaming decryption. If true, [integrityInformation](./integrity_information.md) MUST contain segment details. | Yes       |
| iv           | String  | The Base64 encoded Initialization Vector (IV) used with the symmetric algorithm. MUST be unique for each TDF encrypted with the same key. For AES-GCM, this MUST be 12 bytes (96 bits).                            | Yes       |

**Streamable AES-GCM nonce derivation:** When `isStreamable` is true and `algorithm` is `AES-256-GCM`, `iv` is the base 96-bit nonce for segment 0. For segment index `i` (starting at 0), derive the nonce as:
`nonce = iv[0..7] || uint32_be(iv[8..11] + i)`. Implementations MUST reject if the 32-bit counter overflows or wraps.

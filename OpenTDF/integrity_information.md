# Integrity Information Object

The `integrityInformation` object, nested within [`encryptionInformation`](./encryption_information.md), provides mechanisms to verify the integrity of the encrypted payload, essential for streaming and detecting tampering.

## Example

```json
"integrityInformation": {
  "rootSignature": {
    "alg": "HS256",
    "sig": "M2E2MTI5YmMxMW...WNlMWVjYjlmODUzNmNiZQ==" // Base64 encoded signature
  },
  "segmentHashAlg": "GMAC",
  "segments": [ { /* See Segment Object */ } ],
  "segmentSizeDefault": 1000000,
  "encryptedSegmentSizeDefault": 1000028
}
```

## Fields

| Parameter                   | Type   | Description                                                                                                                                                                                        | Required? |
| --------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| rootSignature               | Object | Contains a cryptographic signature or HMAC over the combined integrity hashes of all segments, providing overall payload integrity.                                                                | Yes       |
| rootSignature.alg           | String | Algorithm used for the rootSignature.sig. HS256 (HMAC-SHA256 using the payload key) is commonly used.                                                                                              | Yes       |
| rootSignature.sig           | String | The Base64 encoded signature or HMAC value. Calculated over the concatenation of all segment hashes/tags in order. E.g., Base64(HMAC-SHA256(PayloadKey, Concat(SegmentHash1, SegmentHash2, ...))). | Yes       |
| segmentHashAlg              | String | The algorithm used to generate the hash for each segment in the segments array. GMAC (using the AES-GCM payload key) is commonly used when method.algorithm is AES-256-GCM.                        | Yes       |
| segments                    | Array  | An array of [Segment Objects](https://www.google.com/url?sa=E&q=.%2Fsegment.md), one for each chunk of the payload if method.isStreamable is true. Order MUST match payload order.                 | Yes       |
| segmentSizeDefault          | Number | The default size (in bytes) of the plaintext payload segments. Allows omitting segmentSize in individual segment objects if they match this default.                                               | Yes       |
| encryptedSegmentSizeDefault | Number | The default size (in bytes) of the encrypted payload segments (including any authentication tag overhead, like from AES-GCM). Allows omitting encryptedSegmentSize in segments.                    |           |
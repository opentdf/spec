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
| segments                    | Array  | An array of [Segment Objects](#encryptionInformation.integrityInformation.segment), one for each chunk of the payload if method.isStreamable is true. Order MUST match payload order.                 | Yes       |
| segmentSizeDefault          | Number | The default size (in bytes) of the plaintext payload segments. Allows omitting segmentSize in individual segment objects if they match this default.                                               | Yes       |
| encryptedSegmentSizeDefault | Number | The default size (in bytes) of the encrypted payload segments (including any authentication tag overhead, like from AES-GCM). Allows omitting encryptedSegmentSize in segments.                    |           |

## encryptionInformation.integrityInformation.segment

Object containing integrity information about a segment of the payload, including its hash.

```json
{
  "hash": "NzhlZDg5OWMwZWVhZDBjMWEzZTQyYmFlODA0NjNlMDM=",
  "segmentSize": 14056,
  "encryptedSegmentSize": 14084
}
```

|Parameter|Type|Description|
|---|---|---|
|`hash`|String|A hash generated using the specified `segmentHashAlg`.<br/><br/> `Base64.encode(HMAC(segment, payloadKey))`|
|`segmentSize`|Number|The size of the segment. This field is optional. The size of the segment is inferred from 'segmentSizeDefault' defined above, but in the event that a segment were modified and re-encrypted, the segment size would change.|
|`encryptedSegmentSize`|Number|The size of the segment (in bytes) after the payload segment has been encrypted.|

## assertions
Assertions contain metadata required to decrypt the TDF's payload, including _how_ to decrypt (protocol), and a reference to the local payload file.

```javascript
"assertions": [
  {
    "id": "123qwerty456",
    "type": "handling",
    "scope": "payload",
    "appliesToState": "encrypted",
    "statement": {/* Statement Object */},
    "binding": {
      "method": "jws",
      "signature": "ZGMwNGExZjg0ODFjNDEzZTk5NjdkZmI5MWFjN2Y1MzI0MTliNjM5MmRlMTlhYWM0NjNjN2VjYTVkOTJlODcwNA=="
    }
  }
]
```
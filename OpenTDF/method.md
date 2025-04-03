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
| isStreamable | Boolean | Indicates if the payload was encrypted in segments suitable for streaming decryption. If true, [integrityInformation](https://www.google.com/url?sa=E&q=.%2Fintegrity_information.md) MUST contain segment details. | Yes       |
| iv           | String  | The Base64 encoded Initialization Vector (IV) used with the symmetric algorithm. MUST be unique for each TDF encrypted with the same key. For AES-GCM, typically 12 bytes (96 bits).                                | Yes       |

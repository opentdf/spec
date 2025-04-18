# Encryption Information Object

The `encryptionInformation` object, part of the [manifest](./manifest.md), aggregates all information related to the encryption of the payload, policy enforcement, and key management.

## Example

```json
"encryptionInformation": {
    "type": "split",
    "keyAccess": [ { /* See Key Access Object */ } ],
    "method": { /* See Method Object */ },
    "integrityInformation": { /* See Integrity Information Object */ },
    "policy": "eyJ1dWlkIjoiNGYw...vbSJdfX0=" // Base64 encoded Policy Object JSON
}
```

## Fields

| Parameter            | Type   | Description                                                                                                                                                                                                                                                                           | Required? |
| -------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| type                 | String | Specifies the key management scheme. split is the primary scheme, allowing key sharing or splitting across multiple keyAccess entries.                                                                                                                                                | Yes       |
| keyAccess            | Array  | An array of one or more [Key Access Objects](./key_access_object.md). Each object describes how to obtain the payload decryption key (or a key split) from a specific Key Access Server (KAS).                                                           | Yes       |
| method               | Object | Describes the symmetric encryption algorithm used on the payload. See [Method Object](./method.md).                                                                                                                                               | Yes       |
| integrityInformation | Object | Contains information for verifying the integrity of the payload, especially for streamed TDFs. See [Integrity Information Object](./integrity_information.md).                                                                                    | Yes       |
| policy               | String | A Base64 encoding of the JSON string representing the [Policy Object](./policy.md). Defines the access control rules for the TDF. For conceptual details, see [Access Control](../../concepts/access_control.md). |           |
# Policy Object (Structure)

This document describes the JSON structure of the Policy Object. The entire object is JSON stringified and then Base64 encoded when stored in the `encryptionInformation.policy` field of the [manifest](./manifest.md). For a conceptual overview, see [Access Control Concepts](../../concepts/access_control.md.md).

The Policy Object contains the access control rules for the TDF.

## Example (Decoded JSON Structure)

```json
{
"uuid": "1111-2222-33333-44444-abddef-timestamp",
"body": {
    "dataAttributes": [<Attribute Object>],
    "dissem": ["user-id@domain.com"]
  },
}
```

## Fields

| Parameter           | Type   | Description                                                                                                                                                                                                                                                                                                      | Required? |
| ------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| uuid                | String | A [UUID](https://www.rfc-editor.org/rfc/rfc4122) uniquely identifying this specific policy instance.                                                                                                                                            | Yes       |
| body                | Object | Contains the core access control constraints.                                                                                                                                                                                                                                                                    | Yes       |
| body.dataAttributes | Array  | An array of [Attribute Objects](./attributes.md). Represents the attributes an entity must possess (according to their definitions and rules) to satisfy the policy's ABAC requirements.                                                                               | Yes       |
| body.dissem         | Array  | An array of strings, where each string is a unique identifier for an entity (e.g., email address, user ID). If present, an entity requesting access must be included in this list in addition to satisfying the dataAttributes. If empty or omitted, any entity satisfying dataAttributes may be granted access. | No        |

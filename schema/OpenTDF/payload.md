# Payload Object

The `payload` object within the [manifest](./manifest.md) contains metadata required to locate and process the TDF's encrypted payload.
## Example

```json
"payload": {
    "type": "reference",
    "url": "0.payload",
    "protocol": "zip",
    "isEncrypted": true,
    "mimeType": "application/pdf"
}
```
## Fields

| Parameter   | Type    | Description                                                                                                                                        | Required? |
| ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| type        | String  | Describes how the payload is referenced. Currently, reference (indicating the payload is within the TDF archive) is the only specified type.       | Yes       |
| url         | String  | A URI pointing to the location of the payload. For type: reference, this is typically a relative path within the Zip archive (e.g., 0.payload).    | Yes       |
| protocol    | String  | Designates the packaging format of the payload within the TDF. Allowed values include zip (for standard files) and zipstream (for streamed files). | Yes       |
| isEncrypted | Boolean | Indicates whether the payload referenced by url is encrypted. MUST be true for standard TDFs. Future use may allow false.                          | Yes       |
| mimeType    | String  | Specifies the MIME type of the original, unencrypted data. If not provided, application/octet-stream SHOULD be assumed.                            | No        |


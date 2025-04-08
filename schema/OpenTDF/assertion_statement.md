# Statement Object

The `statement` object, nested within an [Assertion Object](./assertion.md), contains the core information or claim of the assertion.

## Example

```json
"statement": {
  "schema": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
  "format": "json-structured",
  "value": {
      "Xmlns": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
      "CreationTime": "2015-08-29T16:15:00Z",
      "ConfidentialityInformation": { /* ... specific assertion info ... */ }
  }
}
```

## Fields

| Parameter | Type   | Description                                                                                                                                               | Required? |
| --------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| schema    | String | An optional URI identifying the schema or standard that defines the structure and semantics of the value.                                                 | No        |
| format    | String | Describes how the value is encoded. Common values: json-structured (value is a JSON object), base64binary (value is Base64 encoded binary), string.       | Yes       |
| value     | Any    | The assertion content itself, formatted according to the format field. Can be a string, number, boolean, object, or array (if format is json-structured). | Yes       |
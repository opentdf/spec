# Assertions Array

The `assertions` array, an optional top-level property in the [manifest](./manifest.md), contains assertion objects. Assertions are verifiable statements about the TDF or its payload, often used for security labeling or handling instructions.

## Example (Array containing one Assertion Object)

```json
"assertions": [
  {
    "id": "handling-assertion-1",
    "type": "handling",
    "scope": "payload",
    "appliesToState": "encrypted",
    "statement": { /* See Statement Object */ },
    "binding": { /* See Binding Object */ }
  }
]
```

## Assertion Object Structure

Each object within the assertions array represents a single assertion and has the following fields:

| Parameter      | Type   | Description                                                                                                                                                                             | Required? |
| -------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| id             | String | A unique identifier for this assertion within this TDF manifest. Used for internal referencing.                                                                                         | Yes       |
| type           | String | Categorizes the assertion's purpose. Common values include handling (e.g., caveats, dissemination controls) or metadata (general information).                                          | Yes       |
| scope          | String | Specifies whether the assertion applies to the entire TDF object (tdo) or just the payload.                                                                                             | Yes       |
| appliesToState | String | Indicates if the assertion's statement applies to the data in its encrypted state or its unencrypted state (after decryption). Default is encrypted.                                    | No        |
| statement      | Object | The actual content of the assertion. See [Statement Object](https://www.google.com/url?sa=E&q=.%2Fstatement.md).                                                                        | Yes       |
| binding        | Object | A cryptographic signature ensuring the assertion's integrity and preventing it from being moved to another TDF. See [Binding Object](https://www.google.com/url?sa=E&q=.%2Fbinding.md). |           |
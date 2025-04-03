# Binding Object (Assertion)

The `binding` object, nested within an [Assertion Object](./assertions.md), contains a cryptographic signature binding the assertion to the TDF context, ensuring its integrity and preventing replay on other TDFs.

## Example

```json
"binding": {
  "method": "jws",
  "signature": "eyJhbGciOiJSUzI1NiJ9..." // Base64URL encoded JWS string
}
```

## Fields

| Parameter | Type   | Description                                                                                                                                                                                                                 | Required? |
| --------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| method    | String | The cryptographic method used for the signature. jws (JSON Web Signature) is commonly used, implying standard JWS processing rules apply.                                                                                   | Yes       |
| signature | String | The Base64URL encoded signature value (e.g., a JWS Compact Serialization string). The signature calculation MUST include the assertion content and sufficient TDF context (like policy or key info hash) to prevent replay. | Yes       |
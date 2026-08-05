# Binding Object (Assertion)

The `binding` object, nested within an [Assertion Object](./assertion.md), contains a cryptographic signature binding the assertion to the TDF context, ensuring its integrity and preventing replay on other TDFs.

## Example

```json
"binding": {
  "method": "jws",
  "signature": "eyJhbGciOiJSUzI1NiJ9..." // JWS string
}
```

## Fields

| Parameter | Type   | Description                                                                                                                                                                                                                 | Required? |
| --------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| method    | String | Cryptographic binding format. The only supported value is `"jws"` (JSON Web Signature using JWS Compact Serialization as per RFC 7515).                                                                                   | Yes       |
| signature | String | JWS compact serialization string binding the assertion to the `scope` target (`tdo` or `payload`), providing integrity and replay protection. | Yes       |

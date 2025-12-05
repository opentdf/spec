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
| method    | String | Binding format. This version defines only `"jws"` (JWS Compact Serialization string format defined by the JWS (RFC 7515) specification).                                                                                   | Yes       |
| signature | String | JWS compact serialization string binding the assertion to the `scope` target (`tdo` or `payload`), providing integrity and replay protection. | Yes       |

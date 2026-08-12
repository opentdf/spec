# OpenTDF Manifest (`manifest.json`)

## Summary

The `manifest.json` file MUST be in JSON format and reside within the root of the OpenTDF Zip archive. It serves as the central metadata component, storing the necessary information for processing the TDF payload and making access decisions by a Policy Enforcement Point (PEP).

## Top-Level Structure

The manifest object contains the following top-level properties:

| Parameter               | Type   | Description                                                                                                 | Required? |
| :---------------------- | :----- | :---------------------------------------------------------------------------------------------------------- | :-------- |
| `tdf_spec_version`      | String | Semver version number of the OpenTDF specification this manifest conforms to.                               | Yes       |
| `payload`               | Object | Describes the location and characteristics of the encrypted payload. See [Payload Object](./payload.md).        | Yes       |
| `encryptionInformation` | Object | Contains details about encryption, key access, integrity, and policy. See [Encryption Information Object](./encryption_information.md). | Yes       |
| `assertions`            | Array  | Optional array of verifiable statements about the TDF or payload. See [Assertions Array](./assertion.md).      | No        |

### Manifest Size Considerations

For larger payloads, the number of entries in the `integrityInformation.segments` array directly determines the manifest size. As segment count increases, the `integrityInformation` length grows proportionally. With the default settings, a 1 TB TDF file with 1 MB segments will result in approximately one million segment entries in the manifest. Some SDKs impose maximum length limits on the manifest. To avoid problems with very large payloads, either configure your client to allow larger manifest sizes or to encrypt with larger segment lengths.

## Full Manifest Example

This example illustrates a complete `manifest.json` structure. Links point to detailed descriptions of each major section.

```json
{
  "tdf_spec_version": "1.0.0",
  // --- Payload Object ---
  "payload": {
    "type": "reference",
    "url": "0.payload",
    "protocol": "zip",
    "isEncrypted": true,
    "mimeType": "application/octet-stream"
  },
  // --- Encryption Information Object ---
  "encryptionInformation": {
    "type": "split",
    // --- Key Access Array ---
    "keyAccess": [
      {
        "type": "wrapped",
        "url": "http://kas.example.com:4000",
        "protocol": "kas",
        "wrappedKey": "YBkqvsiDnyDfw5JQzux2S2IaiClhsojZuLYY9WOc9N9l37A5/Zi7iloxcqgFvBFbzVjGW4QBwAHsytKQvE87bHTuQkZs4XyPACOZE/k9r+mK8KazcGTkOnqPKQNhf2XK4TBACJZ6eItO5Q1eHUQVLKjxUfgyx2TBDfhB/7XifNthu+6lFbKHmPl1q7q1Vaa/rpPRhSgqf89x5fQvcSWdkuOH9Y4wTa8tdKqSS3DUNMKTIUQq8Ti/WFrq26DRemybBgBcL/CyUZ98hFjDQgy4csBusEqwQ5zG+UAoRgkLkHiAw7hNAayAUCVRw6aUYRF4LWfcs2BM9k6d3bHqun0v5w==",
        "policyBinding": {
          "alg": "HS256",
          "hash": "ZGMwNGExZjg0ODFjNDEzZTk5NjdkZmI5MWFjN2Y1MzI0MTliNjM5MmRlMTlhYWM0NjNjN2VjYTVkOTJlODcwNA=="
        },
        "encryptedMetadata": "OEOqJCS6mZsmLWJ38lh6EN2lDUA8OagL/OxQRQ=="
      }
    ],
    // --- Method Object ---
    "method": {
      "algorithm": "AES-256-GCM",
      "isStreamable": true,
      "iv": "OEOqJCS6mZsmLWJ3"
    },
    // --- Integrity Information Object ---
    "integrityInformation": {
      "rootSignature": {
        "alg": "HS256",
        "sig": "YjliMzAyNjg4NzA0NzUyYmUwNzY1YWE4MWNhNDRmMDZjZDU3OWMyYTMzNjNlNDYyNTM4MDA4YjQxYTdmZmFmOA=="
      },
      "segmentSizeDefault": 1000000,
      "segmentHashAlg": "GMAC",
      // --- Segments Array ---
      "segments": [
        {
          "hash": "ZmQyYjY2ZDgxY2IzNGNmZTI3ODFhYTk2ZjJhNWNjODA=",
          "segmentSize": 14056,
          "encryptedSegmentSize": 14084
        }
      ],
      "encryptedSegmentSizeDefault": 1000028
    },
    // --- Policy String ---
    "policy": "eyJ1dWlkIjoiNjEzMzM0NjYtNGYwYS00YTEyLTk1ZmItYjZkOGJkMGI4YjI2IiwiYm9keSI6eyJhdHRyaWJ1dGVzIjpbXSwiZGlzc2VtIjpbInVzZXJAdmlydHJ1LmNvbSJdfX0="
  },
  // --- Assertions Array ---
  "assertions": [
      {
        "id": "nato-label-1",
        "type": "handling",
        "scope": "payload",
        "appliesToState": "encrypted",
        // --- Statement Object ---
        "statement": {
            "format": "json-structured",
            "schema": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
            "value": {
              "Xmlns": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
              "CreationTime": "2015-08-29T16:15:00Z",
              "ConfidentialityInformation": {
                  "PolicyIdentifier": "NATO",
                  "Classification": "SECRET",
                  "Category": { "Type": "PERMISSIVE", "TagName": "Releasable to", "GenericValues": [ "SWE", "FIN", "FRA" ] }
              }
          }
        },
        // --- Binding Object ---
        "binding": {
          "method": "jws",
          "signature": "eyJhbGciOiJIUzI1NiJ9.eyJzY2hlbWEiOiJ1cm46bmF0bzpzdGFuYWc6NDc3NDpjb25maWRlbnRpYWxpdHltZXRhZGF0YWxhYmVsOjE6MCIsImZvcm1hdCI6Impzb24tc3RydWN0dXJlZCIsInZhbHVlIjp7IlhtbG5zIjoidXJuOm5hdG86c3RhbmFnOjQ3NzQ6Y29uZmlkZW50aWFsaXR5bWV0YWRhdGFsYWJlbDoxOjAiLCJDcmVhdGlvblRpbWUiOiIyMDE1LTA4LTI5VDE2OjE1OjAwWiIsIkNvbmZpZGVudGlhbGl0eUluZm9ybWF0aW9uIjp7IlBvbGljeUlkZW50aWZpZXIiOiJOQVRPIiwiQ2xhc3NpZmljYXRpb24iOiJTRUNSRVQiLCJDYXRlZ29yeSI6eyJNeXBlIjoiUEVSTUlTU0lWRSIsIlRhZ05hbWUiOiJSZWxlYXNhYmxlIHRvIiwiR2VuZXJpY1ZhbHVlcyI6WyJTV0UiLCJGSU4iLCJGUkEiXX19fX0.FakeBindingSignatureExample"
        }
      }
  ]
}

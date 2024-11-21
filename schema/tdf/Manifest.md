# Manifest

## Summary

The `manifest.json` file must be in JSON format. To process a TDF payload (such as an image, text file, etc.), the `manifest.json` is used to store the data needed for a Policy Enforcement Point (PEP) to make an access decision.

From the top level, the TDF manifest contains only two properties: `payload` and `encryptionInformation`. Each of which are objects, and are decomposed in their own sections below.

- [Payload](#payload)
- [Encryption Information](#encryptioninformation)
  - [Method](#encryptioninformationmethod)
  - [Integrity Information](#encryptioninformationintegrityinformation)
    - [Segment](#encryptioninformationintegrityinformationsegment)
- [Assertions](#assertions)

If you'd like to see a real manifest created using the TDF client, check it out [here](#authentic-manifest).

## TDF Spec Version

|Parameter|Type|Description|Required?|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|Yes|

## Payload

The payload contains metadata required to access the TDF's payload, including _how_ to process it (protocol), and a reference to the local payload file.

```javascript
"payload": {
    "type": "reference",
    "url": "0.payload",
    "protocol": "zip",
    "isEncrypted": true,
    "mimeType": "application/pdf",
}
```

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`type`|String|Type of payload. The type would be a description of where to get the payload. Is it contained within the TDF or is it stored on a remote server? <br/><br/>Currently a type of `reference` is the only possible type.|Yes|
|`url`|String|A url pointing to the location of the payload. For example, `0.payload`, as a file local to the TDF.|Yes|
|`protocol`|String|Designates which protocol was used during encryption. Currently, only `zip` and `zipstream` are supported and are specified at time of encryption depending on the use of non-streaming vs. streaming encryption.|Yes|
|`isEncrypted`|Boolean|Designates whether or not the payload is encrypted. This set by default to `true` for the time being and is intended for later expansion.|Yes|
|`mimeType`|String|Specifies the type of file that is encrypted. Default is `application/octet-stream`. |No|

## encryptionInformation

Contains information describing the method of encryption. As well as information about one or more Key Access Servers which own the TDF.

```json
"encryptionInformation": {
    "type": "split",
    "keyAccess": [<Key Access Object>],
    "method": {},
    "integrityInformation": {},
    "policy": "eyJ1dWlkIjoiNGYwYWIxMzEtNGRmZS00YmExLTljMDQtZjIzZTE0MDMyNzZhIiwiYm9keSI6eyJhdHRyaWJ1dGVzIjpbXSwiZGlzc2VtIjpbInVzZXJAdmlydHJ1LmNvbSJdfX0="
}
```

|Parameter|Type|Description|
|---|---|---|
|`type`|String|The type of scheme used for accessing keys, and providing authorization to the payload. The schema supports multiple options, but currently the only option supported by our libraries is `split`.|
|`keyAccess`|Array|An array of keyAccess Objects. This object is defined in its own section: [Key Access Object](KeyAccessObject.md)|
|`method`|Object|The encryption method object is defined below: [method](#encryptioninformationmethod)|
|`integrityInformation`|Object|`integrityInformation` is defined below in its own section: [integrityInformation](#encryptioninformationintegrityinformation)|
|`policy`|String|The policy object which has been JSON stringified, then base64 encoded. The policy object is described in its own section: [Policy Object](PolicyObject.md)|

## encryptionInformation.method

An object which describes the information required to actually decrypt the payload once the key is retrieved. Includes the algorithm, and iv at a minimum.

```json
"method": {
  "algorithm": "AES-256-GCM",
  "isStreamable": true,
  "iv": "D6s7cSgFXzhVkran"
}
```

|Parameter|Type|Description|
|---|---|---|
|`algorithm`|String|The algorithm used for encryption. Currently the two available options are `aes-256-gcm`.|
|`isStreamable`|Boolean|`isStreamable` designates whether or not a TDF payload is streamable. If it's streamable, the payload is broken into chunks, and individual hashes are generated per chunk to establish integrity of the individual chunks.|
|`iv`|String|The initialization vector for the encrypted payload.|

## encryptionInformation.integrityInformation

An object which allows an application to validate the integrity of the payload, or a chunk of a payload should it be a streamable TDF.

```json
"integrityInformation": {
  "rootSignature": {
    "alg": "HS256",
    "sig": "M2E2MTI5YmMxMWU0ODIzZDA4YTdkNTY2MzdlNDM4OGRlZDE2MTFhZjU1YTY1YzBhYWNlMWVjYjlmODUzNmNiZQ=="
  },
  "segmentHashAlg": "GMAC",
  "segments": [<Segment Object>],
  "segmentSizeDefault": 1000000,
  "encryptedSegmentSizeDefault": 1000028
}
```

|Parameter|Type|Description|
|---|---|---|
|`rootSignature`|Object|Object containing a signature for the entire payload, and the algorithm used to generate it.|
|`rootSignature.alg`|String|The algorithm used to generate the root signature. `HS256` is the only available option currently.|
|`rootSignature.sig`|String|The signature for the entire payload. <br/> Example of signature generation: `Base64.encode(HMAC(BinaryOfAllHashesCombined, payloadKey))`|
|`segmentHashAlg`|String|The name of the hashing algorithm used to generate the hashes for each segment. Currently only `GMAC` is available.|
|`segments`|Array|An array of objects containing each segment object. A segment is defined in its own section: [segment](#encryptioninformationintegrityinformationsegment)|
|`segmentSizeDefault`|Number|The default size of each chunk, or segment in bytes. By setting the default size here, the segments array becomes more space efficient as it will not have to specify the segment size each time.|
|`encryptedSegmentSizeDefault`|Number|Similar to `segmentSizeDefault` -  the default size of each chunk of _encrypted_ data, in bytes.|

## encryptionInformation.integrityInformation.segment

Object containing integrity information about a segment of the payload, including its hash.

```json
{
  "hash": "NzhlZDg5OWMwZWVhZDBjMWEzZTQyYmFlODA0NjNlMDM=",
  "segmentSize": 14056,
  "encryptedSegmentSize": 14084
}
```

|Parameter|Type|Description|
|---|---|---|
|`hash`|String|A hash generated using the specified `segmentHashAlg`.<br/><br/> `Base64.encode(HMAC(segment, payloadKey))`|
|`segmentSize`|Number|The size of the segment. This field is optional. The size of the segment is inferred from 'segmentSizeDefault' defined above, but in the event that a segment were modified and re-encrypted, the segment size would change.|
|`encryptedSegmentSize`|Number|The size of the segment (in bytes) after the payload segment has been encrypted.|

## assertions
Assertions contain metadata required to decrypt the TDF's payload, including _how_ to decrypt (protocol), and a reference to the local payload file.

```javascript
"assertions": [
  {
    "id": "123qwerty456",
    "type": "handling",
    "scope": "payload",
    "appliesToState": "encrypted",
    "statement": {/* Statement Object */},
    "binding": {
      "method": "jws",
      "signature": "ZGMwNGExZjg0ODFjNDEzZTk5NjdkZmI5MWFjN2Y1MzI0MTliNjM5MmRlMTlhYWM0NjNjN2VjYTVkOTJlODcwNA=="
    }
  }
]
```

| Parameter           |Type| Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |Required?|
|---------------------|---|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|
| `id`                |String| A unique local identifier used for binding and signing purposes. Not guaranteed to be unique across multiple TDOs but must be unique within a single instance.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |Yes|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |Yes|
| `type`              |String| Describes the type of assertion (`handling` or `other`).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |Yes|
| `scope`             |String| An enumeration of the object to which the assertion applies (`tdo` or `payload`).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |Yes|
| `appliesToState`    |String| Used to indicate if the statement metadata applies to `encrypted` or `unencrypted` data.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |No|
| `statement`         |Object| `statement` is defined below in its own section: [statement](#assertionsstatement)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |Yes|
| `binding`           |Object| Object describing the binding. Contains a hash, and an algorithm used.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |Yes|

## assertions.statement
Object containing information applying to the scope of the assertion. May contain rights, handling instructions, or general metadata.

```javascript
{
  "schema": "https://someschema.com/schema",
  "format": "json-structured",
  "value": {
      "format": "json-structured",
      "value": {
        "Xmlns": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
        "CreationTime": "2015-08-29T16:15:00Z",
        "ConfidentialityInformation": {
            "PolicyIdentifier": "NATO",
            "Classification": "SECRET",
            "Category": {
                "Type": "PERMISSIVE",
                "TagName": "Releasable to",
                "GenericValues": [
                    "SWE",
                    "FIN",
                    "FRA"
                ]
            }
        }
    }
  }
}
```

|Parameter|Type| Description                                                                                  |
|---|---|----------------------------------------------------------------------------------------------|
|`schema`|String| A reference to the schema used in the statement value |
|`format`|String| Describes the payload content encoding format (`json-structured`, `base64binary`, `string`). |
|`value`|String| Payload content encoded in the format specified.                                             |

## assertions.binding
Object containing a signature of the assertion that will provide cryptographic integrity on the assertion object, 
such that it cannot be modified or copied to another TDF, without invalidating the binding.     

```javascript
{
  "method": "jws",
  "signature": "ZGMwNGExZjg0ODFjNDEzZTk5NjdkZmI5MWFjN2Y1MzI0MTliNjM5MmRlMTlhYWM0NjNjN2VjYTVkOTJlODcwNA=="
}
```
| Parameter   |Type| Description                                                                                                           |
|-------------|---|-----------------------------------------------------------------------------------------------------------------------|
| `method`    |String| The method, or algorithm used to generate the hash usually JWS.                                                       |Yes|
| `signature` |String| A base64 represenation of the assertion signature which was created using the method described in the 'method' field. |Yes|

 
## Authentic Manifest

Here is the JSON from an actual `.tdf` file, created by the TDF client.

```json
{
  "tdf_spec_version": "1.0"
  "payload": {
    "type": "reference",
    "url": "0.payload",
    "protocol": "zip",
    "isEncrypted": true
  },
  "encryptionInformation": {
    "type": "split",
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
    "method": {
      "algorithm": "AES-256-GCM",
      "isStreamable": true,
      "iv": "OEOqJCS6mZsmLWJ3"
    },
    "integrityInformation": {
      "rootSignature": {
        "alg": "HS256",
        "sig": "YjliMzAyNjg4NzA0NzUyYmUwNzY1YWE4MWNhNDRmMDZjZDU3OWMyYTMzNjNlNDYyNTM4MDA4YjQxYTdmZmFmOA=="
      },
      "segmentSizeDefault": 1000000,
      "segmentHashAlg": "GMAC",
      "segments": [
        {
          "hash": "ZmQyYjY2ZDgxY2IzNGNmZTI3ODFhYTk2ZjJhNWNjODA=",
          "segmentSize": 14056,
          "encryptedSegmentSize": 14084
        }
      ],
      "encryptedSegmentSizeDefault": 1000028
    },
    "policy": "eyJ1dWlkIjoiNjEzMzM0NjYtNGYwYS00YTEyLTk1ZmItYjZkOGJkMGI4YjI2IiwiYm9keSI6eyJhdHRyaWJ1dGVzIjpbXSwiZGlzc2VtIjpbInVzZXJAdmlydHJ1LmNvbSJdfX0="
  },
  "assertions": [
      {
        "id": "123qwerty456",
        "type": "handling",
        "scope": "payload",
        "appliesToState": "encrypted",
        "statement": {
            "format": "json-structured",
            "value": {
              "Xmlns": "urn:nato:stanag:4774:confidentialitymetadatalabel:1:0",
              "CreationTime": "2015-08-29T16:15:00Z",
              "ConfidentialityInformation": {
                  "PolicyIdentifier": "NATO",
                  "Classification": "SECRET",
                  "Category": {
                      "Type": "PERMISSIVE",
                      "TagName": "Releasable to",
                      "GenericValues": [
                          "SWE",
                          "FIN",
                          "FRA"
                      ]
                  }
              }
          }
        },
        "binding": {
          "method": "jws",
          "signature": "ZGMwNGExZjg0ODFjNDEzZTk5NjdkZmI5MWFjN2Y1MzI0MTliNjM5MmRlMTlhYWM0NjNjN2VjYTVkOTJlODcwNA=="
        }
      }
  ]
}
```

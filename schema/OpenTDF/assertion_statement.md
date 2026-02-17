# Statement Object

The `statement` object, nested within an [Assertion Object](./assertion.md), contains the core information or claim of the assertion.

## Example

```json
"statement": {
  "schema": "urn:com.exmaple:tdf ../../ExampleSchema/CDSM-TDF/CDSM-TDF",
  "format": "json-structured",
  "value": {
        "CreationTime": "2019-01-17T09:15:00Z",
    	  "cdsm:CdsManifestAssertion": {
      	"cdsm:Originator": "Oracle",
      	"cdsm:Product": "Java JDK 21 Linux",
      	"cdsm:PayloadVersion": "21.0.1",
      	"cdsm:CPE": "cpe:/a:oracle:java_jdk_linux",
      	"cdsm:Arch": "64-bit",
      	"cdsm:VirusScanList": {
        	"cdsm:VirusScan": {
          "cdsm:ScanVendor": "AV-Example-Vendor",
          "cdsm:ScanVersion": "VSE8.88",
          "cdsm:SignatureDate": "2019-01-17T09:00:00Z",
          "cdsm:ScanResult": "clean"
        }
      },
      "cdsm:VendorChecksum": {
        "cdsm:MD5": "eddcdd2f6f14cdb37ff4a10763c61898",
        "cdsm:SHA256": "844fc3d6679cec3da7cf8ca5bb831e0f1770192ffff7a9549dec4e0f41b9d77b"
      }
    }
  }
}

```

## Fields

| Parameter | Type   | Description                                                                                                                                               | Required? |
| --------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| schema    | String | An optional URI identifying the schema or standard that defines the structure and semantics of the value.                                                 | No        |
| format    | String | Describes how the value is encoded. Common values: json-structured (value is a JSON object), base64binary (value is Base64 encoded binary), string.       | Yes       |
| value     | Any    | The assertion content itself, formatted according to the format field. Can be a string, number, boolean, object, or array (if format is json-structured). | Yes       |

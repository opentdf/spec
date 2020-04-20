# Key Access Object

## Summary
A Key Access Object stores not only a wrapped (encrypted) key used to encrypt the file's payload,  but also additional metadata about _how_ it is stored.

## Version

The current schema version is `1.0.0`.

## Example"

```javascript
{
  "type": "wrapped",
  "url": "https:\/\/kas.example.com:5000",
  "protocol": "kas",
  "wrappedKey": "OqnOETpwyGE3PVpUpwwWZoJTNW24UMhnXIif0mSnqLVCUPKAAhrjeue11uAXWpb9sD7ZDsmrc9ylmnSKP9vWel8ST68tv6PeVO+CPYUND7cqG2NhUHCLv5Ouys3Klurykvy8\/O3cCLDYl6RDISosxFKqnd7LYD7VnxsYqUns4AW5\/odXJrwIhNO3szZV0JgoBXs+U9bul4tSGNxmYuPOj0RE0HEX5yF5lWlt2vHNCqPlmSBV6+jePf7tOBBsqDq35GxCSHhFZhqCgA3MvnBLmKzVPArtJ1lqg3WUdnWV+o6BUzhDpOIyXzeKn4cK2mCxOXGMP2ck2C1a0sECyB82uw==",
  "policyBinding": {
    "alg": "HS256",
    "hash": "BzmgoIxZzMmIF42qzbdD4Rw30GtdaRSQL2Xlfms1OPs="
  },
  "encryptedMetadata": "ZoJTNW24UMhnXIif0mSnqLVCU=",
  "schemaVersion:": "x.y.z"
}
```


## keyAccess

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`keyAccess`|Object|KeyAccess object stores all information about how an object key OR key split is stored, and if / how it has been encrypted (e.g., with KEK or pub wrapping key).|Yes|
|`type`|String|Specifies how the key is stored.<p>Possible Values: <dl><dt>remote</dt><dd>The wrapped key (see below) is stored using Virtru infrastructure and is thus not part of the final TDF manifest.</dd><dt>wrapped</dt><dd>Default for TDF3, the wrapped key is stored as part of the manifest.</dd><dt>remoteWrapped</dt><dd>Allows management of customer hosted keys, such as with a [Customer Key Server](https://www.virtru.com/faq/virtru-customer-key-server/). This feature is available as an upgrade path.</dd></dl>|Yes|
|`url`|String|A url pointing to the desired KAS deployment|Yes|
|`protocol`|String|Protocol being used. Currently only `kas` is supported|Yes|
|`wrappedKey`|String|The symmetric key used to encrypt the payload. It has been encrypted using the public key of the KAS, then base64 encoded.|Yes|
|`policyBinding`|Object|Object describing the policyBinding. Contains a hash, and an algorithm used.|Yes|
|`policyBinding.alg`|String|The policy binding algorithm used to generate the hash.|Yes|
|`policyBinding.hash`|String|This contains a keyed hash that will provide cryptographic integrity on the policy object, such that it cannot be modified or copied to another TDF, without invalidating the binding. Specifically, you would have to have access to the key in order to overwrite the policy. <p>This is Base64 encoding of HMAC(POLICY,KEY), where: <dl><dt>POLICY</dt><dd>`base64(policyjson)` that is in the “encryptionInformation/policy”</dd><dt>HMAC</dt><dd>HMAC SHA256 (default, but can be specified in the alg field described above)</dd><dt>KEY</dt><dd>Whichever Key Split or Key that is available to the KAS (e.g. the underlying AES 256 key in the wrappedKey.</dd></dl>|Yes|
|`encryptedMetadata`|String|Metadata associated with the TDF, and the request. The contents of the metadata are freeform, and are used to pass information from the client, and any plugins that may be in use by the KAS. For example, in Virtru's scenario, we could include information about things like, watermarking, expiration, and also data about the request. <p>Note: `encryptedMetadata` is stored as [a base64-encoded string](https://en.wikipedia.org/wiki/Base64#Base64_table). One example of the metadata, decoded and decrypted, could be, depending on specific needs:<p><code>{authHeader:"sd9f8dfkjhwkej8sdfj",connectOptions:{url:'http://localhost:4010'}}</code>|Yes|
|`schemaVersion`|String|Version number of the KeyAccessObject schema.|No|


[comment]: <> (FIXME: description formatting)

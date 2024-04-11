# Key Access Object

## Summary
A Key Access Object stores not only a wrapped (encrypted) key used to encrypt the file's payload, but also additional metadata about _how_ it is stored.

## Example"

```javascript
{
  "type": "wrapped",
  "url": "https:\/\/kas.example.com:5000",
  "kid": "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs",
  "sid": "split-id-1",
  "protocol": "kas",
  "wrappedKey": "OqnOETpwyGE3PVpUpwwWZoJTNW24UMhnXIif0mSnqLVCUPKAAhrjeue11uAXWpb9sD7ZDsmrc9ylmnSKP9vWel8ST68tv6PeVO+CPYUND7cqG2NhUHCLv5Ouys3Klurykvy8\/O3cCLDYl6RDISosxFKqnd7LYD7VnxsYqUns4AW5\/odXJrwIhNO3szZV0JgoBXs+U9bul4tSGNxmYuPOj0RE0HEX5yF5lWlt2vHNCqPlmSBV6+jePf7tOBBsqDq35GxCSHhFZhqCgA3MvnBLmKzVPArtJ1lqg3WUdnWV+o6BUzhDpOIyXzeKn4cK2mCxOXGMP2ck2C1a0sECyB82uw==",
  "policyBinding": "BzmgoIxZzMmIF42qzbdD4Rw30GtdaRSQL2Xlfms1OPs=",
  "encryptedMetadata": "ZoJTNW24UMhnXIif0mSnqLVCU=",
  "tdf_spec_version:": "x.y.z"
}
```


## keyAccess

|Parameter|Type|Description|Required?|
|---|---|---|---|
|`keyAccess`|Object|KeyAccess object stores all information about how an object key OR key split is stored, and if / how it has been encrypted (e.g., with KEK or pub wrapping key).|Yes|
|`type`|String|Specifies how the key is stored.<p>Possible Values: <dl><dt>remote</dt><dd>The wrapped key (see below) is stored using Virtru infrastructure and is thus not part of the final TDF manifest.</dd><dt>wrapped</dt><dd>Default for TDF 3.x and newer, the wrapped key is stored as part of the manifest.</dd><dt>remoteWrapped</dt><dd>Allows management of customer hosted keys, such as with a *Customer Key Server*. This feature is available as an upgrade path.</dd></dl>|Optional|
|`url`|String|A url pointing to the desired KAS deployment|Yes|
|`kid`|String|Identifier for the KAS public key, such as its thumbprint. The current preferred identifier can be looked up using the `kas_public_key` endpoint. For compatibility, our reference implementation uses the associated x509 certificate's fingerprint, although this may be a UUID or other simple string selector.|Recommended|
|`sid`|String|A key split (or share) identifier. To allow sharing a key across several access domains, the KAO supports a 'Split Identifier'. To reconstruct such a key, use the `xor` operation to combine one of each separate sid, at least under the current encryption information type (`split`).|Optional|
|`protocol`|String|Protocol being used. Currently only `kas` is supported. Defaults to `kas`|Optional|
|`wrappedKey`|String|The symmetric key used to encrypt the payload. It has been encrypted using the public key of the KAS, then base64 encoded.|Yes|
|`policyBinding`|Object|This contains a keyed hash that will provide cryptographic integrity on the policy object, such that it cannot be modified or copied to another TDF, without invalidating the binding. Specifically, you would have to have access to the key in order to overwrite the policy. <p>This is Base64 encoding of HMAC(POLICY,KEY), where: <dl><dt>POLICY</dt><dd>`base64(policyjson)` that is in the “encryptionInformation/policy”</dd><dt>HMAC</dt><dd>HMAC SHA256 (default, but can be specified in the alg field described above)</dd><dt>KEY</dt><dd>Whichever Key Split or Key that is available to the KAS (e.g. the underlying AES 256 key in the wrappedKey.</dd></dl>|Yes|
|`encryptedMetadata`|String|Metadata associated with the TDF, and the request. The contents of the metadata are freeform, and are used to pass information from the client, and any plugins that may be in use by the KAS. The metadata stored here should not be used for primary access decisions. <p>Note: `encryptedMetadata` is stored as [a base64-encoded string](https://en.wikipedia.org/wiki/Base64#Base64_table). One example of the metadata, decoded and decrypted, could be, depending on specific needs:<p><code>{authHeader:"sd9f8dfkjhwkej8sdfj",connectOptions:{url:'http://localhost:4010'}}</code>|Optional|
|`tdf_spec_version`|String|Semver version number of the TDF spec.|No|

[comment]: <> (FIXME: description formatting)


### Key Sharing

The `encryptionInformation` field allows storing not just one, but a list of `KeyAccess` objects.
This allows the same data encryption key to be encapsulated by multiple access services,
or for the key to be split using an XOR among two or more access services.

To support both functionalities together, the `sid` identity field indicates if a split occurs
and allows for selection of the necessary components to reassmble the data encryption key.

### Examples


<detail>
<summary>Sample Key Content</summary>
Suppose we have encrypted our payload with a 128 bit AES data encryption key (DEK) of:

##### Data Encryption Key (DEK)
```
85 c0 b0 57 5b a0 a8 3c 04 48 b2 f4 85 96 e5 31
```

##### Keys for alpha.kas

```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxdjr8vTMO+wij
SaVJOOfiEHYXFkyTNhPG38Wth0rs/hLE3BiMQQbg/ct+FaX9Aa89bO6paRF32gZM
YoRruxsSfzR/Nby/hc5n5Gq7NVn+PyaU2hAJiNoQZEw7I6fxVGpB8T1ZfdwSSdex
3eA7F8vPJvkvXGYT1liw76B1nJc/QTmo9pLoM+3+i8teU8Tfb+I9r+yh0xHnNA5G
2Xl3WTaPZBQCPVn5tJZXgg4EpXhIe7XfykmrGBqMavOTc74xK9E8sw2vqd0uA1dO
VpNruqY6h/nt3hTyu68l4VW1eJlp4BswwePl843cWSmL9CQg1llfWvVH2FPq5zss
JCkyJWWBAgMBAAECggEAApb1eah3qSdt6vcZScIiNST1GjVluOy8OWXc1EFSDTcQ
dk25cHuG8ovVl0GQ3moywNhY+8EoI3n7p0v1P363oIuZbCVQO7HDzzWQvqpixbBt
e1Ta0M7N0tkp2R+WNPH8ynlPIkIRTvWDp6lzmx0n6N4aWw/zv+Sb/voCOxElzmMa
q+8/XNDpWaA4lchsM+8e1Gz8fudsPamHB5NiW202zlHt9ACm1O+pl5+9zdC8ljsZ
UMgl9T2dWWlFbBGpP3zZY/rsyUzj6i9BqNYVxJZxIffM3/JO9JWnrfC2Q/NohhNQ
TJEq7ZkPPC/tYTIBVanmM96qHi0vyVUGT2XiIEUXKQKBgQDlM+gCRBR86lmss/He
KgV0fxXLfqp9CPdNQZMBTpRdGsuF6pEdkaFUrXKkUMDyWlNgJrvf0oJ1ijTVbcAs
pFbIgc2aGmdlOrxUDG/iSzgVehEVUeeKiqjYKiXI1Z+ugeGTXCLqTqqCgS1gcdka
zgKavbhn7N1FLSGz25Tb3XZziQKBgQDGNbS2kT6/u4rD0kw5H+6GF0ClVRonsyt4
jYNAB/Wa19/rGFjup/wYQ9GIIsRlA8GZ6YP+VhsXVVwjnEswnG6L1llihnTm0M0x
vdZV78Uf6pusf4pKmBeWWOFFbYk5NMtWYCggol0hpCL3vtMwwsELA8Y5NqD+eZB9
iB4zsXFMOQKBgB9jZ1+AEUo2EcfL8NCa8ppMmSCAHTr4Ul27IDWqnDjP5ZVWVT82
ZWCiTDPidzn5Ure1Nj9lpcYRAkFEQXAbpWLaG90Bxq0fSRE9jsjvwiN2zwYbbFkV
uh+4TepeDvsoAEtc788krMcoh51QmgnIsqScXLemwXqqvpXR+WXOw1z5AoGAGBSK
QevfbbfBIg04iXAhsFS+29c8+DnCPEElAvB0nD1BzPQGSehKrj//AsUGiycrrCE8
kfewDuOl8AWa9OrsWzzNWzTumuQfKb3gfkxE7J26D/jmui1EIFXn+GFYXITXd0Tz
WxOesOmZ/fNHAROIFGh++pByergWH8obsTgLhbECgYEAj7IS3itupOyvuacMoJWJ
4yVcspFkc2iOK9oVH8b+mY0hr4Bi0HtM3tCfKC9XCYGvM9nltgaWWJL9JZPOLXhS
iUxl2q3BRO4KsniiF3cXQ2VlCK0UBNUkav+AGzFzMe3ie75Mkd4c8nxaZkiE4UTt
TYfBbQFCijGWZ+BNcIhNFYA=
-----END PRIVATE KEY-----


-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsXY6/L0zDvsIo0mlSTjn
4hB2FxZMkzYTxt/FrYdK7P4SxNwYjEEG4P3LfhWl/QGvPWzuqWkRd9oGTGKEa7sb
En80fzW8v4XOZ+RquzVZ/j8mlNoQCYjaEGRMOyOn8VRqQfE9WX3cEknXsd3gOxfL
zyb5L1xmE9ZYsO+gdZyXP0E5qPaS6DPt/ovLXlPE32/iPa/sodMR5zQORtl5d1k2
j2QUAj1Z+bSWV4IOBKV4SHu138pJqxgajGrzk3O+MSvRPLMNr6ndLgNXTlaTa7qm
Oof57d4U8ruvJeFVtXiZaeAbMMHj5fON3Fkpi/QkINZZX1r1R9hT6uc7LCQpMiVl
gQIDAQAB
-----END PUBLIC KEY-----


```

</detail>



##### Keys for beta.kas

```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCllv16roMBdCNh
cyZdH/vsCcHDPJUEpnX7ejKtD22TuuX+SwCuOsPX3kUzk/aUhFryrTE2MEZXkF5H
/4tzb41SMaQrUg2QY2f11DOHxTdu0FPWl4hMK+8zrMpoaC6R3+RmXOXjsYsGDzX0
utSu5nXmhf2xrIak9wPeuKqeQQ+KJjAzK9kkcZgyMX0z50jGgTrHbMxNzq63E6IA
UUTizJoCfAXNhvkkCxbhPyZEP6n8wJyUHj1Lvyz85d7WgJIRZyAV9dwhGsnAXM+m
cn99eUq0cAVjevSF0m48ozDb4OMyaFRlaCYRUyBqPLcnu7GVKT60CtMy17zAnuge
32rh7/lbAgMBAAECggEAHcKhwuNLWz8GvtRlsDX33mewgcjJFYFfUfeX1P+hV3wv
KsFLGYUpPopNkKQGnJGfEN9sqUsK0WD6eOEmLHR/hyax1TFVi7456HYfXsbknA9o
CfjI/7ujrXtgE1yqBgChuX33uTDnBgtEzLupTtfPl8M8IasatdpJQUWaMIAL7W1+
EgOpto5rhSPcOl+PxlfOV3sJc63eeQHmyZeBbVZy1eG1CBrhXqSDInH13D3f6e+c
BizCKtqsu45DuJVjCgzRP6PKn4G582Z973N1hw1aLO6M8RoislkxsxLbfm0Cct37
QZfHjK0puX0aKu4kgFBsHY1lv+J+ucnCGVKPOT7qzQKBgQDn//b9vE6IpKRoYqsx
yW1QOzTcnj3gsF+C2v89fvZex4FZZtvB4N5RmMrqJMrPmZwttniTkOuwvhu5hXr8
XelBIS4MMk05iQKdAW5LpGoFLUAHnag5H8uuYJAGsNjohQlxTUXxWcHoCT5qTb2E
VIxpRyPmFThnOKGecK+zSuvypQKBgQC2uErvM8D+MlV8vyf7bmkiGxUFb/amQTRs
yuBxobe77JT1MavNodTOFiAuS5rildZq+uKAWEY934FtSyxCOGEvjHb/Yjdu32pt
HJdVtcPyGA3RB2fH5W+8q3QZZM0rF/KG59xIa5yDclSVNH0Y0qjM0a9KSRNDfEOU
ZuTMGcR7/wKBgQC5RL+JgYd1t4VTlvf/mkuhdqaQSA5CEJc1eI28HlfA+LFjI7D6
8wiXQN1Kfnc3sgP2vXEs5t5RFoAtd1rvjk9no4eSVdk1ySQ9HZdm8LV5zNkFO/HL
LIkLiDF8Jl4R0avovzzLsFIZashdPBfMRXib2iPg6bFRPPhT/slQ9NPXwQKBgBeU
zUb1vPCRemrxGK3gX/0g1aOwAXsPaz6nKDRCFL5SGB9U28FcI2S9gkW3SDP59oQ0
AMtjmR0fHUsHqpyZPiGu1SS8fj724ntWd0l+fd1esVnKxOANglAtKHymf7wSCSDU
B5/pE3f7Z2MiNQrhFRvp69+ActYA0Y/zf4+/u5XtAoGAKKxydBcbPHmyZS8fB0AP
VmAY2SVlTBygmoaZDndClKWzmIUMDrMv2pzeEJtUR25lfbHMoiQNcGQXucS2uYLl
NkQIo2w9qaCNtEV+Ce7jFNUUBdHDRXXmtjSbIaeFPuu0mQxBREyBk5K9Tby/MrE4
md9VSrOSDbgVkPmnKBfR8tg=
-----END PRIVATE KEY-----


-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZb9eq6DAXQjYXMmXR/7
7AnBwzyVBKZ1+3oyrQ9tk7rl/ksArjrD195FM5P2lIRa8q0xNjBGV5BeR/+Lc2+N
UjGkK1INkGNn9dQzh8U3btBT1peITCvvM6zKaGgukd/kZlzl47GLBg819LrUruZ1
5oX9sayGpPcD3riqnkEPiiYwMyvZJHGYMjF9M+dIxoE6x2zMTc6utxOiAFFE4sya
AnwFzYb5JAsW4T8mRD+p/MCclB49S78s/OXe1oCSEWcgFfXcIRrJwFzPpnJ/fXlK
tHAFY3r0hdJuPKMw2+DjMmhUZWgmEVMgajy3J7uxlSk+tArTMte8wJ7oHt9q4e/5
WwIDAQAB
-----END PUBLIC KEY-----


```

</detail>



##### Keys for local.hsm

```
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDcv14/YES4f5JA
91fN27GDP2z9OzLcpSDubQERdYdb22SoHmGgC0CIODs9TP2DSfxicpBfdR3KHqiD
4MaIBE32YSqbLFO9pvaXQ9UoTyFyBa/fGD5C2Pf/ER1ozqVFthBf++BjWy48/abx
qlw1zXvr/joyA/soyiMlIgIxOCob398dzGIhJmuJLi8VV4YnIX9nalwGhT7Epn0S
B5gjwX2valjXNxTq+eJl5iiOAjqS8UQJ+ySXjgw+PAw5qrSllfWY6Yx4cTKg72fk
8E3PRt82D+gRwCkZkwfFUjhhnd1+AvwhS0+XdXy5C7ynagW4D+0Tn5sHIzlfw/J+
p9aCMgiNAgMBAAECggEAJXGOfoiJT5RQDhYGfkQoKZ+eEJw0hem6msbBmiEJ60Jd
Igk5PQj7kr+bCMxg6h6oIVjWdWKrwWeO5QPBGTxFryePLxAHSlGiXUkjxHkbrrgZ
O2nk0bj04/6WsvruXNNDlsxmJORIBQ9vfGmNx5CJ1x9h5q73MNWMvZU1svyYY+62
GY4YsizHwJDNWtN7AoD7yrA5AyjNsGYoSznRF6FSTYok4baTSbl9B/FNibzfwLO1
oC6zaTupQ9q7o6t9+0Vm55kT1L88N8NQ4AF/7qWNMVJP2BXYxC64+WUyXQxWxOCQ
bXcmu2je0DBlwVpAwQHzeH4PgDmqB35h049e+bzaTwKBgQD+Lcvt6P3W3CITj4Hp
IX5p5DkVEC+ijRsP2zwXueXPj243jF82oNxi8OyM5SOq/IEIhKiSW/UDZ8InFJR8
/Sv+/qVq3R/jDlQSRkT0yvlvKaWm+i66MSpJBFD4lmbs/FiL8ZN7wBMMui+IwnJ+
OrEy4BGmBdZGEwNcVyFeEzPFdwKBgQDeVEDWOUyKvhlQ/icAQ99jxaFdi3NJTvrh
uDbjpV3aKMWHzvjeXPsiCsUXW6rQuRMbnejprL+P0iiF2pLwJbR4EhjZqDw6jxUk
bD0zxpvO+ew8l6CFQbQmQRlL/lKLMpyUUWVbUYzUE9Wm/JsWzbxlyl6fFuXYLgLG
ig+kDyazGwKBgCkBoG3QcetQ9lprg4zl72wL+r2QL+8sjpofR3GYdx/mRuTFS7MX
fpajwbX1Xay/Md368Osz1LJo8eS2KEKF4awwzuUPqY5LCHsuRP+tI1KwyF3I7PLy
7Zx8CsggE5jWGT7yiVWkpi4ed367yBbfRykrBw3e0TPa62bhU6vGs0p/AoGBAI81
KgZTJjCAPoJjEvAix/PWSxicSIhB7WwTYpfD3u41MPdHpBpnPgQxd76R9zc23038
qxhJg6K6NgvyPI+fWd21mngo25LEs1OgvNNq7NWnOjnVWTo8ljPF3uuKR9UNproK
rATkRJgeppJHSAaqQt42OjizYR2clYEZUPXWJJFdAoGBANp2jTfZAMyEPDf1Cqei
+J92wNCvVEovlGBmkbkGX32NjFSObod7c8kINPXxL3ylgdqq/0Ws1Go0y10eKQok
5mlwwQSULq6pf5dT0JQSjQ73EXXhIGDJFeHMPD1mI3OXfyRBLz61Vq2b6uc70qHY
WRvcu5cqFhx9Fgvs9D5+JA+/
-----END PRIVATE KEY-----


-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3L9eP2BEuH+SQPdXzdux
gz9s/Tsy3KUg7m0BEXWHW9tkqB5hoAtAiDg7PUz9g0n8YnKQX3Udyh6og+DGiARN
9mEqmyxTvab2l0PVKE8hcgWv3xg+Qtj3/xEdaM6lRbYQX/vgY1suPP2m8apcNc17
6/46MgP7KMojJSICMTgqG9/fHcxiISZriS4vFVeGJyF/Z2pcBoU+xKZ9EgeYI8F9
r2pY1zcU6vniZeYojgI6kvFECfskl44MPjwMOaq0pZX1mOmMeHEyoO9n5PBNz0bf
Ng/oEcApGZMHxVI4YZ3dfgL8IUtPl3V8uQu8p2oFuA/tE5+bByM5X8PyfqfWgjII
jQIDAQAB
-----END PUBLIC KEY-----


```

</detail>



#### Shared Key Access

If we want to allow access to the DEK from two different KAS, we can encapsulate
the DEK twice.

```
- policyBinding: |
    Wm1ReFkyWm1PREk0WldaaU5qQXpOamszTUdJMk5HSXdNREkyTTJGbE1XUXdaVFl6TUdFeU9EWTJO
    RE01WVRkaE1EbGpPR0l6TUdVM01qVm1ZVFZrT0E9PQ==
  url: alpha.kas
  wrappedKey: |
    b3FiS2dxSllrYzUydU1FWEFmOXNyWmdUVHo1WU95L1hCWDl3WkdYcDRmbnpRNGVET0ZNS3JYMEVI
    djVYUGd0VVBYMHRBTDJHbEZCTnhseTdpMjV4UDl0M25GLzlXOVFNZEU1NmprWm5PT2l1Z3Fjb09i
    UDdZMlhCa2JKZXlwcnN4VngwdlovWGxFejlycFZNeUdKQ0JuUGFDM3pQVUhkM1BhQTlucS9xemZE
    dmtXTjVBTUVNWkI0L1I4b3Y5L2drN0dBQ0dubzF6V3lnbFhGaUxrVjBQVkYrZnJWOUtnbWJtLy8w
    clE2NWxWMnQ3eVpOKzkxOTdhUUpqNmRxOWVwazBMUTY5S0xUWDZ6RVIrS3orWmE1TENoZVlxQWd6
    eUYyUXVwTGMrVTFMdElpNC8rYzhpNGsrUzZQY1JoM1BzbHk0Zlp2YVRrTVh5ZFVMMzVsZGJmTzBR
    PT0=
- policyBinding: |
    Wm1ReFkyWm1PREk0WldaaU5qQXpOamszTUdJMk5HSXdNREkyTTJGbE1XUXdaVFl6TUdFeU9EWTJO
    RE01WVRkaE1EbGpPR0l6TUdVM01qVm1ZVFZrT0E9PQ==
  url: beta.kas
  wrappedKey: |
    V3VJRzQvRXhXL0ExaWZsdVVFNUg5SEdzSGxIM0syb3UzdXYzK1MyU2VLckV2b0xUenZTU1loaUIz
    bW1MSVBPU0dUem1naW5tcXkvK3JJSmh3Wk1SNWMyL2pYQks0R2wrVWFwZFAvc09zbi9MWGdvY1FB
    Z0pKdlNrS2dKYzV2b1J4cURhTmQrRjVwQ1YvdEpXT0dvQUE1ZkxldmFiTEduS0FhTlR3RVJTRzlU
    WXJLM1pQY2ZGQnlUbDBkR2lSdmgyeHZwMmM4MWRja2grQTZ6TkxsRjNTV0t3cW8xeXNSZFk1UXhS
    UENHdWlNaUF4RnZNSzVwbjBKZERUSFhwR3NQMUZsOE1UQ1BJWE9vSG92cm9nZDlSZDc5WGt1NVdT
    U3F4cTJZc25BMnBMd2FvbWY5UDRYV2J0YWtSOU5OclJUV3JmZVI5RHRTaWg3SU5YcFlqa0w3cjhR
    PT0=

```


#### Split Key Access

If we want to require two different KASes to approve access to the DEK, we use
a split with each fraction going to a different KAS. Using a nonce with XOR
allows no information to be gained without having (at least some of) each
fraction.

```
- policyBinding: |
    TkRrNE9HSTRZV001WVROa09HWmhZVGd3TWpOaE5qWTRZMlF3WldZNU4yVmhNRGN3TlRWaE56VTJP
    VFpsT0RsaFl6QmhPVEk0TXpVMk5tUm1OVFk0WkE9PQ==
  sid: split-alpha.kas
  url: alpha.kas
  wrappedKey: |
    SkxtU2QxVDZwMlhNdmQrd2JHSjRPK3p1d005V2xWQTBvR0pwVThzMTR5RWlMMzlza0NQSG9DaEpr
    TXpLTXF1TzdnMUxWS1V3ZUcwa29XTytPNkxvMFhGUnNrTllsdUs1Y1hYRk9CZ1c4MHh4SUtvb2NF
    bmtOMGdxRjgrejZtNElQMmJZcTNVYVloand2SFpZTmYxZGo5dXNTeUw1cWJ3d2U2clNaZWdpM0w1
    VE5oY3I4NmxMNFgvOHZ1b3UwbWtaT1Z2N25CamplckdwdVZHZmlrRk0rV1pIczI2WnpCRExycXZL
    TTJxQjRFbEFTQ3F4L1NOUno4NUpCVTlDa3NybDZ3OUdQNlNzdk9OV3BBR0xtUndmYzU5bUpaZE9M
    cmczSlhaejN6K212R0IzSjdCWkY0NENyWEtZd3BaL0FvRXNHMXRmOUl4SWZJZDU1Z2N4T09rczdB
    PT0=
- policyBinding: |
    WVRneFpUbGhOelpqWm1JNU16aG1ZemhpWXpWbE5qSXpNakZqWlRBeVpqbGhPR1ExTnpZM1pUZzRO
    VGt6WlRRNVlUUTVZelU0Wm1FME5EVXpPRGMzTVE9PQ==
  sid: split-beta.kas
  url: beta.kas
  wrappedKey: |
    aDNEOEUvKzRDZzNGVUVjVEhEbDBoS0hxN2FqbUZMVmEyYUh2UHlTVUl5ZlhSY3Q0dFFCSi9MNTB1
    VlBabXQ0RFZRK3NKYm96MXRRaG9mUWwyMjcwYURVMHNPSzZicUdQZVUyVWNka2tFQXVSQlpLcWtx
    eHhkR0wzOXFQTUtBSFpBYlZkSkUrSkpNY2d5cFlHemQxdVNlNWFTWEFBRTZ2TTdrQ1ZYbXg2Y3dp
    blBQbnF2MFFFOEZDU253b0dPQkw4bnNTWGRiTDVKQkE1S0liZFBMbnVXbW9GNWtmZnFzYngyU1V1
    ZzUxR2tYUjlOYVQxWW1RRDVEU0wrN0ZCQjFXQ3VNKzB5RGhoemZrbFluWVBrdENDTmVlb1RnQkpW
    R2NKTGYzUkdLMVIvOTJKdTYrL0JqWE1YdzVmbExIc2FQR0hodGxxZFQyRFNJVW1NTEY2eWxRYzNn
    PT0=

```



#### Hybrid Key Access

Another scneario is we want to allow break-glass with a local HSM or KAS cache,
but fall back to remote KASes. This can be accomplished by sharing each split
with the HSM.

```
- policyBinding: |
    TkRrNE9HSTRZV001WVROa09HWmhZVGd3TWpOaE5qWTRZMlF3WldZNU4yVmhNRGN3TlRWaE56VTJP
    VFpsT0RsaFl6QmhPVEk0TXpVMk5tUm1OVFk0WkE9PQ==
  sid: a
  url: alpha.kas
  wrappedKey: |
    UVRiUnZteDFFc1I3S3pHenBLeVdncEFnVGt6aW9zVm5vc3NDM05mcVNUOS80cDhvdDZwMTJWQU93
    OVVZRUlVN1NYTVZtU3FoSlVjdDlxUlRzWGEyTkttK3NkVzdYVzNldjg2cDFzdWwyRjc5UXN6N0xM
    OTROS2kvelMxQjNDQXBNR1djanhuZ1F4VDNPcVNLRlRRcXBxS2JPYmF1UHhDTGZvZldKazBMVDdF
    WStuRTE0Y2FSTTBhbGp5b0FoL3JQYlljQ2EyTjNYNUhqZTR6ejZNRm1ZanVKUTQyS3Z6Nm5VWHpT
    TVRoMEpuSGFJOW4xZlBDTWNXd1RQYldFS0I3VWVMUGkvVmY1aEdoTFhUTVE3ZTNMVjdGMnlHNzh6
    d1dWeENkb05MKzdsSTFyVDFXTWc3RmVUR3JSSERyV2hOM091Rjk4Uk9SQlpaS2Jrc1pjTjBnZE9n
    PT0=
- policyBinding: |
    WVRneFpUbGhOelpqWm1JNU16aG1ZemhpWXpWbE5qSXpNakZqWlRBeVpqbGhPR1ExTnpZM1pUZzRO
    VGt6WlRRNVlUUTVZelU0Wm1FME5EVXpPRGMzTVE9PQ==
  sid: b
  url: beta.kas
  wrappedKey: |
    SjRlOHNKVDBVNjJ5ODY4NXJqZGMydUhZem5MREc5NEI2YU9ybVgyTHJlazlXa29sVDh5bzZnYjZ4
    RkxGS1pWSzBjV2tpSXR5ZzBBWDVvalBOZWtpM0lEbjlhQnlSQndpWnJ0cjRTNTFPMFZ3bnhXOUc2
    Q21KTWNqQnZQYzJYSGpReUtvOHJIQXhmN3d3WWx3NVU1NXJDdkFRSUEzSHoxQUFjdExLZkVBamh6
    QXhnSTBFVjlPbG5QL0lkMVVtZ2J5ZkRhNTdvTU1MWVlDMXFtem5IVEpZY0dyUUwrTjFpNmxBTUhr
    R0xOOVJ3ZFpBTkd6YlJEWFFkYUFvOUgrY2dmMGlrU1lYWkcwNGdHdWJ2WGpEdlo1cFdUaU51MFVG
    dmh5cjY4UGZTUmNzVjJiQ29sQWZZTllEc3BvckRyMHZMQUY1aTNpc3ZlNWVjaE1BM2thNzNyNXRB
    PT0=
- policyBinding: |
    TkRrNE9HSTRZV001WVROa09HWmhZVGd3TWpOaE5qWTRZMlF3WldZNU4yVmhNRGN3TlRWaE56VTJP
    VFpsT0RsaFl6QmhPVEk0TXpVMk5tUm1OVFk0WkE9PQ==
  sid: a
  url: local.hsm
  wrappedKey: |
    Tnp0U1NXRXVxU0dlVGRLRGJMK3gzMGt6bEsrdE9NdTYyV3lGWFdJbDdNdkx0eHZQWUpCUEhNZG1v
    Y0MvekdzOVZyaFU3S2JvV3hzKy9GWXkrTGgvdlR5WEFnQ1IxSGVsSjFTNzdQYWFvbVdSVG1kak5m
    Y1VOVEZNTUkxMjdoSGVjN3NHUzRLK3U4TlRxMzlHVHdLR2F4Nm16b2NWVnFRVEtMN2xaUWRxalZq
    TzJTejV3YzZ1STlzcHEwYnhKR2piWHlGSkR0V0VqTVowOFRZQ0ROT2N0UmhCT0t5QnA0RVBMVjk2
    dTRSakNvWE0yVWN2aUpkY0doVG9RZjJINnVhb1BSOVcxR2ZNWTdVUDNRSlMyMEpndDdqaG9hcGly
    MXlBSGxBVGdZamxhNm1kbjl4MGljdDBXd2Z1Yjc3VERUMy9VR25oRnYvV1BLaFJWM1BUOStqN2Zn
    PT0=
- policyBinding: |
    WVRneFpUbGhOelpqWm1JNU16aG1ZemhpWXpWbE5qSXpNakZqWlRBeVpqbGhPR1ExTnpZM1pUZzRO
    VGt6WlRRNVlUUTVZelU0Wm1FME5EVXpPRGMzTVE9PQ==
  sid: b
  url: local.hsm
  wrappedKey: |
    Z0dIRmdRMFZNR042VnpCMTBHTjlUcUlvUUpvU0FyUmR3MXhnZld0UEhBaGlkTTVRVE5nZ3JqYk1D
    SFk0MnFidEQrcUErV3lsQmlZdktwMm9QdGU5d1E3T0FONVBRSTlueWpycnp6SCtJd1BkWnI3aXl6
    VzFPL0Nwd0hKblNabXlEOE41UTNna1U2S1lLc0hPdWVsYlYzb2U4OHo1d1UrWTdxbW9PN1B5OHcx
    TnpsMnRqcEV1N2w3eE9oVGNySUgrVDhzUkZBcTV3Yit5RzRRdEFTeU9QeEhiMTNDdjlZUUcxL1FZ
    bGg3TzlkZjdEL3A5YXlybEt0VFF6RzdOTzEydGFSODY2endmSjVFYXA5Slh6T25TZmt3R0JQRUJx
    OVV1WUw4RXR3OFlOOW1TbGxBTmJKblVnVWJ3eENnbDcxQ2JORFRTTGJ1c3FPcGtKakw2SW9naGF3
    PT0=

```


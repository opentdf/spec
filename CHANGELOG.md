# Changelog

## [Unreleased]
[Unreleased]: https://github.com/virtru/tdf3-spec/compare/master...HEAD
## Added
  * _patch_: ([#17](https://github.com/virtru/tdf3-spec/pull/17))
    Add KAS swagger 
  * _patch_: ([#24](https://github.com/virtru/tdf3-spec/pull/24)), PLAT-897: `EntityObject.signerPublicKey`
    - Add a second 'signerPublicKey' field to an EO
    - This is an ephemeral public key a client may use to sign rewrap and other requests associated with the EO.
    - This is required as some algorithms and key types are more suited for encryption and others for signatures. Notably, we must support this for the smaller keys and restricted set of algorithms that NanoTDF will likely impose
    - Implementations:
      - Client [nanotdf for javascript](https://github.com/virtru/eternia/pull/78)
      - Client [c++](https://github.com/virtru/tdf3-cpp/pull/193)
      - Service [OpenStack EAS and KAS (python)](https://github.com/virtru/etheria/pull/295)

## Changes
* 1.3.4 (2019-08-05)
  * _patch_: ([#20](https://github.com/virtru/tdf3-spec/pull/20))
    Update protocol docs and diagrams.
* 1.3.3 (2019-07-14)
  * _minor_: ([#16](https://github.com/virtru/tdf3-spec/pull/16))
    Added CODEOWNERS file
* 1.3.2 (2019-07-13)
  * _minor_: ([#15](https://github.com/virtru/tdf3-spec/pull/15))
    Added MIT license
* 1.3.1 (2019-06-20)
  * _minor_: ([#14](https://github.com/virtru/tdf3-spec/pull/14))
    Example HTML wrapped TDF
* 1.3.0 (2019-06-10)
  * _minor_: ([#13](https://github.com/virtru/tdf3-spec/pull/13))
    Added mimeType to allow for reading clients to setup preview experiences.
* 1.2.0 (2019-05-10)
  * _minor_: ([#6](https://github.com/virtru/tdf3-spec/pull/6))
    WS-8962/AttributeObject: Added optional 'isDefault' boolean to AO schema.

* 1.1.1 (2019-05-10)
  * _minor_: ([#10](https://github.com/virtru/tdf3-spec/pull/10))
    NOREF: Remove reference to AES-256-CBC, which is not supported.

* 1.1.0 (2019-04-26)
  * _minor_: ([#5](https://github.com/virtru/tdf3-spec/pull/5))
    NOREF: Include version number in data object schemas.

* 1.0.0 (2019-04-25)
  * _none_: ([#3](https://github.com/virtru/tdf3-spec/pull/3))
    NOREF: Reformat CONTRIBUTING doc a bit.
  * _none_: ([#2](https://github.com/virtru/tdf3-spec/pull/2))
    NOREF: Make the project README a little slicker.
  * _major_: ([#1](https://github.com/virtru/tdf3-spec/pull/1))
    NOREF: Adding initial project structure and docs.

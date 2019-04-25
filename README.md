# Trusted Data Format Specification

Trusted Data Format (TDF) is an Open, Interoperable, JSON encoded data format for implementing Data Centric Security for objects (such as files or emails). The latest version of TDF is TDF3. This repository specifies the protocols and schemas required for TDF3 operation.

## Documentation
* [API](api/) - Swagger templates defining the TDF service APIs.
* [Protocol](protocol/) - High-level design of the TDF architecture and process workflows.
* [Schema](schema/) - Schema definitions for common TDF data objects.
* [SDK](sdk/) - Documentation for SDK setup and usage.

## Contributions
Please see the [contribution guidelines](CONTRIBUTING.md) for proposing changes and submitting feedback.

## Meet TDF
All files protected using Virtru Developer Platform are stored in TDF format. A TDF file at rest can be in one of the two forms: 

* As a Zip file with extension of `.tdf`. For example, if you are trying to protect a file named `demo.jpeg`, the file will be stored as `demo.jpeg.tdf` after encryption.
* As a HTML file with extension of `.html`. For example, if you are trying to protect a file named `demo.jpeg`, the file will be stored as `demo.jpeg.html` after encryption.

### Components of a TDF file
Irrespective of whether the TDF file is composed as a Zip or HTML, there are always two components in a TDF file:
* A `manifest.json` component. The `manifest.json` data structure has all the information anyone would need to request access to decryption key. Be sure to check out the [TDF3 Schemas](schema/) for a detailed reference on `manifest.json` 
* Encrypted Payload component. This is simply the encrypted version of the object (say a file or email) being protected. 
 
![zip](https://files.readme.io/5af8aee-Zip_and_HTML.png "Zip and HTML")

_TDF composed as Zip and HTML file._

### Principle Elements in manifest.json file

There are three principle element types within a TDF's `manifest.json` component:
* Encryption Information: for encrypting, signing, or integrity binding of Payloads and Assertions
* Payload Reference(s): reference(s) to the encrypted payload
* Assertion(s): statement(s) about payload(s); this is optional and not shown below.

![comps](https://files.readme.io/05edbb5-Screen_Shot_2018-12-10_at_9.08.21_AM.png "Components")

_A TDF file with manifest.json component and encrypted payload component._

## Features and Capabilities

### 1. Strong Encryption
TDF supports strong encryption of the data as well as strong protections for the encryption keys.

### 2. Attribute Based Access Control (ABAC)
TDF protocol supports ABAC. This allows TDF protocol to implement policy driven and highly scalable access control mechanism.

### 3. Control
TDF allows the data owner (or org's administrator) to revoke or expire access to data, even after it has left your org's boundaries.

### 4. End to end auditability
TDF protocol and infrastructure enables logging every key request - effectively adding the most reliable auditing and tracking of access requests.

### 5. Streaming and Support for Large Files
`New in TDF3`
TDF supports protection (encryption and decryption) of very large files. This is done by supporting streaming. 

### 6. Policy Binding
`New in TDF3`
TDF format provides support for cryptographic binding between payload and metadata via public key-based signatures. This guarantees that the Policy Object has not been tampered with.

### 6. Offline Create
`New in TDF3`
Thanks to the assurances provided by `Policy Binding` described above, TDF-enabled clients can create TDFs without actively connecting to the key server (in other words, no access to the internet). The offline created TDF can be sent to anyone via offline methods or when the device has access to internet again. 

### 7. Key Server Federation
`New in TDF3`
Multiple KAS servers, each hosted by a different organization, can jointly control access to a TDF file. This enables organizations to jointly own, control, audit files in a zero trust manner. 

## What's new in TDF3? A deeper look."
TDF's newest version, TDF3 adds powerful new features on top of existing capabilities. Below is a summary of what capabilities are unlocked by each new top level element within encryption information.

### 1. Streaming and Support for Large Files"
In order to support large file use cases, including streamability with high integrity, we added integrityInformation as an element to Encryption Information.  Below is a look at what it looks like in TDF3 `manifest.json` file.

![streaming](https://files.readme.io/d84d456-Screen_Shot_2018-12-10_at_9.12.05_AM.png "Streaming")

### 2. Policy Binding and Offline Create
With embedding cryptographically bound policy and wrapped keys, we enable a high assurance key server. 

![offline](https://files.readme.io/f5fb283-Screen_Shot_2018-12-10_at_9.15.27_AM.png "Offline create")

### 3. Key Server Federation
Want to protect files such that two (or more) organizations control the keys? It is now possible with TDF3. [keyAccess](schema/KeyAccessObject.md) object in particular allows for array of objects, which can allow for multiple KAS servers to participate in an object key grant.

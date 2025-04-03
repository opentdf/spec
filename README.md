# OpenTDF Specification

**The Open, Interoperable Standard for Data-Centric Security**

[![SemVer](https://img.shields.io/badge/SemVer-4.3.0-brightgreen.svg)](https://semver.org/spec/v2.0.1.html)
## Introduction

OpenTDF (Trusted Data Format) defines an open and interoperable format for embedding data protection directly into data objects themselves (like files or emails). This enables robust **data-centric security**, ensuring data remains protected wherever it travels.

This repository contains the official specification for OpenTDF, including the data format, cryptography, and protocols. It serves as the definitive reference for:

*   **Developers** building applications or SDKs that create, consume, or manage TDF objects.
*   **Organizations** implementing data protection solutions needing a standard for interoperability and integration.
*   **Partners** participating in federated ecosystems where consistent data protection across organizational boundaries is crucial.

[Client SDKs and server-side services](https://github.com/opentdf/platform) can be built upon this OpenTDF specification, ensuring standards-based security and enabling seamless interaction between different systems and organizations in a federated environment.

OpenTDF derives its modern JSON-encoded format from the original [TDF XML Specification](https://www.dni.gov/index.php/who-we-are/organizations/ic-cio/ic-cio-related-menus/ic-cio-related-links/ic-technical-specifications/trusted-data-format). For details on interoperability with legacy TDF XML formats, please [contact us](mailto:support@opentdf.io).

**Versioning:** This specification adheres to the [Semantic Versioning 2.0.0](https://semver.org/) standard.

## Navigation

- [Specification Details](#specification-details)
  - [Schema (`schema/`)](schema/)
  - [Protocol (`protocol/`)](protocol/)
  - [Concepts (`concepts/`)](concepts/)
- [Lineage and Usage](#lineage-and-usage)
- [Key Concepts](#key-concepts)
- [Core Features & Capabilities](#core-features--capabilities)
- [TDF Structure](#tdf-structure)
- [NanoTDF](#nanotdf-a-compact-binary-format)
- [Reference Implementation & SDKs](#reference-implementation--sdks)
- [Contributing](#contributing)
- [Contact](#contact)

## Specification Details

The detailed technical specification is organized into the following sections:

*   **[Schema (`schema/`)](schema/):** Defines the JSON schemas for the `manifest.json` and its constituent objects (like `EncryptionInformation`, `KeyAccess`, `PolicyObject`, etc.). This is the reference for the data structure format.
*   **[Protocol (`protocol/`)](protocol/):** Describes the high-level architecture, process workflows (e.g., key requests, unwrapping), and interactions between clients, Key Access Servers (KAS), and Identity Providers.
*   **[Concepts (`concepts/`)](concepts/):** Contains detailed explanations of core concepts including access control and security principles.

Developers should consult these sections for implementation details regarding data formats, cryptographic operations, and protocol interactions.

## Lineage and Usage

OpenTDF represents a modernization of data-centric security concepts originally established in the **IC-TDF** (Intelligence Community Trusted Data Format) specification. While IC-TDF utilized an XML-based structure, OpenTDF adopts a more contemporary approach using JSON for its manifest, enhancing flexibility and ease of integration with modern web technologies.

Furthermore, OpenTDF serves as the foundational layer for other specialized data formats. Notably, **ZTDF** (Zero Trust Data Format), developed within NATO contexts, builds directly upon the OpenTDF specification. ZTDF extends OpenTDF by mandating the inclusion of specific cryptographic assertions required for NATO use cases, ensuring compliance with their operational requirements.

The detailed specifications for IC-TDF and ZTDF are maintained separately and are not covered within this document.

## Key Concepts

At its core, OpenTDF wraps sensitive data within a protective layer. This layer includes:

1.  **Encrypted Payload:** The original data, strongly encrypted.
2.  **Metadata Manifest:** A `manifest.json` file containing crucial information, such as:
    *   How the payload was encrypted.
    *   Where to retrieve the decryption key (Key Access information).
    *   The access control policy governing the data.
    *   Optionally, cryptographic assertions about the data or policy.

This structure allows fine-grained control and auditing, independent of underlying storage or transport systems.

To learn more about access control, and what makes OpenTDF secure, reference the following sections:

* [Access Control](./concepts/access_control.md)
* [Security](./concepts/security.md)

## Core Features & Capabilities

OpenTDF is designed to provide comprehensive data security through the following features:

*   **Strong Encryption:** Utilizes robust, modern cryptographic algorithms to protect both the data payload and the encryption keys themselves.
*   **Attribute-Based Access Control (ABAC):** Enables highly scalable and flexible access control based on attributes of users, data, and the environment, defined within the TDF's policy.
*   **Persistent Policy Enforcement:** Access policies are bound to the data, allowing data owners or administrators to manage access even after the data has been shared outside organizational boundaries.
*   **End-to-End Auditability:** The protocol facilitates comprehensive logging of key requests, providing a reliable audit trail of data access attempts.
*   **Large File & Streaming Support:** Efficiently handles large data objects through secure streaming mechanisms, maintaining integrity throughout the process.
*   **Policy Integrity:** Cryptographically binds the access policy defined in the manifest to the key access information, preventing policy tampering after creation.
*   **Offline Creation:** Allows TDF objects to be created securely by clients even without immediate network connectivity to a key server, thanks to policy binding assurances.
*   **Federated Key Management:** Supports scenarios where multiple Key Access Servers (KAS), potentially hosted by different organizations, can collaboratively manage access to a single TDF object, enabling secure cross-domain collaboration in a zero-trust manner.

## TDF Structure

By default, a TDF object is packaged as a standard Zip archive file, typically using the `.tdf` extension appended to the original filename. This archive contains two primary components: 

1. **`manifest.json`:** The metadata manifest described in the Key Concepts section. It holds instructions for decryption and access control. 
2. **`payload`:** The encrypted data payload itself. 

However, a TDF can be encoded in other ways. For example, as an HTML document:

![TDF Structure Illustration](https://files.readme.io/5af8aee-Zip_and_HTML.png "TDF composed as Zip and HTML file")
_A TDF object can be packaged as a standard ZIP, or as an HTML document_

## NanoTDF: A Compact Binary Format 

Alongside the primary OpenTDF specification based on JSON manifests, this project also defines **NanoTDF**. NanoTDF is a **compact binary format** designed specifically for resource-constrained environments (e.g., IoT devices, scenarios with limited bandwidth, storage, or processing power) where the overhead of the standard Zip/JSON format might be prohibitive.

It achieves minimal size by using a highly optimized binary structure and relying exclusively on Elliptic Curve Cryptography (ECC). 

While OpenTDF offers flexibility and rich metadata, NanoTDF prioritizes size efficiency for specific use cases. 

**➡️ For details, please refer to the [NanoTDF Specification](./nanotdf/README.md).** 

## Reference Implementation & SDKs

A robust, open-source reference implementation of the OpenTDF specification is actively developed and maintained at **[opentdf/platform](https://github.com/opentdf/platform)**.

This platform provides:

*   **Client SDKs:** Ready-to-use libraries for integrating TDF capabilities into applications:
    *   **Java**
    *   **JavaScript**
    *   **Go**
*   **Server Components:** Example implementations of backend services like the Key Access Server (KAS).

Developers can use this platform as a practical guide, a starting point for their own implementations, or directly leverage the provided SDKs.

## Contact

For questions regarding OpenTDF, interoperability, or the specification, please reach out to [support@opentdf.io](mailto:support@opentdf.io).
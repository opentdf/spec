# OpenTDF Specification Overview

This section details the **OpenTDF** format, the primary specification for general-purpose Trusted Data Format (TDF) implementations. It utilizes a JSON-based manifest packaged with the encrypted payload within a standard Zip archive.

## Core Concepts

Before diving into specific object definitions, understand these core OpenTDF concepts:

*   **Security:** Learn about what makes OpenTDF secure. See [Security Concepts](./concepts/security.md).
*   **Key Access and Wrapping:** How access control is defined using ABAC. See [Access Control](./concepts/access_control.md).

## Format Structure

An OpenTDF file is a Zip archive, typically using the `.tdf` extension (e.g., `document.pdf.tdf`). It MUST contain the following components:

1.  **`manifest.json`:** A JSON file containing all metadata required for decryption and access control. This is the core of the TDF structure.
2.  **`payload`:** The encrypted original data. The filename within the archive is referenced by the `manifest.json` (commonly `0.payload`).

![img](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMjgwIj4KICA8IS0tIE1haW4gY29udGFpbmVyIC0tPgogIDxyZWN0IHg9IjUwIiB5PSIzMCIgd2lkdGg9IjMwMCIgaGVpZ2h0PSIyMjAiIHJ4PSI1IiByeT0iNSIgZmlsbD0iI2YwZjBmMCIgc3Ryb2tlPSIjMzMzIiBzdHJva2Utd2lkdGg9IjIiLz4KICA8dGV4dCB4PSIyMDAiIHk9IjU1IiBmb250LWZhbWlseT0iQXJpYWwsIHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZpbGw9IiMzMzMiPm15X2RvY3VtZW50LmV4dC50ZGYgKFppcCk8L3RleHQ+CiAgCiAgPCEtLSBtYW5pZmVzdC5qc29uIC0tPgogIDxyZWN0IHg9IjcwIiB5PSI4MCIgd2lkdGg9IjI2MCIgaGVpZ2h0PSI1MCIgcng9IjMiIHJ5PSIzIiBmaWxsPSIjZmZmZmZmIiBzdHJva2U9IiM2NjYiIHN0cm9rZS13aWR0aD0iMS41Ii8+CiAgPHRleHQgeD0iMjAwIiB5PSIxMTAiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNCIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZmlsbD0iIzMzMyI+bWFuaWZlc3QuanNvbjwvdGV4dD4KICAKICA8IS0tIDAucGF5bG9hZCAtLT4KICA8cmVjdCB4PSI3MCIgeT0iMTUwIiB3aWR0aD0iMjYwIiBoZWlnaHQ9IjUwIiByeD0iMyIgcnk9IjMiIGZpbGw9IiNmZmZmZmYiIHN0cm9rZT0iIzY2NiIgc3Ryb2tlLXdpZHRoPSIxLjUiLz4KICA8dGV4dCB4PSIyMDAiIHk9IjE4MCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjE0IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmaWxsPSIjMzMzIj4wLnBheWxvYWQgKEVuY3J5cHRlZCk8L3RleHQ+Cjwvc3ZnPg==)

## Navigation

Use the links below to explore the detailed structure of each component:

*   [**Manifest Structure (`manifest.json`)**](./manifest.md)
*   [Payload Object](./payload.md)
*   [Encryption Information Object](./encryption_information.md)
    *   [Key Access Object](./key_access_object.md)
    *   [Method Object](./method.md)
    *   [Integrity Information Object](./integrity_information.md)
    *   [Segment Object](./segment.md)
*   [Assertions](./assertion.md)
    *   [Statement Object](./assertion_statement.md)
    *   [Binding Object](./assertion_binding.md)
*   [**Conceptual Guides:**](./)
    *   [Security](./concepts/security.md) 
    *   [Access Control](./concepts/access_control.md)

## Key Components of `manifest.json`

The `manifest.json` file orchestrates the TDF. Its main sections are:

*   **Payload Description:** Information about the encrypted payload (type, reference, protocol, encryption status). See [Payload Object](./payload.md).
*   **Encryption Information:** Details on how the payload was encrypted, how to access the key, integrity checks, and the access policy. See [Encryption Information](./encryption_information.md). This includes:
    *   [Key Access Objects](./key_access.md): How and where to get the decryption key.
    *   [Method](./method.md): Symmetric encryption algorithm details.
    *   [Integrity Information](./integrity_information.md): Hashes/signatures for payload integrity.
    *   [Policy](./policy_concepts.md): The access control policy (embedded as a Base64 string).
*   **Assertions:** Optional, verifiable statements about the TDF or payload. See [Assertions](./assertions.md).
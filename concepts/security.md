# OpenTDF Security Concepts

OpenTDF is designed with security and tamper evidence as core principles, enabling data-centric protection where security travels with the data itself. This document outlines the key conceptual mechanisms that provide these guarantees.

## 1. Payload Encryption

The most fundamental layer of protection is **payload encryption**. The original data within a TDF is encrypted using strong, authenticated symmetric encryption algorithms (typically AES-256-GCM). This ensures the confidentiality of the data – it cannot be read without the correct decryption key. The management and protection of this decryption key are handled by other mechanisms described below.

## 2. Payload Integrity Verification

While encryption protects confidentiality, it doesn't inherently prevent undetected modification of the *ciphertext*. An attacker could potentially flip bits in the encrypted data. OpenTDF addresses this using the **`integrityInformation`** object within the manifest.

*   **Purpose:** To allow recipients to verify that the encrypted payload has not been altered since its creation. This is especially critical for streamed data.
*   **Mechanism:**
    1.  **Segmentation:** The plaintext payload is processed in chunks (segments).
    2.  **Segment Tagging (GMAC for AES-GCM):** For `method.algorithm = AES-256-GCM`, the segment `hash` is the AEAD authentication tag (GMAC) produced during encryption of that segment. It is computed with the payload key, the per-segment nonce, and any AAD, and stored as Base64 in the Segment Object.
    3.  **Root Signature (HS256):** Concatenate the raw bytes of each segment tag in order (Base64-decode each `segments[i].hash` and concatenate). Compute `HMAC-SHA256` over that byte stream using the payload key, then Base64-encode the result as `rootSignature.sig`.
    4.  **Nonce Requirement:** For streamable AES-GCM, each segment MUST use a unique nonce. The derivation and encoding MUST be specified by the encryption method. Reuse is catastrophic.
*   **Result:** Any modification to even a single bit of the encrypted payload will invalidate the integrity tag of the affected segment *and* consequently invalidate the final `rootSignature`. During decryption, the receiving client MUST verify each segment's AEAD tag and the overall `rootSignature`. Failure indicates tampering.

**Note on plaintext payloads:** `payload.isEncrypted=false` is reserved for future use; integrity rules for plaintext payloads are out of scope.

## 3. Policy Binding

It's crucial that the access policy defined for a TDF cannot be detached from the key required to decrypt it. An attacker shouldn't be able to take a wrapped key associated with a strict policy and attach it to a TDF manifest that specifies a weaker policy. The **`policyBinding`** object within *each* [Key Access Object](../schema/OpenTDF/key_access_object.md) prevents this.

*   **Purpose:** To cryptographically link the specific access policy (defined in `encryptionInformation.policy`) to a particular wrapped key share held by a specific Key Access Server (KAS).
*   **Mechanism:**
    1.  The client retrieves the full, Base64-encoded `policy` string from the `encryptionInformation` section of the manifest it is constructing.
    2.  For *each* key share it prepares to wrap for a specific KAS, the client takes the *plaintext key share* itself.
    3.  It calculates an HMAC (e.g., HMAC-SHA256, specified by `policyBinding.alg`) using the **plaintext key share** as the secret key and the **Base64-encoded policy string** as the message data.
    4.  This resulting HMAC hash is Base64 encoded and stored as `policyBinding.hash` within the *same* `keyAccess` object that contains the corresponding wrapped key share.
*   **Result:** When a recipient requests key access from a KAS, they provide the `keyAccess` object (including the `policyBinding`). The KAS decrypts the `wrappedKey` to get the plaintext key share. It then *recalculates* the policy binding HMAC using this key share and the policy string provided (or referenced) in the request. If the calculated hash matches the `policyBinding.hash` received from the client, the KAS knows the policy presented corresponds to the one originally bound to this key share. If they don't match, it indicates tampering or a mismatch, and the KAS MUST deny the request.

## 4. Key Splitting (Multi-Party Access Control)

To enhance security and enable multi-party control, OpenTDF supports **key splitting**. Instead of a single KAS holding the complete (wrapped) key, the key can be divided into multiple shares distributed across different KAS instances.

*   **Purpose:** To require authorization from multiple, independent KAS entities before a client can reconstruct the full payload decryption key. This prevents a single compromised KAS from leaking the key and enforces multi-party access control logic.
*   **Mechanism:**
    1.  The client generates the payload encryption key.
    2.  It splits the key into multiple cryptographic shares (e.g., using XOR with random nonces such that `Share1 ⊕ Share2 ⊕ ... ⊕ ShareN = FullKey`).
    3.  Each share is treated as an independent key: it's wrapped using the public key of its designated KAS and associated with its own [Policy Binding](#policy-binding).
    4.  Each wrapped share is stored in a separate [Key Access Object](../schema/OpenTDF/key_access_object.md) within the `encryptionInformation.keyAccess` array. Crucially, each of these objects is assigned a unique **Split ID** (`sid`).
    5.  To decrypt, a client must contact *each* KAS responsible for a required share (identified via the `sid` and `url`).
    6.  Each KAS independently verifies the request against its bound policy (using the [Policy Binding](#policy-binding)).
    7.  If all necessary KASes grant access, the client receives the unwrapped *shares*.
    8.  The client reconstructs the full payload key by combining the shares (e.g., XORing them together).
*   **Result:** Access requires successfully authenticating and satisfying the policy constraints at *multiple* independent KAS instances. No single KAS holds enough information to decrypt the data alone.

## Summary: Layered Security

These mechanisms work together:
*   **Encryption** protects confidentiality.
*   **Payload Integrity** ensures the encrypted data hasn't been undetectably modified.
*   **Policy Binding** ensures the access policy cannot be decoupled from the key access grant for a specific KAS.
*   **Key Splitting** enforces multi-party authorization, preventing single points of failure or compromise for key access.

This layered approach provides robust, data-centric security and tamper evidence for data protected by OpenTDF.

# OpenTDF Access Control Concepts (ABAC)

OpenTDF implements a sophisticated access control model known as **Attribute-Based Access Control (ABAC)**. This approach provides fine-grained, flexible, and scalable authorization for data protection.

## What is ABAC?

Attribute-Based Access Control is a security paradigm where access rights are granted based on the evaluated **attributes** of entities involved in an access request, rather than solely on roles or explicit permissions lists. Key components include:

*   **Subject Attributes:** Characteristics of the entity requesting access (e.g., user's clearance, department, nationality, group memberships).
*   **Resource Attributes:** Characteristics of the data or resource being accessed (e.g., data classification, sensitivity level, project code).
*   **Policies:** Rules that define allowable actions by comparing subject, resource, and potentially environment attributes (e.g., "Allow access if subject's clearance >= resource's classification AND subject is in department 'X'").
*   **Policy Enforcement Point (PEP):** The logical component that evaluates the policies against the attributes and makes the final access decision (grant or deny).

ABAC offers significant advantages over traditional models, enabling dynamic access decisions that adapt to changing conditions without needing constant updates to user roles or access control lists (ACLs).

## OpenTDF's Implementation of ABAC

OpenTDF embeds ABAC directly into the data's protection layer. Here's how its components map to ABAC concepts:

*   **Subject Attributes:** Represented by **Entity Entitlements**. These are the attribute instances asserted by the identity system or client about the user/entity requesting access. They are provided *to* the PEP during an access request.
*   **Resource Attributes:** Defined within the TDF's [Policy Object](./policy_object.md) in the `dataAttributes` array. These specify the attribute instances *required* to access this specific piece of data.
*   **Policies:** Defined by the combination of:
    *   The `dataAttributes` required by the specific TDF.
    *   The optional `dissem` list in the TDF's [Policy Object](./policy_object.md) acting as an initial filter.
    *   **Attribute Definitions** managed externally by Attribute Authorities, which specify the *rules* (e.g., AllOf, AnyOf, Hierarchy) for comparing subject and resource attributes.
*   **Policy Enforcement Point (PEP):** Typically resides within the Key Access Server (KAS) or associated logic. It receives the TDF's policy requirements, the subject's entitlements, retrieves the relevant Attribute Definitions, and makes the authorization decision before releasing a key.

## OpenTDF Attribute Representation

To ensure interoperability and clarity, OpenTDF represents attributes as **URIs (Uniform Resource Identifiers)**.

The standard structure is:
`{Attribute Namespace}/attr/{Attribute Name}/value/{Attribute Value}`

**Components:**

| Component                    | Example Value                                          | Description                                                                                                                                   | Globally Unique? |
| :--------------------------- | :----------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------- | :--------------- |
| **Attribute Namespace**      | `https://example.com`                                  | Typically a domain controlled by the authoritative source of the attribute definition. Recommended to use a stable, controlled namespace.     | No (by itself)   |
| **Attribute Canonical Name** | `https://example.com/attr/classification`              | Combination of Namespace and Name (`{Namespace}/attr/{Name}`). **This MUST be globally unique** and identifies the specific attribute *type*. | **Yes**          |
| **Attribute Instance**       | `https://example.com/attr/classification/value/secret` | The full URI (`{Canonical Name}/value/{Value}`). This represents a specific, actionable attribute assertion used in policies or entitlements. | **Yes**          |

## Attribute Definitions (External Rules)

Crucially, the *rules* governing how attributes are compared are defined in **Attribute Definitions**, which are associated with the globally unique **Attribute Canonical Name**. These definitions are managed by the attribute authority and are stored **outside** the TDF manifest itself.

An Attribute Definition typically includes:

*   **Rule Type:** How multiple values or comparisons should be handled (e.g., `AllOf` - entity must have all specified values, `AnyOf` - entity must have at least one, `Hierarchy` - values have an order).
*   **Allowed Values:** An optional enumeration or pattern restricting valid attribute values.
*   **Order/Rank (for Hierarchy):** Defines the relationship between values in a hierarchical attribute (e.g., Confidential < Secret < TopSecret).

The PEP retrieves these definitions at access decision time based on the Canonical Names found in the TDF's `dataAttributes` and the entity's entitlements.

## Access Control Flow in OpenTDF

When an entity requests access to an OpenTDF object:

1.  **Request Initiation:** The client presents the relevant [Key Access Object(s)](./key_access.md) from the TDF manifest to the appropriate KAS, along with the client's credentials and asserted **Entity Entitlements** (Subject Attributes).
2.  **PEP Evaluation:** The KAS performs the following checks based on the TDF's embedded [Policy Object](./policy_object.md) (extracted from the `policy` field):
    *   **Dissemination Check (if applicable):** If the policy's `dissem` list is present and non-empty, the PEP verifies if the requesting entity's identifier is in the list. If not, access is **denied**.
    *   **Attribute Check:**
        *   The PEP examines the required `dataAttributes` (Resource Attributes) listed in the policy.
        *   For each required attribute, it retrieves the corresponding external **Attribute Definition** based on the attribute's Canonical Name.
        *   It compares the required `dataAttributes` against the provided **Entity Entitlements** using the comparison logic (AllOf, AnyOf, Hierarchy) specified in the retrieved Attribute Definitions.
        *   If the entity's entitlements **do not satisfy** the requirements of *all* `dataAttributes` according to their rules, access is **denied**.
3.  **Key Release (if authorized):** If *both* the Dissemination Check (if applicable) and the Attribute Check pass, the PEP considers the entity authorized. It then proceeds with verifying the [Policy Binding](./security_concepts.md#3-policy-binding) and, if valid, unwraps and provides the requested key share(s) to the client.

> **Policy Logic Clarification:** The relationship between the `dissem` list and the `dataAttributes` is effectively an **AND**. An entity MUST be on the `dissem` list (if it's used) **AND** MUST satisfy the `dataAttributes` requirements.
> If the `dissem` list is empty or omitted, then *only* the `dataAttributes` requirements need to be met. The `dissem` list acts as an additional filter to narrow the audience beyond what the attributes alone define.

By combining embedded policy requirements with externally defined attribute rules, OpenTDF achieves a powerful and flexible ABAC implementation for data-centric security.
# Entitlement Object

## Summary

An Entitlement Object represents a complete set of entitlements (that is, a set of [Attribute Objects](AttributeObject.md)) for a single Entity (PE or NPE).

An Entitlement Object defines the attributes a single Entity (PE or NPE) _is entitled with_.

A [Claims Object](ClaimsObject.md) is composed of one or more Entitlement Objects.

Access decisions are made by comparing the attribute entitlements of one or more entities against the attributes a data policy requires.

The Entitlement Object alone _does not_ define how the KAS will compare an entity's attribute to an object attribute when making an access decisions, as there may be multiple Entitlement Objects involved in an access request.

## Example

```json
{
    "entity_identifier":"cliententityid-14443434-1111343434-asdfdffff",
    "entity_attributes":[
    {
        "attribute":"https://example.com/attr/Classification/value/S",
        "displayName":"classification"
    },
    {
        "attribute":"https://example.com/attr/COI/value/PRX",
        "displayName":"category of intent"
    }
    ]
}
```

| Parameter                   | Type   | Description                                                                                                                              | Required?          |
|-----------------------------|--------|------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| `entity_identifier`| String | An identifer for the entitled entity. Note that this field is purely informational - *no access decisions* should depend on this value.  | Yes                |
| `entity_attributes`| Array  | An array of [Attribute Objects](AttributeObject.md) that entitle the given entity.                                                       | Yes (can be empty) |

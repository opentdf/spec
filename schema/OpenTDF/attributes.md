# Attribute Object (Structure)

This document describes the JSON structure representing an Attribute Instance when embedded within a [Policy Object](./policy.md). For a conceptual overview of attributes, and their role in access control, see [Access Control Concepts](../../concepts/access_control.md).

An Attribute Object represents a single required attribute instance needed to access the data.

## Example

```json
{
  "attribute": "https://example.com/attr/classification/value/topsecret"
}
```
## Fields

| Parameter | Type   | Description                                                                                                                                                                | Required? |
| --------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| attribute | String | The full Attribute Instance URI, composed of {Namespace}/attr/{Name}/value/{Value}. See [Access Control concepts](../../concepts/access_control.md). |           |

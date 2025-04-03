# Attribute Object (Structure)

This document describes the JSON structure representing an Attribute Instance when embedded within a [Policy Object](./policy_object.md). For a conceptual overview of attributes, see [Attribute Concepts](./attribute_concepts.md).

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
| attribute | String | The full Attribute Instance URI, composed of {Namespace}/attr/{Name}/value/{Value}. See [Attribute Concepts](https://www.google.com/url?sa=E&q=.%2Fattribute_concepts.md). |           |

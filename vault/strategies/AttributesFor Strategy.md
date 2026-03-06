---
type: note
created: 2025-08-29T15:44:49-05:00
updated: 2026-01-09T16:40:04-06:00
tags:
  - strategies
aliases:
  - attributes_for
  - attributes_for Strategy
  - The attributes_for Strategy
up: "[[§ Strategies]]"
---
# AttributesFor Strategy

The **AttributesFor Strategy** constructs a Hash containing attributes and values defined for the object class of the factory.

## Syntax Methods

- `FactoryBot.attributes_for`
- `FactoryBot.attributes_for_pair`
- `FactoryBot.attributes_for_list`

## Implementation

The `attributes_for` method constructs a `Hash` with the attributes and their values, using `initialize_with`. 

- [[Associations]] are constructed using the `null` construction strategy (they are not [[build Strategy|built]]).
- No [[Callbacks|Callback Hooks]] are called.

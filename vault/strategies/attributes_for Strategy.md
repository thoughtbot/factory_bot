---
type: note
created: 2025-08-29T15:44:49-05:00
updated: 2025-11-08T21:23:28-06:00
tags:
  - strategies
aliases:
  - attributes_for
  - attributes_for Strategy
  - The attributes_for Strategy
---
# The `attributes_for` Strategy

The `FactoryBot.attributes_for` method constructs a `Hash` with the attributes
and their values, using `initialize_with`. 

- The `attributes_for_pair` and `attributes_for_list` methods work similarly as `build_pair` and `build_list`.
- Associations are constructed using the `null` construction strategy
  (they are not [[build Strategy|built]]).
- No [[§ callbacks|Callback Hooks]] are called.

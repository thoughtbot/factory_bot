---
type: note
created: 2025-11-08T19:36:58-06:00
updated: 2026-01-09T14:38:52-06:00
tags: []
aliases: []
up: "[[§ Associations]]"
---
# Inline Associations

**Inline Associations** are defined using the `association` method within the block of a regular [[Attributes|Attribute]]

```ruby
factory :post do
  # ...
  author { association :author }
end
```

## Notes

- that the value of an **inline association** will be `nil` when using the `attributes_for` strategy.
- See [[Explicit Attributes]] for more information on the `association` method
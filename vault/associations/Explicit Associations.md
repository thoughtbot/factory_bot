---
type: note
created: 2025-11-08T19:35:50-06:00
updated: 2025-11-08T19:44:07-06:00
tags: []
aliases: []
---
# Explicit Associations

**Explicit Associations** are declared using the `association` method.

## The `association` Method

Within a factory block, use the `association` method to always make an additional object alongside this one. This name best makes sense within the context of ActiveRecord.

```ruby
factory :post do
  # ...
  association :author
end
```

### Arguments

The `association` method takes a mandatory name and optional options:

- The **name** should be a Symbol or String
- The **options** are zero or more [[§ traits|Trait]] names (Symbols), followed by a hash of [[Attribute Overrides]]. When constructing this association, factory\_bot uses the trait and attribute overrides given.
- The options also accept `:factory` to [[Specifying the Factory on Associations|specify the factory]].

## Notes

- **Explicit Associations** can be handy when [[Attribute Overrides|Overriding Attributes]]
- 
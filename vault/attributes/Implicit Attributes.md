---
type: note
created: 2025-11-08T17:43:13-06:00
updated: 2025-11-08T19:28:06-06:00
tags: []
aliases:
  - Implicit Attribute
---
# Implicit Attributes

An **Implicit Attribute** is declared using a shorthand syntax where a [[Unknown Methods|Missing Method]] that is invoked and passed a block.

```ruby
factory :robot do
  name { "Ralph" }
end
```

In the example above, the declare attribute will be given a name of `:name`, and objects constructed by the factory will have value of `"Ralph"` assigned to their `name` field. 

## Notes

- The **Implicit Attribute** syntax alleviates the need to use the `add_attribute` method used to define [[Explicit Attributes]].
- To learn more about the implicit shorthand, read about [[Unknown Methods]] and how they rely on Ruby's `method_missing` functionality.
- The code example above is also an example of a [[Dynamic Attributes|Dynamic Attribute]] as a block is passed in as an argument.

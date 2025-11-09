---
type: note
created: 2025-11-07T15:07:22-06:00
updated: 2025-11-07T16:05:32-06:00
tags: []
aliases: []
---
# Global Sequences

## Defining a Global Sequence

To define a global sequence:

- Within a `Factory.define` block, use the `sequence` method to define global sequences that can be shared with other factories.
- The `sequence` method takes a name, optional arguments, and a block. 
- The *name* is expected to be a Symbol.
- The supported *optional arguments* are a number representing the starting value (default: `1`), and `:aliases` (default `[]`). 
- The starting value must respond to `#next`.
- The block takes a value as an argument, and returns a result.

```ruby
FactoryBot.define do
  sequence(:email, 1, aliases: [:email_address]) do |n| 
    "person#{n}@example.com"
  end
end
```

## Value Incrementation Behavior

The sequence value is incremented globally. Using an `:email_address` sequence from multiple places, for example, would increment the value each time.

## Related

See [method_missing](method_missing.html) for a shorthand.

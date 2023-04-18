# sequence

A factory\_bot set up supports two levels of sequences: global and factory-specific.

## Global sequences

With a [`Factory.define`] block, use the `sequence` method to define global
sequences that can be shared with other factories.

[`Factory.define`]: define.html

The `sequence` method takes a name, optional arguments, and a block. The name
is expected to be a Symbol.

The supported arguments are a number representing the starting value (default:
`1`), and `:aliases` (default `[]`). The starting value must respond to `#next`.

The block takes a value as an argument, and returns a result.

The sequence value is incremented globally. Using an `:email_address` sequence
from multiple places increments the value each time.

See [method_missing](method_missing.html) for a shorthand.

## Factory sequences

Sequences can be localized within `factory` blocks. The syntax is the same as
for a global sequence, but the scope of the incremented value is limited to the
factory definition.

In addition, using `sequence` with a `factory` block implicitly calls
`add_attribute` for that value.

These two are similar, except the second example does not cause any global
sequences to exist:

```ruby
# A global sequence
sequence(:user_factory_email) { |n| "person#{n}@example.com" }

factory :user do
  # Using a global sequence
  email { generate(:user_factory_email) }
end
```

```ruby
# A factory-scoped sequence
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end
```

---
type: note
created: 2025-11-07T15:08:39-06:00
updated: 2025-11-07T15:34:17-06:00
tags: []
aliases: []
---
# Factory Sequences


Sequences can be localized within `factory` blocks. The syntax is the same as for a global sequence, but the scope of the incremented value is limited to the factory definition.

In addition, using `sequence` with a `factory` block implicitly calls `add_attribute` for that value.

These two are similar, except the second example does not cause any global sequences to exist:

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


## Numbered Parameter Usage

With Ruby 2.7's support for [numbered parameters][], inline definitions can be
even more abbreviated:

```ruby
factory :user do
  sequence(:email) { "person#{_1}@example.com" }
end
```

[numbered parameters]: https://ruby-doc.org/core-2.7.1/Proc.html#class-Proc-label-Numbered+parameters

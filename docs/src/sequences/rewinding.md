# Rewinding

Sequences can also be rewound with `FactoryBot.rewind_sequences`:

```ruby
sequence(:email) {|n| "person#{n}@example.com" }

generate(:email) # "person1@example.com"
generate(:email) # "person2@example.com"
generate(:email) # "person3@example.com"

FactoryBot.rewind_sequences

generate(:email) # "person1@example.com"
```

This rewinds all registered sequences.

---
type: note
created: 2025-11-07T15:31:57-06:00
updated: 2025-11-07T18:10:50-06:00
tags: []
aliases: []
---
# Overview of Sequences

A **sequence** is a construct that generates a linear sequence of values. 

## Sequence Levels

factory\_bot supports two levels of sequences: global and factory-specific.

### Global Sequences

a **Global Sequence** is a sequence that is available for use within any factory or trait.

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
end
```

see [[Global Sequences]] for more information

### Factory Sequences

A **Factory Sequence** is a [[§ sequences|Sequence]] that is only available for use within a particular factory, it's traits, or any child factories.

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
  end
end
```

see [[Factory Sequences]]  for more information

## Generating Sequences

Sequences can be manually generated using either the `generate` or `generate_list` methods. 

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
end

generate(:email)
generate_list(:email, 2)
```

For more information, see [[Generating a Sequence]]

## Sequence URI

The [[Sequence URI]] is a unique composite of named components used to identify specific sequences. They should be used as positional arguments when invoking methods such as `generate` and `generate_list`.

For more information, see [[Sequence URI]]

## Rewinding Sequences

- All sequences can be rewound by invoking `FactoryBot.rewind_sequences`. 
- Individual sequences can be rewound  by invoking `FactoryBot.reqind_sequence` and passing in the name of the sequence as an argument (or the [[Sequence URI]])

For more information, see [[Rewinding a Sequence]]

## Technical Details

Sequences are implemented as an object which binds a name, a counter value, and an optional Proc.

- the **name** serves as an identifier
- the **value** serves as a counter which is incremented.
    - The value may be an `Enumerator` or any object which responds to `#next` and returns a successor value.
    - The `String` and `Integer` classes, for example, both provide an implementation of `#next`. This enables sequences to increment in both an alphabetical and numerical fashion.
- the optional **Proc** accepts the value as argument and returns the desired output value

When generating the next value in a sequence that includes a **Proc**, the Proc is used to transform the counter value to the desired output format. This may be done though computation, string interpolation, or other business logic. When the **Proc** is omitted, however, generating the next value in the sequence produces the current **value** as the output.

After output is generated from a sequence the counter value is incremented. The sequence object calls `#next` on the current value to retrieve the successor value. The successor value is stored and used as the current value when the next output is generated from the sequence.

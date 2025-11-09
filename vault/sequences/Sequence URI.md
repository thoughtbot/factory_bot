---
type: note
created: 2025-11-07T16:26:14-06:00
updated: 2025-11-07T16:50:06-06:00
tags: []
aliases: []
---
# Sequence URI

Sequences can be manipulated from outside the scope of a factory by referencing a specific sequence through the use of it's composite **Uniform Resource Identifier (URI)** pattern. 

## Reasons to Manipulate Specific Sequences

A sequence can be manipulated by:

- [[Generating a Sequence]]
- [[Setting the Current Value of a Sequence]]
- [[Rewinding a Sequence]]

More specifically, you may wish to:

- generate a single value with `generate`
- generate a array of multiple values with `generate_list`
- set a sequence to a new value with `FactoryBot.set_sequence`
- rewind a sequence with `rewind_sequence`

To accomplish this it must be possible to reference the desired sequence. This is achieved with its unique URI.

## URI Composition

Each URI is comprised of up to three named components:

| position | name          | required?                                                          |
| :------: | ------------- | ------------------------------------------------------------------ |
|    1.    | factory name  | **if** the sequence is defined within a Factory or a Factory Trait |
|    2.    | trait name    | **if** the sequence is defined within a Trait                      |
|    3.    | sequence name | **always required**                                                |

### URI Components as Symbols

The URI can be entered as individual symbols:

```ruby
generate(:my_factory_name, :my_trait_name, :my_sequence_name)
```

### URI Components as Strings

The URI can be entered as individual strings:

```ruby
generate('my_factory_name', 'my_trait_name', 'my_sequence_name')
```

### URI as a Single Resource String

The URI can be entered as a single resource string:

```ruby
generate("my_factory_name/my_trait_name/my_sequence_name")
```

## Example: All URI Scenarios

This example illustrates all the possible scenarios which produce all the composite variants of Sequence URIs. The comments show how the URI may be used to generate a value for each specific sequence:

```ruby
FactoryBot.define do
  sequence(:sequence) {|n| "global_sequence_#{n}"}
  # generate(:sequence)

  trait :global_trait do
    sequence(:sequence) {|n| "global_trait_sequence_#{n}"}
    # generate(:global_trait, :sequence)
  end

  factory :user do
    sequence(:sequence) {|n| "user_sequence_#{n}"}
    # generate(:user, :sequence)

    trait :user_trait do
      sequence(:sequence) {|n| "user_trait_sequence_#{n}"}
      # generate(:user, :user_trait, :sequence)
    end

    factory :author do
      sequence(:sequence) {|n| "author_sequence_#{n}"}
      # generate(:author, :sequence)

      trait :author_trait do
        sequence(:sequence) {|n| "author_trait_sequence_#{n}"}
        # generate(:author, :author_trait, :sequence)
      end
    end
  end
end
```


> [!WARNING] **Important:** Notes on Nesting
> - No matter how deeply nested, the factory name component of the URI is always the factory where the sequence is defined, not any parent factories.
> - If a factory inherits a sequence, the URI must reference the factory where it was defined, not the one in which it is used.

## Sequences May Have Multiple URIs

It is possible for a single sequence to have multiple URIs when the factory or trait has aliases. In these cases, the sequence will have an additional URI for each alias, or combination of aliases.

In this example, the same sequence can referenced in four different ways:

```ruby
factory :user, aliases: [:author] do
  trait :user_trait, aliases: [:author_trait] do
    sequence(:sequence) {|n| "author_trait_sequence_#{n}"}
  end
end

# generate(:user,   :user_trait,   :sequence)
# generate(:user,   :author_trait, :sequence)
# generate(:author, :user_trait,   :sequence)
# generate(:author, :author_trait, :sequence)
```

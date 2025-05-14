# Sequence URIs

There are many reasons to manipulate a specific sequence:

- generating a single value with: `generate`
- generating multiple values with: `generate_list`
- setting it to a new value with `FactoryBot.set_sequence`
- rewinding it with: `rewind_sequence`

To accomplish this we need to be able to reference the desired sequence. This is achieved with its unique URI.

## URI Composition

Each URI is composed of up to three names:

| position | name           | required                                                             |
| :------: | -------------- | -------------------------------------------------------------------- |
|    1.    | factory name:  | **if** - the sequence is defined within a Factory or a Factory Trait |
|    2.    | trait name:    | **if** - the sequence is defined within a Trait                      |
|    3.    | sequence name: | **always required**                                                  |

The URI can be entered as individual symbols:

```ruby
generate(:my_factory_name, :my_trait_name, :my_sequence_name)
```

**or** as individual strings:

```ruby
generate('my_factory_name', 'my_trait_name', 'my_sequence_name')
```

**or** as a single resource string:

```ruby
generate("my_factory_name/my_trait_name/my_sequence_name")
```

## Full URI example

This example details all the possible scenarios, with the comments showing the URI used to generate a value for each specific sequence:

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

## Multi URIs

It is possible for a single sequence to have multiple URIs.

If the factory or trait has aliases, the sequence will have an additional URI for each alias, or combination of aliases.

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

<div class='warning'>

## Important

- No matter how deeply nested, the factory name component of the URI is always the factory where the sequence is defined, not any parent factories.

- If a factory inherits a sequence, the URI must reference the factory where it was defined, not the one in which it is used.

</div>

---
type: note
created: 2025-11-07T16:24:57-06:00
updated: 2025-11-07T16:59:42-06:00
tags: []
aliases: []
---
# Setting the Current Value of a Sequence

When testing or working in the console, being able to set the sequence to a specific value, is incredibly helpful. This can be achieved by passing the [[Sequence URI]] and the new value to `FactoryBot.set_sequence`.

## Global Sequences

Global sequences are set with the sequence name and the new value:

```ruby
FactoryBot.define do
  sequence(:char, 'a') {|c| "global_character_#{c}" }
end

generate(:char) # "global_character_a"
FactoryBot.set_sequence(:char, 'z')
generate(:char) # "global_character_z"
```

## Factory Sequences

Factory sequences are set with the factory name, sequence name, and the new value:

```ruby
FactoryBot.define do
  factory :user do
    sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)
  end
end

generate(:user, :name) # "Jane"
FactoryBot.set_sequence(:user, :name, 'Jayde')
generate(:user, :name) # "Jayde"
```

## Factory Trait Sequences

Factory Trait sequences are set with the factory name, trait name, sequence name, and the new value:

```ruby
FactoryBot.define do
  factory :user do
    trait :with_email do
      sequence(:email) {|n| "user_#{n}@example.com" }
    end
  end
end

generate(:user, :with_email, :email) # "user_1@example.com"
FactoryBot.set_sequence(:user, :with_email, :email, 1_234_567)
generate(:user, :with_email, :email) # "user_1234567@example.com"
```
## Constraints on Setting the Current Value

When setting the current value of a sequence, it's important to be aware of the following constraints:

- The new value must match the sequence collection: You cannot pass a String to an Integer based sequence!
- An integer based sequence, such as a record ID, can accept any positive integer as the value.
- A fixed collection sequence can accept any value within the collection.

## Sequence Timeouts

- An unlimited sequence, such as a character `sequence(:unlimited,'a')` will timeout if not found within the default maximum search time of three seconds.
- The timeout can be configured with: `FactoryBot.sequence_setting_timeout = 1.5`
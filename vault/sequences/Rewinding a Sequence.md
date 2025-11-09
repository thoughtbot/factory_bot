---
type: note
created: 2025-11-07T15:59:36-06:00
updated: 2025-11-07T16:03:46-06:00
tags: []
aliases:
  - Rewinding Sequences
---
# Rewinding a Sequence

Sequences can be rewound and reset to their starting value:

## Rewinding All Sequences

Rewind all global and factory sequences with `FactoryBot.rewind_sequences`:

```ruby
FactoryBot.define do
  sequence(:email) {|n| "person#{n}@example.com" }

  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
  end
end

generate(:email) # "person1@example.com"
generate(:email) # "person2@example.com"
generate(:email) # "person3@example.com"

generate(:user, :email) # "user1@example.com"
generate(:user, :email) # "user2@example.com"
generate(:user, :email) # "user3@example.com"

FactoryBot.rewind_sequences

generate(:email)        # "person1@example.com"
generate(:user, :email) # "user1@example.com"
```

## Individual Sequences

An individual sequence can be rewound by passing the [[Sequence URI]] to `FactoryBot.rewind_sequence`:

```ruby
FactoryBot.define do
  sequence(:email) {|n| "global_email_#{n}@example.com" }

  factory :user do
    sequence(:email) {|n| "user_email_#{n}@example.com" }
  end
end

FactoryBot.rewind_sequence(:email)
generate(:email)
#=> "global_email_1@example.com"

factoryBot.rewind_sequence(:user, :email)
generate(:user, :email)
#=> "user_email_1@example.com"
```

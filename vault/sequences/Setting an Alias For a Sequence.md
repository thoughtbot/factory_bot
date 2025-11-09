---
type: note
created: 2025-11-07T15:24:02-06:00
updated: 2025-11-07T15:27:56-06:00
tags: []
aliases: []
---
# Setting an Alias For a Sequence

Sequences can be assigned aliases. When given an alias, the sequence and every one of it's aliases will share the same counter:

```ruby
factory :user do
  sequence(:email, 1000, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end

# will increase value counter for :email which is shared by :sender and :receiver
generate(:sender)
# => "person1@example.com"

generate(:email)
# => "person2@example.com"
```

## Providing a Default Value

Define aliases and use default value (1) for the counter

```ruby
factory :user do
  sequence(:email, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

Setting the value:

```ruby
factory :user do
  sequence(:email, 'a', aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

The value needs to support the `#next` method. Here the next value will be 'a',
then 'b', etc.


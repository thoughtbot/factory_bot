---
type: note
created: 2026-02-28T08:58:30-06:00
updated: 2026-02-28T08:59:12-06:00
tags: []
aliases: []
---
# Swapping Explicit Syntax for Implicit Syntax

### Original Code Using Explicit Syntax

The code sample below demonstrates the definition of a Factory using exclusively explicit syntax methods:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user, traits: [:admin] do
    add_attribute(:name) { "Lord Nikon" }
    add_attribute(:email) { generate(:email) }
    association :account
    association :org, factory: :organization

    trait :admin do
      add_attribute(:admin) { true }
    end
  end
end
```

### Rewritten Using Implicit Definition Syntax

Using the `method_missing` shorthand, however, can turn the explicit definition above into a more implicit definition:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user do
    name { "Lord Nikon" }      # no more `add_attribute`
    admin                      # no more :traits
    email                      # no more `add_attribute`
    account                    # no more `association`
    org factory: :organization # no more `association`

    trait :admin do
      admin { true }
    end
  end
end
```




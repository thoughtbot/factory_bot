---
type: note
created: 2025-11-07T19:29:17-06:00
updated: 2026-01-09T14:41:09-06:00
tags: []
aliases: []
up: "[[Callbacks]]"
---
# Trait Callbacks

To declare a callback for a specific trait, declare the callback within the `trait` block:

```ruby
factory :user do
  trait :with_password do
    after(:build) { |user| generate_hashed_password(user) }
  end
end
```

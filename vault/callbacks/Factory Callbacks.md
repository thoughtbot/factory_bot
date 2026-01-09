---
type: note
created: 2025-11-07T19:28:14-06:00
updated: 2026-01-09T14:19:35-06:00
tags: []
aliases: []
---
# Factory Callbacks

To declare a callback for a specific factory, declare the callback within the `factory` block:

```ruby
factory :user do
  after(:build) { |user| generate_hashed_password(user) }
end
```

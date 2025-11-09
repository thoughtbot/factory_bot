---
type: note
created: 2025-11-07T21:11:07-06:00
updated: 2025-11-07T21:30:48-06:00
tags: []
aliases: []
---
# Global Traits

**Global Traits** allow you to group attributes together and apply them to any factory as a mixin:

```ruby
FactoryBot.define do
  trait :timestamps do
    created_at { 8.days.ago }
    updated_at { 4.days.ago }
  end
  
  factory :user, traits: [:timestamps] do
    username { "john_doe" }
  end
  
  factory :post do
    timestamps
    title { "Traits rock" }
  end
end
```

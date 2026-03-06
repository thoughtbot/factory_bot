---
type: note
created: 2025-11-07T21:29:22-06:00
updated: 2026-02-28T09:48:58-06:00
tags: []
aliases: []
up: "[[§ Traits]]"
---
# Applying Traits Within Other Traits

Traits can be used within other traits to mix in their attributes.

```ruby
factory :order do
  trait :completed do
    completed_at { 3.days.ago }
  end

  trait :refunded do
    completed
    refunded_at { 1.day.ago }
  end
end
```

---
type: note
created: 2025-11-07T15:16:14-06:00
updated: 2026-01-09T14:43:26-06:00
tags: []
aliases: []
up: [[Sequences]]
---
# Using Sequences Within Attributes

Sequences can be used in dynamic attributes:

```ruby
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

factory :invite do
  invitee { generate(:email) }
end
```

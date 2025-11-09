---
type: note
created: 2025-11-07T19:25:28-06:00
updated: 2025-11-07T19:26:04-06:00
tags: []
aliases: []
---
# Global Callbacks

To set callbacks for all factories, declare them within the `FactoryBot.define` block:

```ruby
FactoryBot.define do
  after(:build) { |object| puts "Built #{object}" }
  after(:create) { |object| AuditLog.create(attrs: object.attributes) }

  factory :user do
    name { "John Doe" }
  end
end
```

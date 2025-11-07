---
type: note
created: 2025-08-29T17:38:44-05:00
updated: 2025-08-29T17:55:33-05:00
tags: []
aliases: []
---
# Attributes

As was briefly mentioned in the [[Define a Factory]] guide. Every factory has a name and a set of attributes:

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

- [[Dynamic Attributes]]
- [[Static Attributes (DEPRECATED)]]
- [[Hash Attributes]]
- [[Transient Attributes]]


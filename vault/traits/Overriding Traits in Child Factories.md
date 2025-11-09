---
type: note
created: 2025-11-07T21:24:22-06:00
updated: 2025-11-07T21:25:02-06:00
tags: []
aliases: []
---
# Overriding Traits in Child Factories

You can override individual attributes granted by a trait in a child factory:

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    name { "John Doe" }
    status { :active }
    login { "#{name} (M)" }
  end

  factory :brandon do
    active
    name { "Brandon" }
  end
end
```

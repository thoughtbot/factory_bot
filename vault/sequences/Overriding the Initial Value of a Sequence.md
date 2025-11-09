---
type: note
created: 2025-11-07T16:18:24-06:00
updated: 2025-11-07T16:22:22-06:00
tags: []
aliases: []
---
# Overriding the Initial Value of a Sequence

The initial value of a sequence can be overridden with any value that responds to `#next` (e.g. 1, 2, 3, 'a', 'b', 'c').
## Static Override

To override the initial value with a static value, pass it in as the second argument:

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

## Lazy Override

The initial value can also be lazily set by passing a **Proc** as the value. This Proc will be called the first time the `sequence.next` is called.

```ruby
factory :user do
  sequence(:email, proc { Person.count + 1 }) do |n| 
    "person#{n}@example.com"
  end
end
```

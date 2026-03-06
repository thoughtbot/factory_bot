---
type: note
created: 2025-11-08T21:11:52-06:00
updated: 2026-01-09T15:01:37-06:00
tags: []
aliases:
  - Child Factories
  - Child Factory
up: "[[§ Factories]]"
---
# Child Factories

A **child factory** can be defined using either implicit or explicit syntax

- **implicit** – nesting `factory` blocks
- **explicit** – assignment of a parent via the `parent` factory option 

## Nested Factories

A **Child Factory** can be declared by nesting the declaration of the child factory inside the parent factory.

use `factory` inside a `factory` block to define a new factory with an implied parent:

```ruby
factory :post do
  title { "A title" }

  factory :approved_post do
    approved { true }
  end
end

approved_post = create(:approved_post)
approved_post.title    # => "A title"
approved_post.approved # => true
```

## Explicit Assignment of Parent Factory

A child factory can also be defined through explicit assignment of the parent factory to the child factory.

Here's an example of assigning a parent explicitly:

```ruby
factory :post do
  title { "A title" }
end

factory :approved_post, parent: :post do
  approved { true }
end
```

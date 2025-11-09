---
type: note
created: 2025-11-07T22:15:49-06:00
updated: 2025-11-07T22:23:15-06:00
tags: []
aliases: []
---
# Specifying the Factory on Associations

When declaring associations, you can specify a different factory

> [!NOTE] Note
> [[Factory Name Aliases]] might also help out here

## Example: Implicit Association Syntax

```ruby
factory :post do
  # ...
  author factory: :user
end
```

## Example: Explicit Association Syntax

```ruby
factory :post do
  # ...
  association :author, factory: :user
end
```

## Example: Inline Association Syntax

```ruby
factory :post do
  # ...
  author { association :user }
end
```

---
type: note
created: 2025-11-07T22:15:49-06:00
updated: 2026-01-09T14:39:01-06:00
tags: []
aliases: []
up: "[[§ Associations]]"
---
# Specifying the Factory on Associations

When declaring associations, you can specify a different factory

> [!NOTE] Note
> [[Defining Factory Name Aliases]] might also help out here

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

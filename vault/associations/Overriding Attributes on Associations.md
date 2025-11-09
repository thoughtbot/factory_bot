---
type: note
created: 2025-11-07T21:58:07-06:00
updated: 2025-11-07T21:58:16-06:00
tags: []
aliases: []
---
# Overriding Attributes on Associations

You can also override attributes on associations.

## Override Attributes on an Implicit Association

```ruby
factory :post do
  # ...
  author factory: :author, last_name: "Writely"
end
```

## Override Attributes on an Explicit Association

```ruby
factory :post do
  # ...
  association :author, last_name: "Writely"
end
```

## Inlining Attributes From the Current Factory

Attributes from the current factory can be passed through to the association:

```rb
factory :post do
  # ...
  author_last_name { "Writely" }
  author { association :author, last_name: author_last_name }
end
```


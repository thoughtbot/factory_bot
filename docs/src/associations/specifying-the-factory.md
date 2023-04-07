# Specifying the factory

You can specify a different factory (although [Aliases](../aliases/summary.md)
might also help you out here).

Implicitly:

```ruby
factory :post do
  # ...
  author factory: :user
end
```

Explicitly:

```ruby
factory :post do
  # ...
  association :author, factory: :user
end
```

Inline:

```ruby
factory :post do
  # ...
  author { association :user }
end
```

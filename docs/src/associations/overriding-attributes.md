# Overriding attributes

You can also override attributes on associations.

Implicitly:

```ruby
factory :post do
  # ...
  author factory: :author, last_name: "Writely"
end
```

Explicitly:


```ruby
factory :post do
  # ...
  association :author, last_name: "Writely"
end
```

Or inline using attributes from the factory:

```rb
factory :post do
  # ...
  author_last_name { "Writely" }
  author { association :author, last_name: author_last_name }
end
```

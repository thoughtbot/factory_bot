# Inline definition

You can also define associations inline within regular attributes, but note
that the value will be `nil` when using the `attributes_for` strategy.

```ruby
factory :post do
  # ...
  author { association :author }
end
```

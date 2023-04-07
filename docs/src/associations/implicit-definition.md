# Implicit definition

It's possible to set up associations within factories. If the factory name is
the same as the association name, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```

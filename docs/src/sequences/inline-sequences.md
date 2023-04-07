# Inline sequences

And it's also possible to define an in-line sequence that is only used in
a particular factory:

```ruby
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end
```

# Initial value

You can override the initial value. Any value that responds to the `#next`
method will work (e.g. 1, 2, 3, 'a', 'b', 'c')

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

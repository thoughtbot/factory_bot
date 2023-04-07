# As implicit attributes

Or as implicit attributes:

```ruby
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

factory :user do
  email # Same as `email { generate(:email) }`
end
```

Note that defining sequences as implicit attributes will not work if you have a
factory with the same name as the sequence.

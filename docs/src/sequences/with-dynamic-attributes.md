# With dynamic attributes

Sequences can be used in dynamic attributes:

```ruby
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

factory :invite do
  invitee { generate(:email) }
end
```

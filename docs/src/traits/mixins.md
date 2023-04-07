# As mixins

Traits can be defined outside of factories and used as mixins to compose shared
attributes:

```ruby
FactoryBot.define do
  trait :timestamps do
    created_at { 8.days.ago }
    updated_at { 4.days.ago }
  end
  
  factory :user, traits: [:timestamps] do
    username { "john_doe" }
  end
  
  factory :post do
    timestamps
    title { "Traits rock" }
  end
end
```

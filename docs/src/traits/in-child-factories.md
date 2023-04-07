# In child factories

You can override individual attributes granted by a trait in a child factory:

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    name { "John Doe" }
    status { :active }
    login { "#{name} (M)" }
  end

  factory :brandon do
    active
    name { "Brandon" }
  end
end
```

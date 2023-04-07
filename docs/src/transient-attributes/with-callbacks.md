# With callbacks

If you need to access the evaluator in a factory\_bot callback,
you'll need to declare a second block argument (for the evaluator) and access
transient attributes from there.

```ruby
factory :user do
  transient do
    upcased { false }
  end

  name { "John Doe" }

  after(:create) do |user, evaluator|
    user.name.upcase! if evaluator.upcased
  end
end

create(:user).name
#=> "John Doe"

create(:user, upcased: true).name
#=> "JOHN DOE"
```

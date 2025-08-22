# With other attributes

You can access transient attributes within other attributes (see [Dependent
Attributes](../dependent-attributes/summary.md)):

```ruby
factory :user do
  transient do
    rockstar { true }
  end

  name { "John Doe#{" - Rockstar" if rockstar}" }
end

create(:user).name
#=> "John Doe - ROCKSTAR"

create(:user, rockstar: false).name
#=> "John Doe"
```

# Factory name and attributes

Each factory has a name and a set of attributes. The name is used to guess the
class of the object by default:

```ruby
# This will guess the User class
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

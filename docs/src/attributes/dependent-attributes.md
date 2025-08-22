# Dependent Attributes

Attributes can be based on the values of other attributes using the context
that is yielded to dynamic attribute blocks:

```ruby
factory :user do
  first_name { "Joe" }
  last_name  { "Blow" }
  email { "#{first_name}.#{last_name}@example.com".downcase }
end

create(:user, last_name: "Doe").email
# => "joe.doe@example.com"
```

# Defining factories

Factories are defined by invoking the `factory` DSL inside the scope of a block passed into `FactoryBot.define`:

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

The example above demonstrates how each factory should be defined with a name and a set of attributes. The name given to the factory will be used to guess the class of the object by default.
# add_attribute

Within a factory definition, the `add_attribute` method defines a key/value
pair that will be set when the object is built.

The `add_attribute` method takes two arguments: a name (Symbol or String) and a
block. This block is called each time this object is constructed. The block is
not called when the attribute is overriden by a build strategy.

Assignment is done by calling the Ruby attribute setter. For example, given

```ruby
FactoryBot.define do
  factory :user do
    add_attribute(:name) { "Acid Burn" }
  end
end
```

This will use the `#name=` setter:

```ruby
user = User.new
user.name = "Acid Burn"
```

Also see [method_missing](method_missing.html) for a shorthand.

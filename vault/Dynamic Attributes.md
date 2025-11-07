---
type: note
created: 2025-08-29T17:47:14-05:00
updated: 2025-08-29T18:18:46-05:00
tags: []
aliases: []
---
# Dynamic Attributes

Declaring attributes dynamically is the primary means of adding attributes to a factory definition. 

To declare a dynamic attribute, pass a block of code into the name of the attribute:

```ruby
factory :robot do
  name { "Ralph" }
end
```

That's really about it! There are some caveats that we'll get into, but every time the `:robot` factory constructs an object, the block passed into `name` will be called and the return value assigned to the constructed object.

## The `add_attribute` Method

To break down how this works, let's take a look at the `add_attribute` DSL. This is is the long-form and more explicit mechanism by which one can declare a dynamic attribute. Within a factory definition, the `add_attribute` method defines a key/value pair that will be used to set a property on the object when constructed.

The `add_attribute` method takes two arguments: a name (Symbol or String) and a block. The name is a property that can be set on the constructed object. The block is called each time an object is constructed. The block will not, however, be called when the attribute is overriden by a build strategy.

When a factory constructs an object, assignment of the attribute is done by calling the Ruby attribute setter. For example, given the following factory:

```ruby
FactoryBot.define do
  factory :user do
    add_attribute(:name) { "Acid Burn" }
  end
end
```

You can then construct a user and access it's name property:

```ruby
user = create(:user)
puts user.name
#=> Acid Burn
```

This worked because when the factory constructed the user,  the `name` property was set to the value of `"Acid Burn"`.  This is equivalent to using the `#name=` setter:

```ruby
user = User.new
user.name = "Acid Burn"
```

## The `method_missing` Shorthand

This is where the magic happens....  

TODO — import the `method_missing` document from the other directory

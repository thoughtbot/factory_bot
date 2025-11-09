---
type: note
created: 2025-11-08T16:51:29-06:00
updated: 2025-11-08T21:26:16-06:00
tags: []
aliases: []
---
# Explicit Attributes

An **Explicit Attribute** is an [[§ attributes|Attribute]] that is declared using the `add_attribute` method. 

## The `add_attribute` Method

Within a factory definition, the `add_attribute` method defines a key-value pair that will be used to set a property on the object when constructed. 

The method takes two arguments: 

- A **name** which is a property that can be set on the constructed object. 
- A **block** to be called each time an object is constructed. 

## Example: Explicit Attribute Definition

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

The code above worked because when the factory constructed the user,  the `name` property was set to the value of `"Acid Burn"`.  This is equivalent to using the `#name=` setter:

```ruby
# Equivalent Behavior
user = User.new
user.name = "Acid Burn"
```

## Notes

- the `name` of an attribute should be represented as a Symbol or String.
- The attribute's block will not be called when the attribute is overriden by a [[§ strategies|Construction Strategy]].
- [[Implicit Attributes]] are declared using a shorthand syntax that takes advantage of Ruby's `method_missing` functionality.
- All **Explicit Attributes** are also [[Dynamic Attributes]] and should be passed a Ruby block.
- In older version of FactoryBot, an **Explicit Attribute** could also be a [[Static Attributes|Static Attribute]], but this functionality was removed.
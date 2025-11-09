---
type: note
created: 2025-08-29T17:47:14-05:00
updated: 2025-11-08T17:42:46-06:00
tags: []
aliases:
  - Dynamic Attribute
  - Dynamic Attributes
up: "[[§ attributes|Attributes]]"
---
# Dynamic Attributes

A **Dynamic Attribute** is declared by passing a block into any attribute syntax. Dynamic Attributes are also the primary means of adding attributes to a factory definition. 

## Example: Basic Dynamic Attribute

To declare a dynamic attribute, pass a block of code into the name of the attribute:

```ruby
factory :robot do
  name { "Ralph" }
end
```

That's really about it! There are some caveats that we'll get into, but every time the `:robot` factory constructs an object, the block passed into `name` will be called and the return value assigned to the constructed object.

To break down how this works, take a look at the `add_attribute` DSL that's documented in the [[Explicit Attributes]] page. Using `add_attribute` is is the long-form and more explicit mechanism by which one can declare a dynamic attribute. 
## Notes

- The example above also demonstrates the [[Implicit Attributes]] syntax.
- **Dynamic Attributes** can also be constructed with the [[Explicit Attributes]] syntax using the `add_attribute` method.

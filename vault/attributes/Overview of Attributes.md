---
type: note
created: 2025-08-29T17:38:44-05:00
updated: 2025-11-08T19:24:50-06:00
tags: []
aliases:
up: "[[§ attributes|Attributes]]"
---
# Overview of Attributes

As was briefly mentioned in the [[Defining Factories]] guide. Every factory must be given a name and a set of attributes:

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

What you may not yet know is that the example above demonstrates declaring attributes using the default **dynamic** and **implicit** syntax. The content below delves further into what this means.

## Implicit Versus Explicit Declaration Syntax

Factory attributes can be declared using either an implicit or explicit declaration syntax. 

### Attribute Declaration Using Explicit Syntax

An **explicit attribute** is declared by invoking the `add_attribute` method and passing a name and block as arguments. This will explicitly pair the provided attribute name with the block.

This can be seen in the example below:

```ruby
factory :robot do
  add_attribute(:name) { "Ralph" }
end
```

this factory can then be run:

```ruby
FactoryBot.build(:user)
```

In the code above, the product produced by the factory is an instance of the class `User` which has had `"Ralph"` assigned to it's `name` field.

To learn more, read about [[Explicit Attributes]]. 

Note, however, that the explicit syntax is generally only used when [[Handling Conflicts Between Attributes And Reserved Words Or Existing Methods]]. In most other cases, the implicit syntax is the default and preferred syntax.

### Attribute Declaration Using Implicit Syntax

Declaring an **implicit attribute** uses a shorthand syntax which permits developers to act as if the DSL already contains a method matching the name of the attribute you wish to declare. Invoking this [[Unknown Methods|Unknown Method]], and passing it a Ruby block as an argument, will implicitly declare an attribute.

To demonstrate how this works, refer to the example below which is functionally equivalent to the `add_attribute` example provided in the previous section:

```ruby
factory :robot do
  name { "Ralph" }
end
```

For now, it is sufficient to understand that FactoryBot interprets `name`  as the name of the attribute, and stores the provided block for later use when evaluating the attribute. 

If you'd like to dive deeper into how this works, refer to [[Implicit Attributes]] and [[Unknown Methods]] to learn more.

## Dynamic Versus Static Attributes

FactoryBot today requires that you declare attributes using the dynamic syntax.  A [[Dynamic Attributes|Dynamic Attribute]] is declared by passing a block of code into the definition of an attribute. 

The code below demonstrates the dynamic attribute syntax:

```ruby
factory :robot do
  name { "Ralph" }
end  
```

What this means in practice, is that the provided block is called every time the factory runs. In the example above, for instance, every product constructed by the `:robot` factory will reference a unique String instance containing the value `"Reference"`.

```ruby
robot_a = build(:robot)
robot_b = build(:robot)
robot_a.name.equal?(robot_b.name) # => false
```

In earlier versions of FactoryBot, it was possible to declare an attribute using a static syntax. A [[Static Attributes|Static Attribute]] was declared without the use of a block. This presented a common source of confusion as multiple objects produced by the same factory would reference the same instance of the static attribute value.

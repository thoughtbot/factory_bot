---
type: note
created: 2025-08-29T17:38:44-05:00
updated: 2026-03-06T15:39:11-06:00
tags:
  - attributes
aliases:
  - Attribute
  - Attributes
up: "[[§ Attributes]]"
---
# Attributes

An **attribute** pairs the *name* of an object property with a *block* which evaluates to the value of the attribute.

## Syntax

As was briefly mentioned in the [[Factories]] guide. Every factory must be given a name and a set of attributes:

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

What you may not yet know is that the example above demonstrates declaring attributes using the default **implicit** syntax. Factory attributes can also declared using an explicit declaration syntax.

### Attribute Declaration Using Explicit Syntax

An **explicit attribute** is declared by invoking the `add_attribute` method and passing a name and block as arguments. This will explicitly pair the provided attribute name with the block. This can be seen in the example below:

```ruby
factory :robot do
  add_attribute(:name) { "Ralph" }
end
```

This `:robot` factory can then be run to build an unsaved object:

```ruby
FactoryBot.build(:robot)
```

The object constructed by the factory is an instance of the class `Robot` and has had `"Ralph"` assigned to it's `name` field.

To learn more, read about [[Explicit Attributes]].

> [!NOTE]
> The explicit syntax is generally only used when [[Handling Conflicts Between Attributes And Reserved Words Or Existing Methods]]. In most other cases, the implicit syntax is the default and preferred syntax.

### Attribute Declaration Using Implicit Syntax

Declaring an **implicit attribute** uses a shorthand syntax which permits developers to act as if the DSL already contains a method matching the name of the attribute you wish to declare. Invoking this [[Missing Method Shorthand Syntax|Unknown Method]], and passing it a Ruby block as an argument, will implicitly declare an attribute.

To demonstrate how this works, refer to the example below which is functionally equivalent to the `add_attribute` example provided in the previous section:

```ruby
factory :robot do
  name { "Ralph" }
end
```

For now, it is sufficient to understand that FactoryBot interprets `name`  as the name of the attribute, and stores the provided block for later use when evaluating the attribute.

If you'd like to dive deeper into how this works, refer to [[Implicit Attributes]] and [[Missing Method Shorthand Syntax]] to learn more.

## Dynamic Attributes

FactoryBot requires that you declare attributes using dynamic syntax. A [[Dynamic Attributes|Dynamic Attribute]] is declared by passing a block of code into the definition of an attribute.

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

## Static Attributes Have Been Removed From FactoryBot

In earlier versions of FactoryBot, it was possible to declare an attribute using a static syntax. A [[Static Attributes|Static Attribute]] was declared without the use of a block. This presented a common source of confusion as multiple objects produced by the same factory would reference the same instance of the static attribute value.

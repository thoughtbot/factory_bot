---
type: note
created: 2025-11-07T21:58:36-06:00
updated: 2026-03-06T14:04:02-06:00
tags:
  - associations
aliases:
  - Association
  - Associations
up: "[[§ Associations]]"
---
# Associations

An **Association** is defined on a [[§ Factories|Factory]] in order that an associated object be constructed at the same time and linked to the factory's constructed object via an attribute.

## Associations Setup Relationships Between Factories

FactoryBot's Associations are modeled after Rail's ActiveRecord `belongs_to` association. A factory\_bot association binds a name with another factory which will be used to construct the associated object. FactoryBot will then link the associated object with the object constructed by the original factory by assigning an attribute on that object.

## Association Declaration Syntax

An association can be declared using implicit, explicit, or inline syntax.

### Implicit Association Syntax

[[Implicit Associations]] are declared using [[Implicit Syntax]]. When the factory name matches the name of the associated object, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```

### Explicit Association Syntax

[[Explicit Associations]] are declared using the `association` method.

```ruby
factory :post do
  # ...
  association :author
end
```

An explicit association can be declared when the association name and factory name are different:

```ruby
factory :post do
  # ...
  association :author, factory: :user
end
```

### Inline Association Syntax

[[Inline Associations]] are declared using regular attributes and the invoking the `association`  method within the block. Note, however, that the value of the attribute will be `nil` when using the `attributes_for` strategy.

```ruby
factory :post do
  # ...
  author { association :author }
end
```

---
type: note
created: 2025-11-07T21:58:36-06:00
updated: 2025-11-08T20:06:33-06:00
tags: []
aliases: []
---
# Overview of Associations

An **Association** is defined on a factory in order that an associated object be constructed at the same time and linked to the factory's constructed object via an attribute.

FactoryBot's Associations are modeled after Rail's ActiveRecord `belongs_to` association. The FactoryBot association binds a name with another factory which will be used to construct the associated object. FactoryBot will then link the associated object with the object constructed by the original factory by assigning an attribute on that object.

An association can be declared using implicit, explicit, or inline syntax.

## Implicit Association Syntax

It's possible to set up associations within factories. If the factory name is the same as the association name, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```

See [[Implicit Associations]] for more information
## Explicit Association Syntax

You can define associations explicitly using the `association` method:

```ruby
factory :post do
  # ...
  association :author
end
```

See [[Explicit Associations]] for more information

## Inline Associations

You can also define associations inline within regular attributes, but note that the value will be `nil` when using the `attributes_for` strategy.

```ruby
factory :post do
  # ...
  author { association :author }
end
```

See [[Inline Associations]] for more information

---
type: note
created: 2025-08-29T15:00:15-05:00
updated: 2025-11-08T21:29:40-06:00
tags: []
aliases:
  - Defining a factory
  - Define a factory
---
# Defining Factories

Factories are defined by invoking the `factory` DSL inside the scope of a block passed into `FactoryBot.define`. Each factory must be given a name and a set of attributes. The factory's name is used to guess the class of the object by default. The set of attributes will be assigned to the product that is produced, or constructed, by the factory at runtime.

Here's an example:

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

The example above demonstrates how each factory should be defined with a name and a set of attributes. The factory is given a name of `:user`, and this will be used to guess the class of the object by default. When the factory is run, an instance of the class `User` will be constructed and then assigned the attributes of `first_name`, `last_name`, and `admin`. 

See [[§ factories|Factories]] to explore more about how defining factories work within FactoryBot. Some useful pages to start with are listed below:

- [[Factory Naming Conventions]]
- [[Factory Definition File Paths]]
- [[Explicit Specification of the Factory's Class]]
- [[Factory Best Practices]]

Next we will explore how [[Loading Factories]] works.
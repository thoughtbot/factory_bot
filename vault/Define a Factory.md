---
type: note
created: 2025-08-29T15:00:15-05:00
updated: 2025-08-29T17:37:48-05:00
tags: []
aliases:
  - Defining a factory
  - Define a factory
---
# Define a Factory

Factories are defined by invoking the `factory` DSL inside the scope of a block passed into `FactoryBot.define`. Each factory has a name and a set of attributes. The name is used to guess the class of the object by default. 

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

## Factory Naming Conventions

The factory naming convention is to convert the name of the class into snake case in all lowercase characters. A factory with the name `:mailing_address`, for example, will construct objects that are an instance of the `MailingAddress` class. Given a class `UserRelationship`, the convention is to give the factory the name `:user_relationship`.

## Definition File Paths

Factories can be defined anywhere, but will be automatically loaded after calling `FactoryBot.find_definitions` if factories are defined in files at the following locations:

```text
factories.rb
factories/**/*.rb
test/factories.rb
test/factories/**/*.rb
spec/factories.rb
spec/factories/**/*.rb
```

Note: The list above also illustrates the default load order of factories. FactoryBot will first load the factories file, followed by the factories directory, and so on.
## Explicit Specification of the Class

In situations where you need to override the naming conventions, it is possible to explicitly specify the class. A factory definition can explicitly configure the class to be constructed by including a `class` keyword argument:

```ruby
factory :admin, class: "User"
```

In the example above, the factory will now use the `User` class when constructing objects. Without the inclusion of `class`, this admin factory would have otherwise used the `Admin` class.

It is also permissible to pass in a constant as well, if the constant is available. It's important to note, however, that this can cause test performance problems in large Rails applications, a
referring to the constant will cause it to be eagerly loaded.

```ruby
factory :access_token, class: User
```

## Constraints To Be Aware Of

- Multiple factories cannot be given the same name. Attempts to do so will raise an error.
## Best Practices

- It is recommended to define one factory for each class which provides the simplest set of attributes necessary to create an instance of that class.
- When creating ActiveRecord objects, only provide attributes that are required through validations and that do not have defaults.
- Additional factories can be created through inheritance to cover common scenarios for each class.
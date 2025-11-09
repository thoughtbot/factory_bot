---
type: note
created: 2025-11-08T18:39:22-06:00
updated: 2025-11-08T18:39:34-06:00
tags: []
aliases: []
---
# Explicit Specification of the Factory's Class

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

---
type: note
created: 2025-11-07T18:46:48-06:00
updated: 2025-11-07T18:51:29-06:00
tags: []
aliases:
  - Overriding Attributes
---
# Attribute Overrides

## Overriding An Attribute

No matter which strategy is used, it's possible to override defined attributes by passing a hash along when invoking the strategy's syntax methods.

```ruby
user = build(:user, first_name: "Joe")
user.first_name
# => "Joe"
```

The example above builds a `User` instance and overrides the `first_name` property.

## Ruby 3.1 And Omitting Values From Hash Literals

Ruby 3.1's support for [omitting values][] from `Hash` literals dovetails with attribute overrides and provides an opportunity to limit the repetition of variable names:

```ruby
first_name = "Joe"
user = build(:user, first_name:)
user.first_name
# => "Joe"
```

The example above still builds a `User` instance and overrides the `first_name` property, but it does so using the new syntax available in Ruby 3.1.

[omitting values]: https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals

# Attribute overrides

No matter which strategy is used, it's possible to override the defined
attributes by passing a hash:

```ruby
# Build a User instance and override the first_name property
user = build(:user, first_name: "Joe")
user.first_name
# => "Joe"
```

Ruby 3.1's support for [omitting values][] from `Hash` literals dovetails with
attribute overrides and provides an opportunity to limit the repetition of
variable names:

```ruby
first_name = "Joe"

# Build a User instance and override the first_name property
user = build(:user, first_name:)
user.first_name
# => "Joe"
```

[omitting values]: https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals

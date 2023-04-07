# Attribute overrides

No matter which strategy is used, it's possible to override the defined
attributes by passing a hash:

```ruby
# Build a User instance and override the first_name property
user = build(:user, first_name: "Joe")
user.first_name
# => "Joe"
```

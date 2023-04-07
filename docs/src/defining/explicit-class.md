# Specifying the class explicitly

It is also possible to explicitly specify the class:

```ruby
# This will use the User class (otherwise Admin would have been guessed)
factory :admin, class: "User"
```

You can pass a constant as well, if the constant is available (note that this
can cause test performance problems in large Rails applications, since
referring to the constant will cause it to be eagerly loaded).

```ruby
factory :access_token, class: User
```

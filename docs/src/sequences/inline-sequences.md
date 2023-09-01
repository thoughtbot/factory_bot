# Inline sequences

And it's also possible to define an in-line sequence that is only used in
a particular factory:

```ruby
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end
```

With Ruby 2.7's support for [numbered parameters][], inline definitions can be
even more abbreviated:

```ruby
factory :user do
  sequence(:email) { "person#{_1}@example.com" }
end
```

[numbered parameters]: https://ruby-doc.org/core-2.7.1/Proc.html#class-Proc-label-Numbered+parameters

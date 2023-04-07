# Aliases

Sequences can also have aliases. The sequence aliases share the same counter:

```ruby
factory :user do
  sequence(:email, 1000, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end

# will increase value counter for :email which is shared by :sender and :receiver
generate(:sender)
```

Define aliases and use default value (1) for the counter

```ruby
factory :user do
  sequence(:email, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

Setting the value:

```ruby
factory :user do
  sequence(:email, 'a', aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

The value needs to support the `#next` method. Here the next value will be 'a',
then 'b', etc.

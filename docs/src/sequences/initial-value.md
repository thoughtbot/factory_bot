# Initial value

You can override the initial value. Any value that responds to the `#next`
method will work (e.g. 1, 2, 3, 'a', 'b', 'c')

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

The initial value can also be lazily set by passing a Proc object via the `lazy` option. This Proc will be called the first time the `sequence.next` is called.

```ruby
factory :user do
  sequence(:email, lazy: -> { Person.count }) { |n| "person#{n}@example.com" }
end
```

If an initial value is supplied both as an argument and with lazy, then the lazy proc will be used.

```ruby
sequence(:item), 12, lazy: -> { "A" })

generate(:item) # "A"
```

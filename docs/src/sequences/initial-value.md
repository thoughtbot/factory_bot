# Initial value

You can override the initial value. Any value that responds to the `#next`
method will work (e.g. 1, 2, 3, 'a', 'b', 'c')

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

The initial value can also be lazily set by passing a Proc as the value. This Proc will be called the first time the `sequence.next` is called.

```ruby
factory :user do
  sequence(:email, proc { Person.count + 1 }) { |n| "person#{n}@example.com" }
end
```

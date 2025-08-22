# Hash attributes

Because of the block syntax in Ruby, defining attributes as `Hash`es (for
serialized/JSON columns, for example) requires two sets of curly brackets:

```ruby
factory :program do
  configuration { { auto_resolve: false, auto_define: true } }
end
```

Alternatively you may prefer `do`/`end` syntax:

```ruby
factory :program do
  configuration do
    { auto_resolve: false, auto_define: true }
  end
end
```

---

However, defining a value as a hash makes it complicated to set values within
the hash when constructing an object. Instead, prefer to use factory\_bot
itself:

```ruby
factory :program do
  configuration { attributes_for(:configuration) }
end

factory :configuration do
  auto_resolve { false }
  auto_define { true }
end
```

This way you can more easily set value when building:

```ruby
create(
  :program,
  configuration: attributes_for(
    :configuration,
    auto_resolve: true,
  )
)
```

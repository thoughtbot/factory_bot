---
type: note
created: 2025-11-07T10:51:59-06:00
updated: 2025-11-07T18:45:45-06:00
tags: []
aliases: []
---
# Hash Attributes

## Introduction to Hash Attributes

Because of the block syntax in Ruby, defining attributes as hashes (for serialized/JSON columns, for example) requires two sets of curly brackets:

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

## Nested Hash Attributes

However, defining a value as a hash makes it complicated to set values within the hash when constructing an object. Instead, prefer to use factory\_bot itself:

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

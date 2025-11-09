---
type: note
created: 2025-11-07T22:03:32-06:00
updated: 2025-11-08T21:21:28-06:00
tags: []
aliases: []
---
# Associations and Strategies

Associations default to using the same construction strategy as their parent object:

```ruby
FactoryBot.define do
  factory :author

  factory :post do
    author
  end
end

post = build(:post)
post.new_record?        # => true
post.author.new_record? # => true

post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false
```

## Enabling the Old Default Behavior

This is different than the default behavior for previous versions of factory\_bot, where the association strategy would not always match the strategy of the parent object. In order to continue using the old behavior, the `use_parent_strategy` configuration option must be set to `false`:

```ruby
FactoryBot.use_parent_strategy = false
```

### Defaults to Create Strategy

By default, when `use_parent_strategy` is disabled, FactoryBot will use the [[create Strategy|create]] strategy to construct associated objects:

```ruby
# Builds and saves a User and a Post
post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false

# Builds and saves a User, and then builds but does not save a Post
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => false
```

### Customizing the Strategy

When `use_parent_strategy` is disabled, to customize the strategy (and not save the associated object) specify `strategy: :build` when declaring the association:

```ruby
FactoryBot.use_parent_strategy = false

factory :post do
  # ...
  association :author, factory: :user, strategy: :build
end

# Builds a User, and then builds a Post, but does not save either
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => true
```

Note that the `strategy: :build` option must be passed to an explicit call to
`association`, and cannot be used with implicit associations:

```ruby
factory :post do
  # ...
  author strategy: :build # <<< this does *not* work
                          # causes author_id to be nil
end
```

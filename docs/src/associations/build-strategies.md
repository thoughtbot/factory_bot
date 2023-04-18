# Build strategies

Associations default to using the same build strategy as their parent object:

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

This is different than the default behavior for previous versions of
factory\_bot, where the association strategy would not always match the strategy
of the parent object. If you want to continue using the old behavior, you can
set the `use_parent_strategy` configuration option to `false`.

```ruby
FactoryBot.use_parent_strategy = false

# Builds and saves a User and a Post
post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false

# Builds and saves a User, and then builds but does not save a Post
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => false
```

To not save the associated object, specify `strategy: :build` in the factory:

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
  author strategy: :build    # <<< this does *not* work; causes author_id to be nil
```

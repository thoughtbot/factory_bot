---
type: note
created: 2025-11-07T22:23:55-06:00
updated: 2025-11-08T19:52:27-06:00
tags: []
aliases: []
---
# Association Overrides

[[Attribute Overrides]] can also be used to link associated objects.

When invoking one of the [[§ strategies|Construction Strategies]], pass in a key-value pair where the key matches the name of one of the factory's associations and where the value is the associated object you wish to use:

```ruby
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    author
  end
end

# build an associated object
eunji = build(:author, name: 'Eunji')

# pass it in as an override:
post = build(:post, author: eunji)
```

## Identifier Method Overrides

When using FactoryBot with Rail's ActiveRecord models, you can also override an `belongs_to` association by setting the attribute for the foreign key:

```ruby
# create an associated object
eunji = create(:author, name: 'Eunji')

# pass it in as an override:
post = create(:post, author_id: eunji.id)
```

## Ruby 3.1

Ruby 3.1's support for [omitting values][] from `Hash` literals dovetails with attribute overrides, and provides an opportunity to limit the repetition of variable names:

```ruby
author = build(:author, name: 'Eunji')
post = build(:post, author:)
```

[omitting values]: https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals


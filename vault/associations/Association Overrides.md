---
type: note
created: 2025-11-07T22:23:55-06:00
updated: 2026-03-06T12:28:59-06:00
tags: []
aliases:
  - Overrides
up: "[[§ Associations]]"
features:
  - "[[Associations]]"
  - "[[§ Attributes]]"
  - "[[Attribute Overrides]]"
---
# Association Overrides

[[Attribute Overrides]] can also be used to link associated objects.

When invoking one of the [[Strategies|Construction Strategies]], pass in a key-value pair where the key matches the name of one of the factory's associations and where the value is the associated object you wish to use:

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

## Overriding Identifier Methods

When using FactoryBot with Rail's ActiveRecord models, you can also override an `belongs_to` association by setting the attribute for the foreign key:

```ruby
# create an associated object
eunji = create(:author, name: 'Eunji')

# pass it in as an override:
post = create(:post, author_id: eunji.id)
```

## Omitting Hash Values With Attribute Overrides

Ruby 3.1 added support for [omitting values](https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals) from `Hash` literals and this dovetails with attribute overrides, and provides an opportunity to limit the repetition of variable names:

```ruby
author = build(:author, name: 'Eunji')
post = build(:post, author:)
```

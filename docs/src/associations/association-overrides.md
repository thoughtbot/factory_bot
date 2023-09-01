# Association overrides

Attribute overrides can be used to link associated objects:

```ruby
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    author
  end
end

eunji = build(:author, name: 'Eunji')
post = build(:post, author: eunji)
```

Ruby 3.1's support for [omitting values][] from `Hash` literals dovetails with
attribute overrides, and provides an opportunity to limit the repetition of
variable names:

```ruby
author = build(:author, name: 'Eunji')

post = build(:post, author:)
```

[omitting values]: https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals

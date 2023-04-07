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

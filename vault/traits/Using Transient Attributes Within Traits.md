---
type: note
created: 2025-11-07T21:44:59-06:00
updated: 2025-11-07T21:45:15-06:00
tags: []
aliases: []
---
# Using Transient Attributes Within Traits

Traits can accept transient attributes.

```ruby
factory :invoice do
  trait :with_amount do
    transient do
      amount { 1 }
    end

    after(:create) do |invoice, context|
      create :line_item, invoice: invoice, amount: context.amount
    end
  end
end

create :invoice, :with_amount, amount: 2
```

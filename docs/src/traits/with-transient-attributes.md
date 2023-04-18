# With transient attributes

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

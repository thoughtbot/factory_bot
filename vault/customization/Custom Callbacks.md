---
type: note
created: 2025-11-07T19:58:33-06:00
updated: 2025-11-07T20:14:07-06:00
tags: []
aliases: []
---
# Custom Callbacks

Custom callbacks can be defined when you're using [[Custom Strategies]]:

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    result = @strategy.result(evaluation)
    evaluation.notify(:before_json, result)

    result.to_json.tap do |json|
      evaluation.notify(:after_json, json)
      evaluation.notify(:make_json_awesome, json)
    end
  end

  def to_sym
    :json
  end
end

FactoryBot.register_strategy(:json, JsonStrategy)

FactoryBot.define do
  factory :user do
    before(:json)                { |user| do_something_to(user) }
    after(:json)                 { |user_json| do_something_to(user_json) }
    callback(:make_json_awesome) { |user_json| do_something_to(user_json) }
  end
end
```

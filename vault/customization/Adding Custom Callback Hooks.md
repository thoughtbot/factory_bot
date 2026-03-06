---
type: note
created: 2025-11-07T19:58:33-06:00
updated: 2026-03-06T16:08:43-06:00
tags: []
aliases: []
up: "[[Customization]]"
---
# Adding Custom Callback Hooks

A **Custom Callback Hook** can be defined to publish custom events from within a [[Building a Custom Strategy|Custom Strategy]].

## Example: JSON Strategy With Callback Hooks

The example below extends the [[Building a Custom Strategy#Example JSON Strategy|JSON Strategy]] example with three custom event notifications: `before_json`, `after_json`, and `make_json_awesome`.

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
```

These events can then be subscribed to in the typical fashion:

```ruby
FactoryBot.define do
  factory :user do
    before(:json)                { |user| do_something_to(user) }
    after(:json)                 { |user_json| do_something_to(user_json) }
    callback(:make_json_awesome) { |user_json| do_something_to(user_json) }
  end
end
```

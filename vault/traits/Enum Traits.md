---
type: note
created: 2025-11-07T21:19:25-06:00
updated: 2025-11-08T20:19:47-06:00
tags: []
aliases: []
---
# Enum Traits

Within a `factory` definition block, the `traits_for_enum` method is a helper for any object with an attribute that can be one of a few values. The original inspiration was [`ActiveRecord::Enum`] but it can apply to any attribute with a restricted set of values.

[`ActiveRecord::Enum`]: https://api.rubyonrails.org/classes/ActiveRecord/Enum.html

## The `traits_for_enum` Method

The `traits_for_enum` method creates a trait for each value of an enum. It takes a required attribute name and an optional set of values. The values can be any Enumerable, such as Array or Hash. By default, the values are `nil`.

- If the values are an Array, this method defines a trait for each element in the array. The trait's name is the array element, and it sets the attribute to the same array element.
- If the values are a Hash, this method defines traits based on the keys, setting the attribute to the values. The trait's name is the key, and it sets the attribute to the value.
- If the value is any other Enumerable, it treats it like an Array or Hash based on whether `#each` iterates in pairs like it does for Hashes.
- If the value is nil, it uses a class method named after the pluralized attribute name.

```ruby
FactoryBot.define do
  factory :article do
    traits_for_enum :visibility, [:public, :private]
    # trait :public do
    #   visibility { :public }
    # end
    # trait :private do
    #   visibility { :private }
    # end

    traits_for_enum :collaborative, draft: 0, shared: 1
    # trait :draft do
    #   collaborative { 0 }
    # end
    # trait :shared do
    #   collaborative { 1 }
    # end

    traits_for_enum :status
    # Article.statuses.each do |key, value|
    #   trait key do
    #     status { value }
    #   end
    # end
  end
end
```

## Automatic Traits for ActiveRecord Enum Attributes

Given an ActiveRecord model with an enum attribute:

```rb
class Task < ActiveRecord::Base
  enum status: { queued: 0, started: 1, finished: 2 }
end
```

factory\_bot will automatically define traits for each possible value of the enum:

```rb
FactoryBot.define do
  factory :task
end

FactoryBot.build(:task, :queued)
FactoryBot.build(:task, :started)
FactoryBot.build(:task, :finished)
```

Writing the traits out manually would be cumbersome, and is not necessary:

```rb
FactoryBot.define do
  factory :task do
    trait :queued do
      status { :queued }
    end

    trait :started do
      status { :started }
    end

    trait :finished do
      status { :finished }
    end
  end
end
```

## Disabling Automatic Definition of Enum Traits

If automatically defining traits for enum attributes on every factory is not desired, it is possible to disable the feature by setting `FactoryBot.automatically_define_enum_traits = false`

In that case, it is still possible to explicitly define traits for an enum attribute in a particular factory:

```rb
FactoryBot.automatically_define_enum_traits = false

FactoryBot.define do
  factory :task do
    traits_for_enum(:status)
  end
end
```

## More Examples
### Example: Enum With an Array

```rb
class Task
  attr_accessor :status
end

FactoryBot.define do
  factory :task do
    traits_for_enum(:status, ["queued", "started", "finished"])
  end
end
```

### Example: Enum With a Hash

```rb
class Task
  attr_accessor :status
end

FactoryBot.define do
  factory :task do
    traits_for_enum(:status, { queued: 0, started: 1, finished: 2 })
  end
end
```

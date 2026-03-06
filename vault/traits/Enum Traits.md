---
type: note
created: 2025-11-07T21:19:25-06:00
updated: 2026-02-28T09:57:26-06:00
tags: []
aliases:
  - traits_for_enum
  - Enum Trait
  - Enum Traits
  - Enumerated Traits
  - Enumerated Trait
up: "[[§ Traits]]"
---
# Enum Traits

An **Enum Trait** takes inspiration from the Rails [`ActiveRecord::Enum`](https://api.rubyonrails.org/classes/ActiveRecord/Enum.html), but can be applied to any attribute which constrains it's values to a restricted set.

## The `traits_for_enum` Method

Within a `factory` definition block, the `traits_for_enum` method can be invoked to create a trait for each value of an enum. 

- It takes a required attribute name and an optional set of values. 
- The values can be any Enumerable, such as Array or Hash. 
- By default, the values are `nil`.

### Enum Values

- When the values are an **Array**:
    - this method defines a trait for each element in the array. 
    - The trait's name is the array element, 
    - Sets the attribute to the same array element.
- When the values are a **Hash**:
    - this method defines traits based on the keys, setting the attribute to the values. 
    - The trait's name is the key
    - Sets the attribute to the value.
- When the value is any other **Enumerable**:
    - it treats it like an Array or Hash based on whether `#each` iterates in pairs like it does for Hashes.
- When the value is nil:
    - it uses a class method named after the pluralized attribute name.

### Example Usage

The example below shows three use cases: using an array of enum values, using a Hash of enum values, and relying on a pluralized attribute to retrieve the enum values. Below each invocation of `traits_for_enum` is rough equivalent if the shorthand helper was not used.

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

## Enum With an Array

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

## Enum With a Hash

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

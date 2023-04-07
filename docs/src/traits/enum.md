# Enum traits

Given an Active Record model with an enum attribute:

```rb
class Task < ActiveRecord::Base
  enum status: {queued: 0, started: 1, finished: 2}
end

```

factory\_bot will automatically define traits for each possible value of the
enum:

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

If automatically defining traits for enum attributes on every factory is not
desired, it is possible to disable the feature by setting
`FactoryBot.automatically_define_enum_traits = false`

In that case, it is still possible to explicitly define traits for an enum
attribute in a particular factory:

```rb
FactoryBot.automatically_define_enum_traits = false

FactoryBot.define do
  factory :task do
    traits_for_enum(:status)
  end
end
```

It is also possible to use this feature for other enumerable values, not
specifically tied to Active Record enum attributes.

With an array:

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

Or with a hash:

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

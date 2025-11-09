---
type: note
created: 2025-11-07T16:10:12-06:00
updated: 2025-11-07T16:16:17-06:00
tags: []
aliases: []
---
# Using Scoped Attributes Within Sequences

## Scoped Attributes

On occasion a sequence block may refer to a scoped attribute. In this case, the scope must be provided, or else an exception will be raised. 

Take the following factory for example:

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{name}-#{n}@example.com" }
  end
end
```

An attempt to generate the sequence without providing a scoped attribute will result in an `ArgumentError`: 

```ruby
generate(:user, :email)
# ArgumentError, Sequence user:email failed to return a value. Perhaps it needs a scope to operate? (scope: <object>)
```

An override attribute can be provided when running the factory:

```ruby
jester = build(:user, name: "Jester")
jester.email # "Jester-1@example.com"
```

Or the scope can be provided when generating the sequence manually:

```ruby
generate(:user, :email, scope: jester)
# "Jester-2@example.com"

generate_list(:user, :email, 2, scope: jester)
# ["Jester-3@example.com", "Jester-4@example.com"]
```

## Defining Scope in Tests

When testing, the scope can be any object that responds to the referenced attributes:

```ruby
require 'ostruct'

FactoryBot.define
  factory :user do
    sequence(:info) { |n| "#{name}-#{n}-#{age + n}" }
  end
end

test_scope = OpenStruct.new(name: "Jester", age: 23)

generate_list('user/info', 3, scope: test_scope)
# ["Jester-1-24", "Jester-2-25", "Jester-3-26"]
```

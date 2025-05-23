# Generating a Sequence

Being able to diectly generate a sequence, without having to build the object can really speed up testing. This can be achieved by passing the [sequence URI](sequence-uris.md) to `:generate` for a single value or `:generate_list` for an Array of sequential values.

```ruby
FactoryBot.define do
  sequence(:char, 'a') {|c| "global_character_#{c}" }

  factory :user do
    sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)

    trait :with_age do
      sequence(:age, 21)
    end
  end
end

##
# char
generate(:char) # "global_character_a"
generate_list(:char, 2) # ["global_character_b", "global_character_c"]
generate(:char) # "global_character_d"

##
# user name
generate(:user, :name) # "Jane"
generate_list(:user, :name, 3) # ['Joe', 'Josh', 'Jayde']
generate(:user, :name) # "John"

##
# user age
generate(:user, :with_age, :age) # 21
generate_list(:user, :with_age, :age, 5) # [22, 23, 24, 25, 26]
generate(:user, :with_age, :age) # 27
```

## Scope

On occasion a sequence block may refer to a scoped attribute. In this case, the scope must be provided, or else an exception will be raised:

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{name}-#{n}@example.com" }
  end
end

generate(:user, :email)
# ArgumentError, Sequence user:email failed to return a value. Perhaps it needs a scope to operate? (scope: <object>)

jester = build(:user, name: "Jester")
jester.email # "Jester-1@example.com"

generate(:user, :email, scope: jester)
# "Jester-2@example.com"

generate_list(:user, :email, 2, scope: jester)
# ["Jester-3@example.com", "Jester-4@example.com"]
```

When testing, the scope can be any object that responds to the referrenced attributes:

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

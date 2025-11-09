---
type: note
created: 2025-11-07T15:55:26-06:00
updated: 2025-11-07T16:27:22-06:00
tags: []
aliases: []
---
# Generating a Sequence

Being able to directly generate a sequence, without having to build the object can really speed up testing. This can be achieved by passing the [[Sequence URI]] to `:generate` for a single value or to `:generate_list` for an Array of sequential values.

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

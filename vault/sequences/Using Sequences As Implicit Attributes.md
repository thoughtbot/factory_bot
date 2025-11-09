---
type: note
created: 2025-11-07T15:28:43-06:00
updated: 2025-11-07T15:29:40-06:00
tags: []
aliases: []
---
# Using Sequences As Implicit Attributes

A [[§ sequences|Sequence]] can be used as an [[Implicit Attribute]]

```ruby
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

factory :user do
  email # Same as `email { generate(:email) }`
end
```

Note that defining sequences as implicit attributes will not work if you have a factory with the same name as the sequence.

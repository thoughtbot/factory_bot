---
type: note
created: 2025-11-07T15:14:47-06:00
updated: 2025-11-07T15:14:59-06:00
tags: []
aliases: []
---
# Sequences and Uniqueness Constraints

When working with uniqueness constraints, be careful not to pass in override
values that will conflict with the generated sequence values.

In this example the email will be the same for both users. If email must be
unique, this code will error:

```rb
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end

FactoryBot.create(:user, email: "person1@example.com")
FactoryBot.create(:user)
```

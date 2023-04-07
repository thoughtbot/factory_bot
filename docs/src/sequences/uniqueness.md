# Uniqueness

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

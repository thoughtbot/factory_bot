# method_missing

With a `factory` definition block, you can use `add_attribute`, `association`,
`sequence`, and `trait` to define a factory. You can also level a default
`method_missing` definition for potential shortcuts.

Calling an unknown method (e.g. `name`, `admin`, `email`, `account`) connects
an association, sequence, trait, or attribute to the factory:

1. If the method missing is passed a block, it always defines an attribute.
   This allows you to set the value for the attribute.

1. If the method missing is passed a hash as a argument with the key
   `:factory`, then it always defines an association. This allows you to
   override the factory used for the association.

1. If there is another factory of the same name, then it defines an
   association.

1. If there is a global sequence of the same name, then it defines an attribute
   with a value that pulls from the sequence.

1. If there is a trait of the same name for that factory, then it turns that
   trait on for all builds of this factory.

Using `method_missing` can turn an explicit definition:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user, traits: [:admin] do
    add_attribute(:name) { "Lord Nikon" }
    add_attribute(:email) { generate(:email) }
    association :account
    association :org, factory: :organization

    trait :admin do
      add_attribute(:admin) { true }
    end
  end
end
```

... into a more implicit definition:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user do
    name { "Lord Nikon" }      # no more `add_attribute`
    admin                      # no more :traits
    email                      # no more `add_attribute`
    account                    # no more `association`
    org factory: :organization # no more `association`

    trait :admin do
      admin { true }
    end
  end
end
```

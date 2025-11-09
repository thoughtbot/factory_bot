---
type: note
created: 2025-11-07T20:52:56-06:00
updated: 2025-11-07T20:58:18-06:00
tags: []
aliases: []
---
# Custom Object Persistence

FactoryBot provides the means to customize the manner with which objects are persisted. 
## Override a Single Factory

When employing the [[create Strategy|create]] strategy during a Factory run, by default, the creation of the record will result in `save!` being called on the object instance; since this may not always be ideal, you can override that behavior by defining `to_create` on the factory:

```ruby
factory :different_orm_model do
  to_create { |instance| instance.persist! }
end
```

## Override Persistence For All Factories

To override `to_create` for all factories, define it within the `FactoryBot.define` block:

```ruby
FactoryBot.define do
  to_create { |instance| instance.persist! }


  factory :user do
    name { "John Doe" }
  end
end
```

## Disable Persistence

To disable the persistence method altogether on create, you can `skip_create` for that factory:

```ruby
factory :user_without_database do
  skip_create
end
```
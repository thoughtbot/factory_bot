# Custom Methods to Persist Objects

By default, creating a record will call `save!` on the instance; since this may
not always be ideal, you can override that behavior by defining `to_create` on
the factory:

```ruby
factory :different_orm_model do
  to_create { |instance| instance.persist! }
end
```

To disable the persistence method altogether on create, you can `skip_create`
for that factory:

```ruby
factory :user_without_database do
  skip_create
end
```

To override `to_create` for all factories, define it within the
`FactoryBot.define` block:

```ruby
FactoryBot.define do
  to_create { |instance| instance.persist! }


  factory :user do
    name { "John Doe" }
  end
end
```

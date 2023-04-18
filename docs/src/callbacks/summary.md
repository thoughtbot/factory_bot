# Callbacks

factory\_bot makes four callbacks available:

* after(:build)   - called after a factory is built   (via `FactoryBot.build`, `FactoryBot.create`)
* before(:create) - called before a factory is saved  (via `FactoryBot.create`)
* after(:create)  - called after a factory is saved   (via `FactoryBot.create`)
* after(:stub)    - called after a factory is stubbed (via `FactoryBot.build_stubbed`)

Examples:

```ruby
# Define a factory that calls the generate_hashed_password method after the user factory is built
factory :user do
  after(:build) { |user, context| generate_hashed_password(user) }
end
```

Note that you'll have an instance of the object in the block.

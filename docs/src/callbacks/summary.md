# Callbacks

factory\_bot makes six callbacks available:

| Callback        | Timing                                                                                                                    |
| --------------- | ------------------------------------------------------------------------------------------------------------------------- |
| before(:all)    | called before a factory constructs an object (via `FactoryBot.build`, `FactoryBot.create`, or `FactoryBot.build_stubbed`) |
| after(:build)   | called after a factory builds an object (via `FactoryBot.build` or `FactoryBot.create`)                                   |
| before(:create) | called before a factory saves an object (via `FactoryBot.create`)                                                         |
| after(:create)  | called after a factory saves an object (via `FactoryBot.create`)                                                          |
| after(:stub)    | called after a factory stubs an object (via `FactoryBot.build_stubbed`)                                                   |
| after(:all)     | called after a factory constructs an object (via `FactoryBot.build`, `FactoryBot.create`, or `FactoryBot.build_stubbed`)  |


## Examples

### Calling an object's own method after building

```ruby
## 
# Define a factory that calls the generate_hashed_password method
# after the user factory is built.
#
# Note that you'll have an instance of the object in the block
#
factory :user do
  after(:build) { |user, context| generate_hashed_password(user) }
end
```

### Skipping an object's own :after_create callback

```ruby
##
# Disable a model's own :after_create callback that sends an email 
# on creation, then re-enable it afterwards
#
factory :user do
  before(:all){ User.skip_callback(:create, :after, :send_welcome_email) }
  after(:all){ User.set_callback(:create, :after, :send_welcome_email) }
end
```



# Callbacks

factory\_bot makes six callbacks available:

|Callback|Timing|
|---|---|
|before(:all)   |called before a factory begins generating the object.|
|after(:all)    |called after a factory has generated the object.|
|after(:build)  |called after a factory is built (via `FactoryBot.build`, `FactoryBot.create`)|
|before(:create)|called before a factory is saved (via `FactoryBot.create`)|
|after(:create) |called after a factory is saved (via `FactoryBot.create`)|
|after(:stub)   |called after a factory is stubbed (via `FactoryBot.build_stubbed`)|


## Examples:

### Calling an object's own method after building.

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



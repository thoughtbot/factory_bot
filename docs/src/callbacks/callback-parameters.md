# Callback parameters

Callbacks can receive zero, one or two parameters.

## With zero parameters

Callbacks with zero parameters simply execute the provided block of code:
```ruby
factory :user do
  after(:stub)   { do_something() }
end
```

## With one parameter

Callbacks with a single parameter receive the factory instance being constructed:
```ruby
factory :user do
  after(:build)  { |user| do_something_to(user) }
end
```

## With two parameters

Callbacks with two parameters receive both the factory instance 
and the context in which the instance is constructed:
```ruby
factory :user do
  transient { article { <article> } }

  after(:create) { |user, context| user.post_first_article(context.article) }
end
```

## Callback context

The `context` parameter provides access to the environment in which the 
instance is constructed.

### Transient settings

Transient settings are accessed directly from the `context`:
```ruby
factory :car do
  transient { doors { 4 } }

  after(:create) do |car, context| 
    car.update(style: :sedan) if context.doors == 4 
    car.update(style: :coupe) if context.doors == 2
  end 
end

car = FactoryBot.create(:car, doors: 2)
car.style #=> :coupe
```

### Strategy used

Sometimes you have a factory that you both `build` and `create` in different tests,
but always want the same code to run at the end. 

It's not as simple as adding both `after(:build)` and `after(:create)` callbacks because `after(:create)` also triggers the `after(:build)` callback, so the code would be run twice.

Checking for the strategy used can help skip the `after(:build)` code when the strategy used is `create`.
```ruby
factory :user do
  after(:build) { |user, context| run_this_code() if context.strategy.build?}
  after(:create) { |user, context| run_this_code() }
end
```

### Defined attributes
Sometimes you need to know if an attribute was provided by the user or defined by the factory. `context` provides a list of the attributes which have been defined: in total; by the user; or by the factory. The list may also be queried for a simgle entry:
```ruby
# based on FactoryBot.build(:car, doors: 2)
factory :car do
  transient { transmission { :manual } }

  doors  { 4 }
  seats  { 5 }
  wheels { 6 }

  after(:build) do |car, context| 
    context.defined_attributes                 #=> [:doors, :seats, :wheels]
    context.user_defined_attributes            #=> [:doors]
    context.factory_defined_attributes         #=> [:seats, :wheels]

    context.defined_attributes.wheels?         #=> true
    context.user_defined_attributes.wheels?    #=> false
    context.factory_defined_attributes.wheels? #=> true
  end 
end
```

**Note**: Transient attributes are not included in the list unless they have been provided
by the user.
```ruby
# based on FactoryBot.build(:car, doors: 2, transmission: :automatic)
factory :car do
  transient { transmission { :manual } }

  doors  { 4 }
  seats  { 5 }
  wheels { 6 }

  after(:build) do |car, context| 
    context.defined_attributes         #=> [:doors, :seats, :transmission :wheels]
    context.user_defined_attributes    #=> [:doors, :transmission]
    context.factory_defined_attributes #=> [:seats, :wheels]
  end 
end
```
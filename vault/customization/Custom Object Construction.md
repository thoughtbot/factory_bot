---
type: note
created: 2025-11-07T20:28:04-06:00
updated: 2025-11-07T20:51:18-06:00
tags: []
aliases:
  - initialize_with
---
# Custom Object Construction

Although factory\_bot is written to work with ActiveRecord out of the box, it can also work with any Ruby class. For maximum compatibility with ActiveRecord, the default initializer builds all instances by calling `new` on your build class without any arguments. It then calls attribute writer methods to assign all the attribute values. While that works fine for ActiveRecord, it actually doesn't work for almost any other Ruby class.

If you want to use factory\_bot to construct an object where some attributes are passed to `initialize` — or if you want to do something other than calling `new` on your build class — you can override the default behavior by defining `initialize_with` on your factory.

## Reasons to Override the Initializer

You can override the initializer in order to:

- Build non-ActiveRecord objects that require arguments passed to `initialize`
- Use a method other than `new` to instantiate the instance
- Do wild things like decorate the instance after it's built

## Passing an Attribute to `initialize`

The `initialize_with` method enables you to customize the initializer within a Factory.

```ruby
# user.rb
class User
  attr_accessor :name, :email

  def initialize(name)
    @name = name
  end
end

# factories.rb
sequence(:email) { |n| "person#{n}@example.com" }

factory :user do
  name { "Jane Doe" }
  email

  initialize_with { new(name) }
end

build(:user).name # Jane Doe
```

As illustrated in the example above, when using `initialize_with`, is is not necessary to declare the class itself when calling `new`. To invoke any other class method, however, it is necessary to call it on the class explicitly.

## Using an Alternate Class Method

To use a class method `User.build_with_name`, for example, you would need to declare the class:

```ruby
factory :user do
  name { "John Doe" }

  initialize_with { User.build_with_name(name) }
end
```

## Accessing All Public Attributes

It is possible to gain access to all public attributes within the `initialize_with` block by calling `attributes`:

```ruby
factory :user do
  transient do
    comments_count { 5 }
  end

  name "John Doe"

  initialize_with { new(**attributes) }
end
```

This will build a hash of all attributes to be passed to `new`. It won't include transient attributes, but everything else defined in the factory will be passed (associations, evaluated sequences, etc.)

## Define `initialize_with` Globally

You can define `initialize_with` for all factories by including it in the `FactoryBot.define` block:

```ruby
FactoryBot.define do
  initialize_with { new("Awesome first argument") }
end
```

## Attributes Are Assigned Only Once

Since FactoryBot 4.0, attributes accessed from within the `initialize_with` block are assigned *only* in the constructor. This prevents duplicate assignment.

Given the following factory definition:

```ruby
FactoryBot.define do
  factory :user do
    initialize_with { new(name) }

    name { 'value' }
  end
end
```

Invoking `build(:user)` equates to roughly the following code:

```ruby
# build(:user) runs:
User.new('value')
```

In versions of factory\_bot before 4.0, the behavior would be equivalent to the following:

```ruby
# build(:user) runs
user = User.new('value')
user.name = 'value'
```

The old behavior would result in the `name` attribute being assigned twice. First at the time of construction, and then by assignment.

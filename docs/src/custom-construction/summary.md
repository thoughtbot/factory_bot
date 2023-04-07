# Custom Construction

If you want to use factory\_bot to construct an object where some attributes
are passed to `initialize` or if you want to do something other than simply
calling `new` on your build class, you can override the default behavior by
defining `initialize_with` on your factory. Example:

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

Although factory\_bot is written to work with ActiveRecord out of the box, it
can also work with any Ruby class. For maximum compatibility with ActiveRecord,
the default initializer builds all instances by calling `new` on your build
class without any arguments. It then calls attribute writer methods to assign
all the attribute values. While that works fine for ActiveRecord, it actually
doesn't work for almost any other Ruby class.

You can override the initializer in order to:

* Build non-ActiveRecord objects that require arguments to `initialize`
* Use a method other than `new` to instantiate the instance
* Do wild things like decorate the instance after it's built

When using `initialize_with`, you don't have to declare the class itself when
calling `new`; however, any other class methods you want to call will have to
be called on the class explicitly.

For example:

```ruby
factory :user do
  name { "John Doe" }

  initialize_with { User.build_with_name(name) }
end
```

You can also access all public attributes within the `initialize_with` block
by calling `attributes`:

```ruby
factory :user do
  transient do
    comments_count { 5 }
  end

  name "John Doe"

  initialize_with { new(**attributes) }
end
```

This will build a hash of all attributes to be passed to `new`. It won't
include transient attributes, but everything else defined in the factory will
be passed (associations, evaluated sequences, etc.)

You can define `initialize_with` for all factories by including it in the
`FactoryBot.define` block:

```ruby
FactoryBot.define do
  initialize_with { new("Awesome first argument") }
end
```

When using `initialize_with`, attributes accessed from within the
`initialize_with` block are assigned *only* in the constructor; this equates to
roughly the following code:

```ruby
FactoryBot.define do
  factory :user do
    initialize_with { new(name) }

    name { 'value' }
  end
end

build(:user)
# runs
User.new('value')
```

This prevents duplicate assignment; in versions of factory\_bot before 4.0, it
would run this:

```ruby
FactoryBot.define do
  factory :user do
    initialize_with { new(name) }

    name { 'value' }
  end
end

build(:user)
# runs
user = User.new('value')
user.name = 'value'
```

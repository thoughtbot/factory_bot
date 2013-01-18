Getting Started
===============

Update Your Gemfile
-------------------

If you're using Rails, you'll need to change the required version of `factory_girl_rails`:

```ruby
gem "factory_girl_rails", "~> 4.0"
```

If you're *not* using Rails, you'll just have to change the required version of `factory_girl`:

```ruby
gem "factory_girl", "~> 4.0"
```

JRuby users: FactoryGirl works with JRuby starting with 1.6.7.2 (latest stable, as per July 2012).
JRuby has to be used in 1.9 mode, for that, use JRUBY_OPTS environment variable:

```
export JRUBY_OPTS=--1.9
```

Once your Gemfile is updated, you'll want to update your bundle.

Using Without Bundler
---------------------

If you're not using Bundler, be sure to have the gem installed and call:

```
require 'factory_girl'
```

Once required, assuming you have a directory structure of `spec/factories` or
`test/factories`, all you'll need to do is run

```ruby
FactoryGirl.find_definitions
```

If you're using a separate directory structure for your factories, you can
change the definition file paths before trying to find definitions:

```ruby
FactoryGirl.definition_file_paths = %w(custom_factories_directory)
FactoryGirl.find_definitions
```

If you don't have a separate directory of factories and would like to define
them inline, that's possible as well:

```ruby
require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name 'John Doe'
    date_of_birth { 21.years.ago }
  end
end
```

Defining factories
------------------

Each factory has a name and a set of attributes. The name is used to guess the class of the object by default, but it's possible to explicitly specify it:

```ruby
# This will guess the User class
FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    admin false
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    admin      true
  end
end
```

It is highly recommended that you have one factory for each class that provides the simplest set of attributes necessary to create an instance of that class. If you're creating ActiveRecord objects, that means that you should only provide attributes that are required through validations and that do not have defaults. Other factories can be created through inheritance to cover common scenarios for each class.

Attempting to define multiple factories with the same name will raise an error.

Factories can be defined anywhere, but will be automatically loaded if they
are defined in files at the following locations:

    test/factories.rb
    spec/factories.rb
    test/factories/*.rb
    spec/factories/*.rb

Using factories
---------------

factory\_girl supports several different build strategies: build, create, attributes\_for and build\_stubbed:

```ruby
# Returns a User instance that's not saved
user = FactoryGirl.build(:user)

# Returns a saved User instance
user = FactoryGirl.create(:user)

# Returns a hash of attributes that can be used to build a User instance
attrs = FactoryGirl.attributes_for(:user)

# Returns an object with all defined attributes stubbed out
stub = FactoryGirl.build_stubbed(:user)

# Passing a block to any of the methods above will yield the return object
FactoryGirl.create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```

No matter which strategy is used, it's possible to override the defined attributes by passing a hash:

```ruby
# Build a User instance and override the first_name property
user = FactoryGirl.build(:user, first_name: "Joe")
user.first_name
# => "Joe"
```

If repeating "FactoryGirl" is too verbose for you, you can mix the syntax methods in:

```ruby
# rspec
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# Test::Unit
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

# Cucumber
World(FactoryGirl::Syntax::Methods)

# MiniTest
class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

# MiniTest::Spec
class MiniTest::Spec
  include FactoryGirl::Syntax::Methods
end

# minitest-rails
class MiniTest::Rails::ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
```

This allows you to use the core set of syntax methods (`build`,
`build_stubbed`, `create`, `attributes_for`, and their `*_list` counterparts)
without having to call them on FactoryGirl directly:

```ruby
describe User, "#full_name" do
  subject { create(:user, first_name: "John", last_name: "Doe") }

  its(:full_name) { should eq "John Doe" }
end
```

Lazy Attributes
---------------

Most factory attributes can be added using static values that are evaluated when
the factory is defined, but some attributes (such as associations and other
attributes that must be dynamically generated) will need values assigned each
time an instance is generated. These "lazy" attributes can be added by passing a
block instead of a parameter:

```ruby
factory :user do
  # ...
  activation_code { User.generate_activation_code }
  date_of_birth   { 21.years.ago }
end
```

In addition to running other methods dynamically, you can use FactoryGirl's
syntax methods (like `build`, `create`, and `generate`) within dynamic
attributes without having to prefix the call with `FactoryGirl.`. This allows
you to do:

```ruby
sequence(:random_string) {|n| LoremIpsum.generate }

factory :post do
  title { generate(:random_string) } # instead of FactoryGirl.generate(:random_string)
end

factory :comment do
  post
  body { generate(:random_string) }  # instead of FactoryGirl.generate(:random_string)
end
```

Aliases
-------

Aliases allow you to use named associations more easily.

```ruby
factory :user, aliases: [:author, :commenter] do
  first_name    "John"
  last_name     "Doe"
  date_of_birth { 18.years.ago }
end

factory :post do
  author
  # instead of
  # association :author, factory: :user
  title "How to read a book effectively"
  body  "There are five steps involved."
end

factory :comment do
  commenter
  # instead of
  # association :commenter, factory: :user
  body "Great article!"
end
```

Dependent Attributes
--------------------

Attributes can be based on the values of other attributes using the evaluator that is yielded to lazy attribute blocks:

```ruby
factory :user do
  first_name "Joe"
  last_name  "Blow"
  email { "#{first_name}.#{last_name}@example.com".downcase }
end

FactoryGirl.create(:user, last_name: "Doe").email
# => "joe.doe@example.com"
```

Transient Attributes
--------------------

There may be times where your code can be DRYed up by passing in transient attributes to factories.

```ruby
factory :user do
  ignore do
    rockstar true
    upcased  false
  end

  name  { "John Doe#{" - Rockstar" if rockstar}" }
  email { "#{name.downcase}@example.com" }

  after(:create) do |user, evaluator|
    user.name.upcase! if evaluator.upcased
  end
end

FactoryGirl.create(:user, upcased: true).name
#=> "JOHN DOE - ROCKSTAR"
```

Static and dynamic attributes can be ignored. Ignored attributes will be ignored
within attributes\_for and won't be set on the model, even if the attribute
exists or you attempt to override it.

Within FactoryGirl's dynamic attributes, you can access ignored attributes as
you would expect. If you need to access the evaluator in a FactoryGirl callback,
you'll need to declare a second block argument (for the evaluator) and access
ignored attributes from there.

Associations
------------

It's possible to set up associations within factories. If the factory name is the same as the association name, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```

You can also specify a different factory or override attributes:

```ruby
factory :post do
  # ...
  association :author, factory: :user, last_name: "Writely"
end
```

The behavior of the association method varies depending on the build strategy used for the parent object.

```ruby
# Builds and saves a User and a Post
post = FactoryGirl.create(:post)
post.new_record?        # => false
post.author.new_record? # => false

# Builds and saves a User, and then builds but does not save a Post
post = FactoryGirl.build(:post)
post.new_record?        # => true
post.author.new_record? # => false
```

To not save the associated object, specify strategy: :build in the factory:

```ruby
factory :post do
  # ...
  association :author, factory: :user, strategy: :build
end

# Builds a User, and then builds a Post, but does not save either
post = FactoryGirl.build(:post)
post.new_record?        # => true
post.author.new_record? # => true
```

Please note that the `strategy: :build` option must be passed to an explicit call to `association`,
and cannot be used with implicit associations:

```ruby
factory :post do
  # ...
  author strategy: :build    # <<< this does *not* work; causes author_id to be nil
```

Generating data for a `has_many` relationship is a bit more involved,
depending on the amount of flexibility desired, but here's a surefire example
of generating associated data.

```ruby
FactoryGirl.define do

  # post factory with a `belongs_to` association for the user
  factory :post do
    title "Through the Looking Glass"
    user
  end

  # user factory without associated posts
  factory :user do
    name "John Doe"

    # user_with_posts will create post data after the user has been created
    factory :user_with_posts do
      # posts_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      ignore do
        posts_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end
```

This allows us to do:

```ruby
FactoryGirl.create(:user).posts.length # 0
FactoryGirl.create(:user_with_posts).posts.length # 5
FactoryGirl.create(:user_with_posts, posts_count: 15).posts.length # 15
```

Inheritance
-----------

You can easily create multiple factories for the same class without repeating common attributes by nesting factories:

```ruby
factory :post do
  title "A title"

  factory :approved_post do
    approved true
  end
end

approved_post = FactoryGirl.create(:approved_post)
approved_post.title    # => "A title"
approved_post.approved # => true
```

You can also assign the parent explicitly:

```ruby
factory :post do
  title "A title"
end

factory :approved_post, parent: :post do
  approved true
end
```

As mentioned above, it's good practice to define a basic factory for each class
with only the attributes required to create it. Then, create more specific
factories that inherit from this basic parent. Factory definitions are still
code, so keep them DRY.

Sequences
---------

Unique values in a specific format (for example, e-mail addresses) can be
generated using sequences. Sequences are defined by calling sequence in a
definition block, and values in a sequence are generated by calling
FactoryGirl.generate:

```ruby
# Defines a new sequence
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.generate :email
# => "person1@example.com"

FactoryGirl.generate :email
# => "person2@example.com"
```

Sequences can be used as attributes:

```ruby
factory :user do
  email
end
```

Or in lazy attributes:

```ruby
factory :invite do
  invitee { generate(:email) }
end
```

And it's also possible to define an in-line sequence that is only used in
a particular factory:

```ruby
factory :user do
  sequence(:email) {|n| "person#{n}@example.com" }
end
```

You can also override the initial value:

```ruby
factory :user do
  sequence(:email, 1000) {|n| "person#{n}@example.com" }
end
```

Without a block, the value will increment itself, starting at its initial value:

```ruby
factory :post do
  sequence(:position)
end
```

Sequences can also have aliases. The sequence aliases share the same counter:

```ruby
factory :user do
  sequence(:email, 1000, aliases: [:sender, :receiver]) {|n| "person#{n}@example.com" }
end

# will increase value counter for :email which is shared by :sender and :receiver
FactoryGirl.next(:sender)
```

Define aliases and use default value (1) for the counter

```ruby
factory :user do
  sequence(:email, aliases: [:sender, :receiver]) {|n| "person#{n}@example.com" }
end
```

Setting the value:

```ruby
factory :user do
  sequence(:email, 'a', aliases: [:sender, :receiver]) {|n| "person#{n}@example.com" }
end
```

The value just needs to support the `#next` method. Here the next value will be 'a', then 'b', etc.

Traits
------

Traits allow you to group attributes together and then apply them
to any factory.

```ruby
factory :user, aliases: [:author]

factory :story do
  title "My awesome story"
  author

  trait :published do
    published true
  end

  trait :unpublished do
    published false
  end

  trait :week_long_publishing do
    start_at { 1.week.ago }
    end_at   { Time.now }
  end

  trait :month_long_publishing do
    start_at { 1.month.ago }
    end_at   { Time.now }
  end

  factory :week_long_published_story,    traits: [:published, :week_long_publishing]
  factory :month_long_published_story,   traits: [:published, :month_long_publishing]
  factory :week_long_unpublished_story,  traits: [:unpublished, :week_long_publishing]
  factory :month_long_unpublished_story, traits: [:unpublished, :month_long_publishing]
end
```

Traits can be used as attributes:

```ruby
factory :week_long_published_story_with_title, parent: :story do
  published
  week_long_publishing
  title { "Publishing that was started at {start_at}" }
end
```

Traits that define the same attributes won't raise AttributeDefinitionErrors;
the trait that defines the attribute latest gets precedence.

```ruby
factory :user do
  name "Friendly User"
  login { name }

  trait :male do
    name   "John Doe"
    gender "Male"
    login { "#{name} (M)" }
  end

  trait :female do
    name   "Jane Doe"
    gender "Female"
    login { "#{name} (F)" }
  end

  trait :admin do
    admin true
    login { "admin-#{name}" }
  end

  factory :male_admin,   traits: [:male, :admin]   # login will be "admin-John Doe"
  factory :female_admin, traits: [:admin, :female] # login will be "Jane Doe (F)"
end
```

You can also override individual attributes granted by a trait in subclasses.

```ruby
factory :user do
  name "Friendly User"
  login { name }

  trait :male do
    name   "John Doe"
    gender "Male"
    login { "#{name} (M)" }
  end

  factory :brandon do
    male
    name "Brandon"
  end
end
```

Traits can also be passed in as a list of symbols when you construct an instance from FactoryGirl.

```ruby
factory :user do
  name "Friendly User"

  trait :male do
    name   "John Doe"
    gender "Male"
  end

  trait :admin do
    admin true
  end
end

# creates an admin user with gender "Male" and name "Jon Snow"
FactoryGirl.create(:user, :admin, :male, name: "Jon Snow")
```

This ability works with `build`, `build_stubbed`, `attributes_for`, and `create`.

`create_list` and `build_list` methods are supported as well. Just remember to pass
the number of instances to create/build as second parameter, as documented in the
"Building or Creating Multiple Records" section of this file.

```ruby
factory :user do
  name "Friendly User"

  trait :admin do
    admin true
  end
end

# creates 3 admin users with gender "Male" and name "Jon Snow"
FactoryGirl.create_list(:user, 3, :admin, :male, name: "Jon Snow")
```

Traits can be used with associations easily too:

```ruby
factory :user do
  name "Friendly User"

  trait :admin do
    admin true
  end
end

factory :post do
  association :user, :admin, name: 'John Doe'
end

# creates an admin user with name "John Doe"
FactoryGirl.create(:post).user
```

When you're using association names that're different than the factory:

```ruby
factory :user do
  name "Friendly User"

  trait :admin do
    admin true
  end
end

factory :post do
  association :author, :admin, factory: :user, name: 'John Doe'
  # or
  association :author, factory: [:user, :admin], name: 'John Doe'
end

# creates an admin user with name "John Doe"
FactoryGirl.create(:post).author
```
Callbacks
---------

factory\_girl makes available four callbacks for injecting some code:

* after(:build)   - called after a factory is built   (via `FactoryGirl.build`, `FactoryGirl.create`)
* before(:create) - called before a factory is saved  (via `FactoryGirl.create`)
* after(:create)  - called after a factory is saved   (via `FactoryGirl.create`)
* after(:stub)    - called after a factory is stubbed (via `FactoryGirl.build_stubbed`)

Examples:

```ruby
# Define a factory that calls the generate_hashed_password method after it is built
factory :user do
  after(:build) { |user| generate_hashed_password(user) }
end
```

Note that you'll have an instance of the user in the block. This can be useful.

You can also define multiple types of callbacks on the same factory:

```ruby
factory :user do
  after(:build)  { |user| do_something_to(user) }
  after(:create) { |user| do_something_else_to(user) }
end
```

Factories can also define any number of the same kind of callback.  These callbacks will be executed in the order they are specified:

```ruby
factory :user do
  after(:create) { this_runs_first }
  after(:create) { then_this }
end
```

Calling FactoryGirl.create will invoke both `after_build` and `after_create` callbacks.

Also, like standard attributes, child factories will inherit (and can also define) callbacks from their parent factory.

Multiple callbacks can be assigned to run a block; this is useful when building various strategies that run the same code (since there are no callbacks that are shared across all strategies).

```ruby
factory :user do
  callback(:after_stub, :before_create) { do_something }
  after(:stub, :create) { do_something_else }
  before(:create, :custom) { do_a_third_thing }
end
```

Modifying factories
-------------------

If you're given a set of factories (say, from a gem developer) but want to change them to fit into your application better, you can
modify that factory instead of creating a child factory and adding attributes there.

If a gem were to give you a User factory:

```ruby
FactoryGirl.define do
  factory :user do
    full_name "John Doe"
    sequence(:username) {|n| "user#{n}" }
    password "password"
  end
end
```

Instead of creating a child factory that added additional attributes:

```ruby
FactoryGirl.define do
  factory :application_user, parent: :user do
    full_name     "Jane Doe"
    date_of_birth { 21.years.ago }
    gender        "Female"
    health        90
  end
end
```

You could modify that factory instead.

```ruby
FactoryGirl.modify do
  factory :user do
    full_name     "Jane Doe"
    date_of_birth { 21.years.ago }
    gender        "Female"
    health        90
  end
end
```

When modifying a factory, you can change any of the attributes you want (aside from callbacks).

`FactoryGirl.modify` must be called outside of a `FactoryGirl.define` block as it operates on factories differently.

A caveat: you can only modify factories (not sequences or traits) and callbacks *still compound as they normally would*. So, if
the factory you're modifying defines an `after(:create)` callback, you defining an `after(:create)` won't override it, it'll just get run after the first callback.

Building or Creating Multiple Records
-------------------------------------

Sometimes, you'll want to create or build multiple instances of a factory at once.

```ruby
built_users   = FactoryGirl.build_list(:user, 25)
created_users = FactoryGirl.create_list(:user, 25)
```

These methods will build or create a specific amount of factories and return them as an array.
To set the attributes for each of the factories, you can pass in a hash as you normally would.

```ruby
twenty_year_olds = FactoryGirl.build_list(:user, 25, date_of_birth: 20.years.ago)
```

Custom Construction
-------------------

If you want to use factory_girl to construct an object where some attributes
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
sequence(:name) {|n| "person#{n}@example.com" }

factory :user do
  ignore do
    name "Jane Doe"
  end

  email
  initialize_with { new(name) }
end

FactoryGirl.build(:user).name # Jane Doe
```

Notice that I ignored the `name` attribute. If you don't want attributes
reassigned after your object has been instantiated, you'll want to `ignore` them.

Although factory_girl is written to work with ActiveRecord out of the box, it
can also work with any Ruby class. For maximum compatibiltiy with ActiveRecord,
the default initializer builds all instances by calling new on your build class
without any arguments. It then calls attribute writer methods to assign all the
attribute values. While that works fine for ActiveRecord, it actually doesn't
work for almost any other Ruby class.

You can override the initializer in order to:

* Build non-ActiveRecord objects that require arguments to `initialize`
* Use a method other than `new` to instantiate the instance
* Do crazy things like decorate the instance after it's built

When using `initialize_with`, you don't have to declare the class itself when
calling `new`; however, any other class methods you want to call will have to
be called on the class explicitly.

For example:

```ruby
factory :user do
  ignore do
    name "John Doe"
  end

  initialize_with { User.build_with_name(name) }
end
```

You can also access all public attributes within the `initialize_with` block
by calling `attributes`:

```ruby
factory :user do
  ignore do
    comments_count 5
  end

  name "John Doe"

  initialize_with { new(attributes) }
end
```

This will build a hash of all attributes to be passed to `new`. It won't
include ignored attributes, but everything else defined in the factory will be
passed (associations, evalued sequences, etc.)

You can define `initialize_with` for all factories by including it in the
`FactoryGirl.define` block:

```ruby
FactoryGirl.define do
  initialize_with { new("Awesome first argument") }
end
```

When using `initialize_with`, attributes accessed from within the `initialize_with`
block are assigned *only* in the constructor; this equates to roughly the
following code:

```ruby
FactoryGirl.define do
  factory :user do
    initialize_with { new(name) }

    name { 'value' }
  end
end

FactoryGirl.build(:user)
# runs
User.new('value')
```

This prevents duplicate assignment; in versions of FactoryGirl before 4.0, it
would run this:

```ruby
FactoryGirl.define do
  factory :user do
    initialize_with { new(name) }

    name { 'value' }
  end
end

FactoryGirl.build(:user)
# runs
user = User.new('value')
user.name = 'value'
```

Custom Strategies
-----------------

There are times where you may want to extend behavior of factory\_girl by
adding a custom build strategy.

Strategies define two methods: `association` and `result`. `association`
receives a `FactoryGirl::FactoryRunner` instance, upon which you can call
`run`, overriding the strategy if you want. The second method, `result`,
receives a `FactoryGirl::Evaluation` instance. It provides a way to trigger
callbacks (with `notify`), `object` or `hash` (to get the result instance or a
hash based on the attributes defined in the factory), and `create`, which
executes the `to_create` callback defined on the factory.

To understand how factory\_girl uses strategies internally, it's probably
easiest to just view the source for each of the four default strategies.

Here's an example of composing a strategy using
`FactoryGirl::Strategy::Create` to build a JSON representation of your model.

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_json
  end
end
```

For factory\_girl to recognize the new strategy, you can register it:

```ruby
FactoryGirl.register_strategy(:json, JsonStrategy)
```

This allows you to call

```ruby
FactoryGirl.json(:user)
```

Finally, you can override factory\_girl's own strategies if you'd like by
registering a new object in place of the strategies.

Custom Callbacks
----------------

Custom callbacks can be defined if you're using custom strategies:

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    result = @strategy.result(evaluation)
    evaluation.notify(:before_json, result)

    result.to_json.tap do |json|
      evaluation.notify(:after_json, json)
      evaluation.notify(:make_json_awesome, json)
    end
  end
end

FactoryGirl.register_strategy(:json, JsonStrategy)

FactoryGirl.define do
  factory :user do
    before(:json)                {|user| do_something_to(user) }
    after(:json)                 {|user_json| do_something_to(user_json) }
    callback(:make_json_awesome) {|user_json| do_something_to(user_json) }
  end
end
```

Custom Methods to Persist Objects
---------------------------------

By default, creating a record will call `save!` on the instance; since this
may not always be ideal, you can override that behavior by defining
`to_create` on the factory:

```ruby
factory :different_orm_model do
  to_create {|instance| instance.persist! }
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
`FactoryGirl.define` block:

```ruby
FactoryGirl.define do
  to_create {|instance| instance.persist! }


  factory :user do
    name "John Doe"
  end
end
```

ActiveSupport Instrumentation
-----------------------------

In order to track what factories are created (and with what build strategy),
`ActiveSupport::Notifications` are included to provide a way to subscribe to
factories being run. One example would be to track factories based on a
threshold of execution time.

```ruby
ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
  execution_time_in_seconds = finish - start

  if execution_time_in_seconds >= 0.5
    $stderr.puts "Slow factory: #{payload[:name]} using strategy #{payload[:strategy]}"
  end
end
```

Another example would be tracking all factories and how they're used
throughout your test suite. If you're using RSpec, it's as simple as adding a
`before(:suite)` and `after(:suite)`:

```ruby
config.before(:suite) do
  @factory_girl_results = {}
  ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
    factory_name = payload[:name]
    strategy_name = payload[:strategy]
    @factory_girl_results[factory_name] ||= {}
    @factory_girl_results[factory_name][strategy_name] ||= 0
    @factory_girl_results[factory_name][strategy_name] += 1
  end
end

config.after(:suite) do
  puts @factory_girl_results
end
```

**Deprecated**

See our extensive reference, guides, and cookbook in [the factory_bot book][].

For information on integrations with third party libraries, such as RSpec or
Rails, see [the factory_bot wiki][].

 We also have [a detailed introductory video][], available for free on Upcase.

[a detailed introductory video]: https://upcase.com/videos/factory-bot?utm_source=github&utm_medium=open-source&utm_campaign=factory-girl
[the factory_bot book]: https://thoughtbot.github.io/factory_bot
[the factory_bot wiki]: https://github.com/thoughtbot/factory_bot/wiki

This document is deprecated and preserved for historical use. It may disappear
at any time.

Getting Started
===============

* [Setup](#setup)
  + [Update Your Gemfile](#update-your-gemfile)
  + [Configure your test suite](#configure-your-test-suite)
    - [RSpec](#rspec)
    - [Test::Unit](#testunit)
    - [Cucumber](#cucumber)
    - [Spinach](#spinach)
    - [Minitest](#minitest)
    - [Minitest::Spec](#minitestspec)
    - [minitest-rails](#minitest-rails)
* [Defining factories](#defining-factories)
  + [Factory name and attributes](#factory-name-and-attributes)
  + [Specifying the class explicitly](#specifying-the-class-explicitly)
  + [Hash attributes](#hash-attributes)
  + [Best practices](#best-practices)
  + [Definition file paths](#definition-file-paths)
  + [Static Attributes](#static-attributes)
* [Using factories](#using-factories)
  + [Build strategies](#build-strategies)
  + [Attribute overrides](#attribute-overrides)
  + [`build_stubbed` and `Marshal.dump`](#build_stubbed-and-marshaldump)
* [Aliases](#aliases)
* [Dependent Attributes](#dependent-attributes)
* [Transient Attributes](#transient-attributes)
  + [With other attributes](#with-other-attributes)
  + [With `attributes_for`](#with-attributes_for)
  + [With callbacks](#with-callbacks)
  + [With associations](#with-associations)
* [Method Name / Reserved Word Attributes](#method-name--reserved-word-attributes)
* [Inheritance](#inheritance)
  + [Nested factories](#nested-factories)
  + [Assigning parent explicitly](#assigning-parent-explicitly)
  + [Best practices](#best-practices-1)
* [Associations](#associations)
  + [Implicit definition](#implicit-definition)
  + [Explicit definition](#explicit-definition)
  + [Inline definition](#inline-definition)
  + [Specifying the factory](#specifying-the-factory)
  + [Overriding attributes](#overriding-attributes)
  + [Association overrides](#association-overrides)
  + [Build strategies](#build-strategies-1)
  + [`has_many` associations](#has_many-associations)
  + [`has_and_belongs_to_many` associations](#has_and_belongs_to_many-associations)
  + [Polymorphic associations](#polymorphic-associations)
  + [Interconnected associations](#interconnected-associations)
* [Sequences](#sequences)
  + [Global sequences](#global-sequences)
  + [With dynamic attributes](#with-dynamic-attributes)
  + [As implicit attributes](#as-implicit-attributes)
  + [Inline sequences](#inline-sequences)
  + [Initial value](#initial-value)
  + [Without a block](#without-a-block)
  + [Aliases](#aliases-1)
  + [Rewinding](#rewinding)
  + [Uniqueness](#uniqueness)
* [Traits](#traits)
  + [Defining traits](#defining-traits)
  + [As implicit attributes](#as-implicit-attributes-1)
  + [Attribute precedence](#attribute-precedence)
  + [In child factories](#in-child-factories)
  + [Using traits](#using-traits)
  + [With associations](#with-associations-1)
  + [Traits within traits](#traits-within-traits)
  + [With transient attributes](#with-transient-attributes)
  + [Enum traits](#enum-traits)
* [Callbacks](#callbacks)
  + [Default callbacks](#default-callbacks)
  + [Multiple callbacks](#multiple-callbacks)
  + [Global callbacks](#global-callbacks)
  + [Symbol#to_proc](#symbolto_proc)
* [Modifying factories](#modifying-factories)
* [Building or Creating Multiple Records](#building-or-creating-multiple-records)
* [Linting Factories](#linting-factories)
* [Custom Construction](#custom-construction)
* [Custom Strategies](#custom-strategies)
* [Custom Callbacks](#custom-callbacks)
* [Custom Methods to Persist Objects](#custom-methods-to-persist-objects)
* [ActiveSupport Instrumentation](#activesupport-instrumentation)
* [Rails Preloaders and RSpec](#rails-preloaders-and-rspec)
* [Using Without Bundler](#using-without-bundler)

Setup
-----

### Update Your Gemfile

If you're using Rails:

```ruby
gem "factory_bot_rails"
```

If you're *not* using Rails:

```ruby
gem "factory_bot"
```

### Configure your test suite

#### RSpec

If you're using Rails, add the following configuration to
`spec/support/factory_bot.rb` and be sure to require that file in
`rails_helper.rb`:

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

If you're *not* using Rails:

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
```

#### Test::Unit

```ruby
class Test::Unit::TestCase
  include FactoryBot::Syntax::Methods
end
```

#### Cucumber

```ruby
# env.rb (Rails example location - RAILS_ROOT/features/support/env.rb)
World(FactoryBot::Syntax::Methods)
```

#### Spinach

```ruby
class Spinach::FeatureSteps
  include FactoryBot::Syntax::Methods
end
```

#### Minitest

```ruby
class Minitest::Unit::TestCase
  include FactoryBot::Syntax::Methods
end
```

#### Minitest::Spec

```ruby
class Minitest::Spec
  include FactoryBot::Syntax::Methods
end
```

#### minitest-rails

```ruby
class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end
```

If you do not include `FactoryBot::Syntax::Methods` in your test suite, then all
factory\_bot methods will need to be prefaced with `FactoryBot`.

Defining factories
------------------

### Factory name and attributes

Each factory has a name and a set of attributes. The name is used to guess the
class of the object by default:

```ruby
# This will guess the User class
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

### Specifying the class explicitly

It is also possible to explicitly specify the class:

```ruby
# This will use the User class (otherwise Admin would have been guessed)
factory :admin, class: "User"
```

You can pass a constant as well, if the constant is available (note that this
can cause test performance problems in large Rails applications, since
referring to the constant will cause it to be eagerly loaded).

```ruby
factory :access_token, class: User
```

### Hash attributes

Because of the block syntax in Ruby, defining attributes as `Hash`es (for
serialized/JSON columns, for example) requires two sets of curly brackets:

```ruby
factory :program do
  configuration { { auto_resolve: false, auto_define: true } }
end
```

### Best practices

It is recommended that you have one factory for each class that provides
the simplest set of attributes necessary to create an instance of that class. If
you're creating ActiveRecord objects, that means that you should only provide
attributes that are required through validations and that do not have defaults.
Other factories can be created through inheritance to cover common scenarios for
each class.

Attempting to define multiple factories with the same name will raise an error.

### Definition file paths

Factories can be defined anywhere, but will be automatically loaded after
calling `FactoryBot.find_definitions` if factories are defined in files at the
following locations:

    test/factories.rb
    spec/factories.rb
    test/factories/*.rb
    spec/factories/*.rb

### Static Attributes

Static attributes (without a block) are no longer available in factory\_bot 5.
You can read more about the decision to remove them in
[this blog post](https://robots.thoughtbot.com/deprecating-static-attributes-in-factory_bot-4-11).


Using factories
---------------

### Build strategies

factory\_bot supports several different build strategies: build, create,
attributes\_for and build\_stubbed:

```ruby
# Returns a User instance that's not saved
user = build(:user)

# Returns a saved User instance
user = create(:user)

# Returns a hash of attributes that can be used to build a User instance
attrs = attributes_for(:user)

# Integrates with Ruby 3.0's support for pattern matching assignment
attributes_for(:user) => {email:, name:, **attrs}

# Returns an object with all defined attributes stubbed out
stub = build_stubbed(:user)

# Passing a block to any of the methods above will yield the return object
create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```

### Attribute overrides

No matter which strategy is used, it's possible to override the defined
attributes by passing a Hash:

```ruby
# Build a User instance and override the first_name property
user = build(:user, first_name: "Joe")
user.first_name
# => "Joe"
```

Overriding associations is also supported:

```ruby
account = build(:account, :deluxe)
friends = build_list(:user, 2)

user = build(:user, account: account, friends: friends)
```

Ruby 3.1's support for [omitting values][] from `Hash` literals dovetails with
attribute overrides and provides an opportunity to limit the repetition of
variable names:

```ruby
account = build(:account, :deluxe)
friends = build_list(:user, 2)

# The keyword arguments correspond to local variable names, so omit their values
user = build(:user, account:, friends:)
```

[omitting values]: https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals

### `build_stubbed` and `Marshal.dump`

Note that objects created with `build_stubbed` cannot be serialized with
`Marshal.dump`, since factory\_bot defines singleton methods on these objects.

Aliases
-------

factory\_bot allows you to define aliases to existing factories to make them
easier to re-use. This could come in handy when, for example, your Post object
has an author attribute that actually refers to an instance of a User class.
While normally factory\_bot can infer the factory name from the association name,
in this case it will look for an author factory in vain. So, alias your user
factory so it can be used under alias names.

```ruby
factory :user, aliases: [:author, :commenter] do
  first_name { "John" }
  last_name { "Doe" }
  date_of_birth { 18.years.ago }
end

factory :post do
  # The alias allows us to write author instead of
  # association :author, factory: :user
  author
  title { "How to read a book effectively" }
  body { "There are five steps involved." }
end

factory :comment do
  # The alias allows us to write commenter instead of
  # association :commenter, factory: :user
  commenter
  body { "Great article!" }
end
```

Dependent Attributes
--------------------

Attributes can be based on the values of other attributes using the evaluator
that is yielded to dynamic attribute blocks:

```ruby
factory :user do
  first_name { "Joe" }
  last_name  { "Blow" }
  email { "#{first_name}.#{last_name}@example.com".downcase }
end

create(:user, last_name: "Doe").email
# => "joe.doe@example.com"
```

Transient Attributes
--------------------
Transient attributes are attributes only available within the factory definition, and not set on the object being built. This allows for more complex logic inside factories.

### With other attributes

There may be times where your code can be DRYed up by passing in transient
attributes to factories. You can access transient attributes within other
attributes (see [Dependent Attributes](#dependent-attributes)):

```ruby
factory :user do
  transient do
    rockstar { true }
  end

  name { "John Doe#{" - Rockstar" if rockstar}" }
end

create(:user).name
#=> "John Doe - ROCKSTAR"

create(:user, rockstar: false).name
#=> "John Doe"
```

### With `attributes_for`

Transient attributes will be ignored within attributes\_for and won't be set on
the model, even if the attribute exists or you attempt to override it.

### With callbacks

If you need to access the evaluator in a factory\_bot callback,
you'll need to declare a second block argument (for the evaluator) and access
transient attributes from there.

```ruby
factory :user do
  transient do
    upcased { false }
  end

  name { "John Doe" }

  after(:create) do |user, evaluator|
    user.name.upcase! if evaluator.upcased
  end
end

create(:user).name
#=> "John Doe"

create(:user, upcased: true).name
#=> "JOHN DOE"
```

### With associations

Transient [associations](#associations) are not supported in factory\_bot.
Associations within the transient block will be treated as regular,
non-transient associations.

If needed, you can generally work around this by building a factory within a
transient attribute:

```ruby
factory :post

factory :user do
  transient do
    post { build(:post) }
  end
end
```

Method Name / Reserved Word Attributes
-------------------------------

If your attributes conflict with existing methods or reserved words (all methods in the [DefinitionProxy](https://github.com/thoughtbot/factory_bot/blob/main/lib/factory_bot/definition_proxy.rb) class) you can define them with `add_attribute`.

```ruby
factory :dna do
  add_attribute(:sequence) { 'GATTACA' }
end

factory :payment do
  add_attribute(:method) { 'paypal' }
end

```

Inheritance
-----------

### Nested factories

You can easily create multiple factories for the same class without repeating
common attributes by nesting factories:

```ruby
factory :post do
  title { "A title" }

  factory :approved_post do
    approved { true }
  end
end

approved_post = create(:approved_post)
approved_post.title    # => "A title"
approved_post.approved # => true
```

### Assigning parent explicitly

You can also assign the parent explicitly:

```ruby
factory :post do
  title { "A title" }
end

factory :approved_post, parent: :post do
  approved { true }
end
```

### Best practices

As mentioned above, it's good practice to define a basic factory for each class
with only the attributes required to create it. Then, create more specific
factories that inherit from this basic parent. Factory definitions are still
code, so keep them DRY.

Associations
------------

### Implicit definition

It's possible to set up associations within factories. If the factory name is
the same as the association name, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```

### Explicit definition

You can define associations explicitly. This can be handy especially when
[Overriding attributes](#overriding-attributes)

```ruby
factory :post do
  # ...
  association :author
end
```

### Inline definition

You can also define associations inline within regular attributes,
but note that the value will be `nil`
when using the `attributes_for` strategy.

```ruby
factory :post do
  # ...
  author { association :author }
end
```

### Specifying the factory

You can specify a different factory (although [Aliases](#aliases) might also
help you out here).

Implicitly:

```ruby
factory :post do
  # ...
  author factory: :user
end
```

Explicitly:

```ruby
factory :post do
  # ...
  association :author, factory: :user
end
```

Inline:

```ruby
factory :post do
  # ...
  author { association :user }
end
```

### Overriding attributes

You can also override attributes.

Implicitly:

```ruby
factory :post do
  # ...
  author factory: :author, last_name: "Writely"
end
```

Explicitly:


```ruby
factory :post do
  # ...
  association :author, last_name: "Writely"
end
```

Or inline using attributes from the factory:

```rb
factory :post do
  # ...
  author_last_name { "Writely" }
  author { association :author, last_name: author_last_name }
end
```

### Association overrides

Attribute overrides can be used to link associated objects:

```ruby
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    author
  end
end

eunji = build(:author, name: 'Eunji')
post = build(:post, author: eunji)
```

### Build strategies

In factory\_bot 5, associations default to using the same build strategy as
their parent object:

```ruby
FactoryBot.define do
  factory :author

  factory :post do
    author
  end
end

post = build(:post)
post.new_record?        # => true
post.author.new_record? # => true

post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false
```

This is different than the default behavior for previous versions of
factory\_bot, where the association strategy would not always match the strategy
of the parent object. If you want to continue using the old behavior, you can
set the `use_parent_strategy` configuration option to `false`.

```ruby
FactoryBot.use_parent_strategy = false

# Builds and saves a User and a Post
post = create(:post)
post.new_record?        # => false
post.author.new_record? # => false

# Builds and saves a User, and then builds but does not save a Post
post = build(:post)
post.new_record?        # => true
post.author.new_record? # => false
```

To not save the associated object, specify `strategy: :build` in the factory:

```ruby
FactoryBot.use_parent_strategy = false

factory :post do
  # ...
  association :author, factory: :user, strategy: :build
end

# Builds a User, and then builds a Post, but does not save either
post = build(:post)
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

### `has_many` associations

There are a few ways to generate data for a `has_many` relationship. The
simplest approach is to write a helper method in plain Ruby to tie together the
different records:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Rachel Sanchez" }
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, posts_count, user: user)
  end
end

create(:user).posts.length # 0
user_with_posts.posts.length # 5
user_with_posts(posts_count: 15).posts.length # 15
```

If you prefer to keep the object creation fully within factory\_bot, you can
build the posts in an `after(:create)` callback.


```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "John Doe" }

    # user_with_posts will create post data after the user has been created
    factory :user_with_posts do
      # posts_count is declared as a transient attribute available in the
      # callback via the evaluator
      transient do
        posts_count { 5 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end
  end
end

create(:user).posts.length # 0
create(:user_with_posts).posts.length # 5
create(:user_with_posts, posts_count: 15).posts.length # 15
```

Or, for a solution that works with `build`, `build_stubbed`, and `create`
(although it doesn't work well with `attributes_for`), you can use inline
associations:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Taylor Kim" }

    factory :user_with_posts do
      posts { [association(:post)] }
    end
  end
end

create(:user).posts.length # 0
create(:user_with_posts).posts.length # 1
build(:user_with_posts).posts.length # 1
build_stubbed(:user_with_posts).posts.length # 1
```

For more flexibility you can combine this with the `posts_count` transient
attribute from the callback example:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Adiza Kumato" }

    factory :user_with_posts do
      transient do
        posts_count { 5 }
      end

      posts do
        Array.new(posts_count) { association(:post) }
      end
    end
  end
end

create(:user_with_posts).posts.length # 5
create(:user_with_posts, posts_count: 15).posts.length # 15
build(:user_with_posts, posts_count: 15).posts.length # 15
build_stubbed(:user_with_posts, posts_count: 15).posts.length # 15
```

### `has_and_belongs_to_many` associations

Generating data for a `has_and_belongs_to_many` relationship is very similar
to the above `has_many` relationship, with a small change: you need to pass an
array of objects to the model's pluralized attribute name rather than a single
object to the singular version of the attribute name.


```ruby
def profile_with_languages(languages_count: 2)
  FactoryBot.create(:profile) do |profile|
    FactoryBot.create_list(:language, languages_count, profiles: [profile])
  end
end
```

Or with the callback approach:

```ruby
factory :profile_with_languages do
  transient do
    languages_count { 2 }
  end

  after(:create) do |profile, evaluator|
    create_list(:language, evaluator.languages_count, profiles: [profile])
    profile.reload
  end
end
```

Or the inline association approach (note the use of the `instance` method here
to refer to the profile being built):

```ruby
factory :profile_with_languages do
  transient do
    languages_count { 2 }
  end

  languages do
    Array.new(languages_count) do
      association(:language, profiles: [instance])
    end
  end
end
```

### Polymorphic associations

Polymorphic associations can be handled with traits:

```ruby
FactoryBot.define do
  factory :video
  factory :photo

  factory :comment do
    for_photo # default to the :for_photo trait if none is specified

    trait :for_video do
      association :commentable, factory: :video
    end

    trait :for_photo do
      association :commentable, factory: :photo
    end
  end
end
```

This allows us to do:

```ruby
create(:comment)
create(:comment, :for_video)
create(:comment, :for_photo)
```

### Interconnected associations

There are limitless ways objects might be interconnected, and
factory\_bot may not always be suited to handle those relationships. In some
cases it makes sense to use factory\_bot to build each individual object, and
then to write helper methods in plain Ruby to tie those objects together.

That said, some more complex, interconnected relationships can be built in factory\_bot
using inline associations with reference to the `instance` being built.

Let's say your models look like this, where an associated `Student` and
`Profile` should both belong to the same `School`:

```ruby
class Student < ApplicationRecord
  belongs_to :school
  has_one :profile
end

class Profile < ApplicationRecord
  belongs_to :school
  belongs_to :student
end

class School < ApplicationRecord
  has_many :students
  has_many :profiles
end
```

We can ensure the student and profile are connected to each other and to the
same school with a factory like this:

```ruby
FactoryBot.define do
  factory :student do
    school
    profile { association :profile, student: instance, school: school }
  end

  factory :profile do
    school
    student { association :student, profile: instance, school: school }
  end

  factory :school
end
```

Note that this approach works with `build`, `build_stubbed`, and `create`, but
the associations will return `nil` when using `attributes_for`.

Also, note that if you assign any attributes inside a custom `initialize_with`
(e.g. `initialize_with { new(**attributes) }`), those attributes should not refer to `instance`,
since it will be `nil`.

Sequences
---------

### Global sequences

Unique values in a specific format (for example, e-mail addresses) can be
generated using sequences. Sequences are defined by calling `sequence` in a
definition block, and values in a sequence are generated by calling
`generate`:

```ruby
# Defines a new sequence
FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

generate :email
# => "person1@example.com"

generate :email
# => "person2@example.com"
```

### With dynamic attributes

Sequences can be used in dynamic attributes:

```ruby
factory :invite do
  invitee { generate(:email) }
end
```

### As implicit attributes

Or as implicit attributes:

```ruby
factory :user do
  email # Same as `email { generate(:email) }`
end
```

Note that defining sequences as implicit attributes will not work if you have a
factory with the same name as the sequence.

### Inline sequences

And it's also possible to define an in-line sequence that is only used in
a particular factory:

```ruby
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end
```

With Ruby 2.7's support for [numbered parameters][], inline definitions can be
even more abbreviated:

```ruby
factory :user do
  sequence(:email) { "person#{_1}@example.com" }
end
```

[numbered parameters]: https://ruby-doc.org/core-2.7.1/Proc.html#class-Proc-label-Numbered+parameters

### Initial value

You can override the initial value. Any value that responds to the `#next`
method will work (e.g. 1, 2, 3, 'a', 'b', 'c')

```ruby
factory :user do
  sequence(:email, 1000) { |n| "person#{n}@example.com" }
end
```

### Without a block

Without a block, the value will increment itself, starting at its initial value:

```ruby
factory :post do
  sequence(:position)
end
```

Please note, that the value for the sequence could be any Enumerable instance,
as long as it responds to `#next`:

```ruby
factory :task do
  sequence :priority, %i[low medium high urgent].cycle
end
```

### Aliases

Sequences can also have aliases. The sequence aliases share the same counter:

```ruby
factory :user do
  sequence(:email, 1000, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end

# will increase value counter for :email which is shared by :sender and :receiver
generate(:sender)
```

Define aliases and use default value (1) for the counter

```ruby
factory :user do
  sequence(:email, aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

Setting the value:

```ruby
factory :user do
  sequence(:email, 'a', aliases: [:sender, :receiver]) { |n| "person#{n}@example.com" }
end
```

The value just needs to support the `#next` method. Here the next value will be 'a', then 'b', etc.

### Rewinding

Sequences can also be rewound with `FactoryBot.rewind_sequences`:

```ruby
sequence(:email) {|n| "person#{n}@example.com" }

generate(:email) # "person1@example.com"
generate(:email) # "person2@example.com"
generate(:email) # "person3@example.com"

FactoryBot.rewind_sequences

generate(:email) # "person1@example.com"
```

This rewinds all registered sequences.

### Uniqueness

When working with uniqueness constraints, be careful not to pass in override values that will conflict with the generated sequence values.

In this example the email will be the same for both users. If email must be unique, this code will error:

```rb
factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end

FactoryBot.create(:user, email: "person1@example.com")
FactoryBot.create(:user)
```


Traits
------

### Defining traits

Traits allow you to group attributes together and then apply them
to any factory.

```ruby
factory :user, aliases: [:author]

factory :story do
  title { "My awesome story" }
  author

  trait :published do
    published { true }
  end

  trait :unpublished do
    published { false }
  end

  trait :week_long_publishing do
    start_at { 1.week.ago }
    end_at { Time.now }
  end

  trait :month_long_publishing do
    start_at { 1.month.ago }
    end_at { Time.now }
  end

  factory :week_long_published_story,    traits: [:published, :week_long_publishing]
  factory :month_long_published_story,   traits: [:published, :month_long_publishing]
  factory :week_long_unpublished_story,  traits: [:unpublished, :week_long_publishing]
  factory :month_long_unpublished_story, traits: [:unpublished, :month_long_publishing]
end
```

### As implicit attributes

Traits can be used as implicit attributes:

```ruby
factory :week_long_published_story_with_title, parent: :story do
  published
  week_long_publishing
  title { "Publishing that was started at #{start_at}" }
end
```

Note that defining traits as implicit attributes will not work if you have a
factory or sequence with the same name as the trait.

### Attribute precedence

Traits that define the same attributes won't raise AttributeDefinitionErrors;
the trait that defines the attribute latest gets precedence.

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    name { "John Doe" }
    status { :active }
    login { "#{name} (active)" }
  end

  trait :inactive do
    name { "Jane Doe" }
    status { :inactive }
    login { "#{name} (inactive)" }
  end

  trait :admin do
    admin { true }
    login { "admin-#{name}" }
  end

  factory :active_admin,   traits: [:active, :admin]   # login will be "admin-John Doe"
  factory :inactive_admin, traits: [:admin, :inactive] # login will be "Jane Doe (inactive)"
end
```

### In child factories

You can override individual attributes granted by a trait in a child factory:

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    name { "John Doe" }
    status { :active }
    login { "#{name} (M)" }
  end

  factory :brandon do
    active
    name { "Brandon" }
  end
end
```

### As mixins

Traits can be defined outside of factories and used as mixins to compose shared attributes

```ruby
FactoryBot.define do
  trait :timestamps do
    created_at { 8.days.ago }
    updated_at { 4.days.ago }
  end

  factory :user, traits: [:timestamps] do
    username { "john_doe" }
  end

  factory :post do
    timestamps
    title { "Traits rock" }
  end
end
```

### Using traits

Traits can also be passed in as a list of symbols when you construct an instance
from factory\_bot.

```ruby
factory :user do
  name { "Friendly User" }

  trait :active do
    name { "John Doe" }
    status { :active }
  end

  trait :admin do
    admin { true }
  end
end

# creates an admin user with :active status and name "Jon Snow"
create(:user, :admin, :active, name: "Jon Snow")
```

This ability works with `build`, `build_stubbed`, `attributes_for`, and `create`.

`create_list` and `build_list` methods are supported as well. Just remember to pass
the number of instances to create/build as second parameter, as documented in the
"Building or Creating Multiple Records" section of this file.

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

# creates 3 admin users with :active status and name "Jon Snow"
create_list(:user, 3, :admin, :active, name: "Jon Snow")
```

### With associations

Traits can be used with associations easily too:

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

factory :post do
  association :user, :admin, name: 'John Doe'
end

# creates an admin user with name "John Doe"
create(:post).user
```

When you're using association names that're different than the factory:

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

factory :post do
  association :author, :admin, factory: :user, name: 'John Doe'
  # or
  association :author, factory: [:user, :admin], name: 'John Doe'
end

# creates an admin user with name "John Doe"
create(:post).author
```

### Traits within traits

Traits can be used within other traits to mix in their attributes.

```ruby
factory :order do
  trait :completed do
    completed_at { 3.days.ago }
  end

  trait :refunded do
    completed
    refunded_at { 1.day.ago }
  end
end
```

### With transient attributes

Finally, traits can accept transient attributes.

```ruby
factory :invoice do
  trait :with_amount do
    transient do
      amount { 1 }
    end

    after(:create) do |invoice, evaluator|
      create :line_item, invoice: invoice, amount: evaluator.amount
    end
  end
end

create :invoice, :with_amount, amount: 2
```

### Enum traits

Given an Active Record model with an enum attribute:

```rb
class Task < ActiveRecord::Base
  enum status: {queued: 0, started: 1, finished: 2}
end

```

factory\_bot will automatically define traits for each possible value of the
enum:

```rb
FactoryBot.define do
  factory :task
end

FactoryBot.build(:task, :queued)
FactoryBot.build(:task, :started)
FactoryBot.build(:task, :finished)
```

Writing the traits out manually would be cumbersome, and is not necessary:

```rb
FactoryBot.define do
  factory :task do
    trait :queued do
      status { :queued }
    end

    trait :started do
      status { :started }
    end

    trait :finished do
      status { :finished }
    end
  end
end
```

If automatically defining traits for enum attributes on every factory is not
desired, it is possible to disable the feature by setting
`FactoryBot.automatically_define_enum_traits = false`

In that case, it is still possible to explicitly define traits for an enum
attribute in a particular factory:

```rb
FactoryBot.automatically_define_enum_traits = false

FactoryBot.define do
  factory :task do
    traits_for_enum(:status)
  end
end
```

It is also possible to use this feature for other enumerable values, not
specifically tied to Active Record enum attributes.

With an array:

```rb
class Task
  attr_accessor :status
end

FactoryBot.define do
  factory :task do
    traits_for_enum(:status, ["queued", "started", "finished"])
  end
end
```

Or with a hash:

```rb
class Task
  attr_accessor :status
end

FactoryBot.define do
  factory :task do
    traits_for_enum(:status, { queued: 0, started: 1, finished: 2 })
  end
end
```

Callbacks
---------

### Default callbacks

factory\_bot makes available four callbacks for injecting some code:

* after(:build)   - called after a factory is built   (via `FactoryBot.build`, `FactoryBot.create`)
* before(:create) - called before a factory is saved  (via `FactoryBot.create`)
* after(:create)  - called after a factory is saved   (via `FactoryBot.create`)
* after(:stub)    - called after a factory is stubbed (via `FactoryBot.build_stubbed`)

Examples:

```ruby
# Define a factory that calls the generate_hashed_password method after it is built
factory :user do
  after(:build) { |user| generate_hashed_password(user) }
end
```

Note that you'll have an instance of the user in the block. This can be useful.

### Multiple callbacks

You can also define multiple types of callbacks on the same factory:

```ruby
factory :user do
  after(:build)  { |user| do_something_to(user) }
  after(:create) { |user| do_something_else_to(user) }
end
```

Factories can also define any number of the same kind of callback.  These
callbacks will be executed in the order they are specified:

```ruby
factory :user do
  after(:create) { this_runs_first }
  after(:create) { then_this }
end
```

Calling `create` will invoke both `after_build` and `after_create` callbacks.

Also, like standard attributes, child factories will inherit (and can also
define) callbacks from their parent factory.

Multiple callbacks can be assigned to run a block; this is useful when building
various strategies that run the same code (since there are no callbacks that are
shared across all strategies).

```ruby
factory :user do
  callback(:after_stub, :before_create) { do_something }
  after(:stub, :create) { do_something_else }
  before(:create, :custom) { do_a_third_thing }
end
```

### Global callbacks

To override callbacks for all factories, define them within the
`FactoryBot.define` block:

```ruby
FactoryBot.define do
  after(:build) { |object| puts "Built #{object}" }
  after(:create) { |object| AuditLog.create(attrs: object.attributes) }

  factory :user do
    name { "John Doe" }
  end
end
```

### Symbol#to_proc

You can call callbacks that rely on `Symbol#to_proc`:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  def confirm!
    # confirm the user account
  end
end

# spec/factories.rb
FactoryBot.define do
  factory :user do
    after :create, &:confirm!
  end
end

create(:user) # creates the user and confirms it
```

Modifying factories
-------------------

If you're given a set of factories (say, from a gem developer) but want to
change them to fit into your application better, you can modify that factory
instead of creating a child factory and adding attributes there.

If a gem were to give you a User factory:

```ruby
FactoryBot.define do
  factory :user do
    full_name { "John Doe" }
    sequence(:username) { |n| "user#{n}" }
    password { "password" }
  end
end
```

Instead of creating a child factory that added additional attributes:

```ruby
FactoryBot.define do
  factory :application_user, parent: :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

You could modify that factory instead.

```ruby
FactoryBot.modify do
  factory :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

When modifying a factory, you can change any of the attributes you want (aside from callbacks).

`FactoryBot.modify` must be called outside of a `FactoryBot.define` block as it operates on factories differently.

A caveat: you can only modify factories (not sequences or traits) and callbacks *still compound as they normally would*. So, if
the factory you're modifying defines an `after(:create)` callback, you defining an `after(:create)` won't override it, it'll just get run after the first callback.

Building or Creating Multiple Records
-------------------------------------

Sometimes, you'll want to create or build multiple instances of a factory at once.

```ruby
built_users   = build_list(:user, 25)
created_users = create_list(:user, 25)
```

These methods will build or create a specific amount of factories and return them as an array.
To set the attributes for each of the factories, you can pass in a hash as you normally would.

```ruby
twenty_year_olds = build_list(:user, 25, date_of_birth: 20.years.ago)
```

In order to set different attributes for each factory, these methods may be passed a block, with the factory and the index as parameters:

```ruby
twenty_somethings = build_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
end
```

`create_list` passes saved instances into the block. If you modify the instance, you must save it again:

```ruby
twenty_somethings = create_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
  user.save!
end
```

`build_stubbed_list` will give you fully stubbed out instances:

```ruby
stubbed_users = build_stubbed_list(:user, 25) # array of stubbed users
```

There's also a set of `*_pair` methods for creating two records at a time:

```ruby
built_users   = build_pair(:user) # array of two built users
created_users = create_pair(:user) # array of two created users
```

If you need multiple attribute hashes, `attributes_for_list` will generate them:

```ruby
users_attrs = attributes_for_list(:user, 25) # array of attribute hashes
```

Linting Factories
-----------------

factory\_bot allows for linting known factories:

```ruby
FactoryBot.lint
```

`FactoryBot.lint` creates each factory and catches any exceptions raised
during the creation process. `FactoryBot::InvalidFactoryError` is raised with
a list of factories (and corresponding exceptions) for factories which could
not be created.

Recommended usage of `FactoryBot.lint`
is to run this in a task
before your test suite is executed.
Running it in a `before(:suite)`,
will negatively impact the performance
of your tests
when running single tests.

Example Rake task:

```ruby
# lib/tasks/factory_bot.rake
namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      conn = ActiveRecord::Base.connection
      conn.transaction do
        FactoryBot.lint
        raise ActiveRecord::Rollback
      end
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero?
    end
  end
end
```

After calling `FactoryBot.lint`, you'll likely want to clear out the
database, as records will most likely be created. The provided example above
uses an sql transaction and rollback to leave the database clean.

You can lint factories selectively by passing only factories you want linted:

```ruby
factories_to_lint = FactoryBot.factories.reject do |factory|
  factory.name =~ /^old_/
end

FactoryBot.lint factories_to_lint
```

This would lint all factories that aren't prefixed with `old_`.

Traits can also be linted. This option verifies that each
and every trait of a factory generates a valid object on its own.
This is turned on by passing `traits: true` to the `lint` method:

```ruby
FactoryBot.lint traits: true
```

This can also be combined with other arguments:

```ruby
FactoryBot.lint factories_to_lint, traits: true
```

You can also specify the strategy used for linting:

```ruby
FactoryBot.lint strategy: :build
```

Verbose linting will include full backtraces for each error, which can be
helpful for debugging:

```ruby
FactoryBot.lint verbose: true
```

Custom Construction
-------------------

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
the default initializer builds all instances by calling `new` on your build class
without any arguments. It then calls attribute writer methods to assign all the
attribute values. While that works fine for ActiveRecord, it actually doesn't
work for almost any other Ruby class.

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
include transient attributes, but everything else defined in the factory will be
passed (associations, evaluated sequences, etc.)

You can define `initialize_with` for all factories by including it in the
`FactoryBot.define` block:

```ruby
FactoryBot.define do
  initialize_with { new("Awesome first argument") }
end
```

When using `initialize_with`, attributes accessed from within the `initialize_with`
block are assigned *only* in the constructor; this equates to roughly the
following code:

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

Custom Strategies
-----------------

There are times where you may want to extend behavior of factory\_bot by
adding a custom build strategy.

Strategies define two methods: `association` and `result`. `association`
receives a `FactoryBot::FactoryRunner` instance, upon which you can call
`run`, overriding the strategy if you want. The second method, `result`,
receives a `FactoryBot::Evaluation` instance. It provides a way to trigger
callbacks (with `notify`), `object` or `hash` (to get the result instance or a
hash based on the attributes defined in the factory), and `create`, which
executes the `to_create` callback defined on the factory.

To understand how factory\_bot uses strategies internally, it's probably
easiest to just view the source for each of the four default strategies.

Here's an example of composing a strategy using
`FactoryBot::Strategy::Create` to build a JSON representation of your model.

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_json
  end

  def to_sym
    :json
  end
end
```

For factory\_bot to recognize the new strategy, you can register it:

```ruby
FactoryBot.register_strategy(:json, JsonStrategy)
```

This allows you to call

```ruby
FactoryBot.json(:user)
```

Finally, you can override factory\_bot's own strategies if you'd like by
registering a new object in place of the strategies.

Custom Callbacks
----------------

Custom callbacks can be defined if you're using custom strategies:

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
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

  def to_sym
    :json
  end
end

FactoryBot.register_strategy(:json, JsonStrategy)

FactoryBot.define do
  factory :user do
    before(:json)                { |user| do_something_to(user) }
    after(:json)                 { |user_json| do_something_to(user_json) }
    callback(:make_json_awesome) { |user_json| do_something_to(user_json) }
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

ActiveSupport Instrumentation
-----------------------------

In order to track what factories are created (and with what build strategy),
`ActiveSupport::Notifications` are included to provide a way to subscribe to
factories being compiled and run. One example would be to track factories based on a
threshold of execution time.

```ruby
ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |name, start, finish, id, payload|
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
factory_bot_results = {}
config.before(:suite) do
  ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |name, start, finish, id, payload|
    factory_name = payload[:name]
    strategy_name = payload[:strategy]
    factory_bot_results[factory_name] ||= {}
    factory_bot_results[factory_name][strategy_name] ||= 0
    factory_bot_results[factory_name][strategy_name] += 1
  end
end

config.after(:suite) do
  puts factory_bot_results
end
```

Another example could involve tracking the attributes and traits that factories are compiled with. If you're using RSpec, you could add `before(:suite)` and `after(:suite)` blocks that subscribe to `factory_bot.compile_factory` notifications:

```ruby
factory_bot_results = {}
config.before(:suite) do
  ActiveSupport::Notifications.subscribe("factory_bot.compile_factory") do |name, start, finish, id, payload|
    factory_name = payload[:name]
    factory_class = payload[:class]
    attributes = payload[:attributes]
    traits = payload[:traits]
    factory_bot_results[factory_class] ||= {}
    factory_bot_results[factory_class][factory_name] = {
      attributes: attributes.map(&:name)
      traits: traits.map(&:name)
    }
  end
end

config.after(:suite) do
  puts factory_bot_results
end
```

Rails Preloaders and RSpec
--------------------------

When running RSpec with a Rails preloader such as `spring` or `zeus`, it's possible
to encounter an `ActiveRecord::AssociationTypeMismatch` error when creating a factory
with associations, as below:

```ruby
FactoryBot.define do
  factory :united_states, class: "Location" do
    name { 'United States' }
    association :location_group, factory: :north_america
  end

  factory :north_america, class: "LocationGroup" do
    name { 'North America' }
  end
end
```

The error occurs during the run of the test suite:

```
Failure/Error: united_states = create(:united_states)
ActiveRecord::AssociationTypeMismatch:
  LocationGroup(#70251250797320) expected, got LocationGroup(#70251200725840)
```

The two possible solutions are to either run the suite without the preloader, or
to add `FactoryBot.reload` to the RSpec configuration, like so:

```ruby
RSpec.configure do |config|
  config.before(:suite) { FactoryBot.reload }
end
```

Using Without Bundler
---------------------

If you're not using Bundler, be sure to have the gem installed and call:

```ruby
require 'factory_bot'
```

Once required, assuming you have a directory structure of `spec/factories` or
`test/factories`, all you'll need to do is run:

```ruby
FactoryBot.find_definitions
```

If you're using a separate directory structure for your factories, you can
change the definition file paths before trying to find definitions:

```ruby
FactoryBot.definition_file_paths = %w(custom_factories_directory)
FactoryBot.find_definitions
```

If you don't have a separate directory of factories and would like to define
them inline, that's possible as well:

```ruby
require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    date_of_birth { 21.years.ago }
  end
end
```

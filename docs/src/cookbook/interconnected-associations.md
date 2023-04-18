# Interconnected associations

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

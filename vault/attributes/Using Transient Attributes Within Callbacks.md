---
type: note
created: 2025-11-07T18:18:01-06:00
updated: 2025-11-07T18:18:17-06:00
tags: []
aliases: []
---
# Using Transient Attributes Within Callbacks

If you need to access the evaluated definition itself in a factory\_bot callback, you'll need to declare a second block argument (for the definition) and access transient attributes from there. This represents the final, evaluated value.

```ruby
factory :user do
  transient do
    upcased { false }
  end

  name { "John Doe" }

  after(:create) do |user, context|
    user.name.upcase! if context.upcased
  end
end

create(:user).name
#=> "John Doe"

create(:user, upcased: true).name
#=> "JOHN DOE"
```

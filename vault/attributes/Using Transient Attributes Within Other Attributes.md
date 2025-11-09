---
type: note
created: 2025-11-07T18:18:16-06:00
updated: 2025-11-07T18:27:42-06:00
tags: []
aliases: []
---
# Using Transient Attributes Within Other Attributes

You can access transient attributes within other attributes (see [[Dependent Attributes]])

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

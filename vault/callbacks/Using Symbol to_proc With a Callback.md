---
type: note
created: 2025-11-07T19:31:22-06:00
updated: 2025-11-07T19:31:47-06:00
tags: []
aliases: []
---
# Using Symbol to_proc With a Callback

You can declare callbacks that rely on `Symbol#to_proc`:

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

# Symbol#to_proc

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

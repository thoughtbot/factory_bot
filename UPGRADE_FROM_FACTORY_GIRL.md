# Upgrade from factory\_girl

Upgrading your codebase should involve only a few steps, and in most cases, it
involves updating the Gemfile, factories file(s), and support file configuring
the testing framework.

## Modify your Gemfile

Replace references to factory\_girl\_rails or factory\_girl with
factory\_bot\_rails or factory\_bot. Both new gems are available starting at
version 4.8.2.

```ruby
# Gemfile

# old
group :development, :test do
  gem "factory_girl_rails"
  # or
  gem "factory_girl"
end

# new
group :development, :test do
  gem "factory_bot_rails"
  # or
  gem "factory_bot"
end
```

## Make a Copy of Factory Bot Module

Just add to config/environment.rb 
```ruby
  if Rails.env.test?
    FactoryGirl = FactoryBot.dup
  end
```
just before 

```ruby
# Initialize the Rails application.
Rails.application.initialize!
```
and you are fine.

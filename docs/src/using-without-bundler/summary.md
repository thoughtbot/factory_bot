# Using Without Bundler

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

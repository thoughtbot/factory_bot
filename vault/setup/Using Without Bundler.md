# Using Without Bundler

If you're not using Bundler, be sure to have the gem installed and then require `factory_bot` in your code. Once added to your application, you'll need to setup your test environment as well by instructing FactoryBot to find all the factory definitions. 

FactoryBot will, by default, assume that you have a directory structure of `spec/factories` or `test/factories` that houses your factory definitions. Alternate configuration options are also possible.

To setup `factory_bot`, do the following:

1. Install the `factory_bot` gem
   
    ```shell
    gem install factory_bot
    ```
2.  Require `factory_bot` inside your code
   
    ```ruby
    require 'factory_bot'
    ```
    
1. Setup your test environment by instructing FactoryBot to find all the factory definitions
   
    ```ruby
    FactoryBot.find_definitions
    ```

## Configure a Separate Directory Structure

To use a custom directory structure for your factories, you will need to change the definition file paths configuration before trying to find definitions:

```ruby
FactoryBot.definition_file_paths = %w(custom_factories_directory)
FactoryBot.find_definitions
```

## Define Factories Inline

If you don't have a separate directory of factories and would like to define them inline, that's possible as well:

```ruby
require 'factory_bot'

FactoryBot.define do
  factory :user do
	name { 'John Doe' }
	date_of_birth { 21.years.ago }
  end
end
```

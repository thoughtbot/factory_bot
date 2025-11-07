---
type: note
created: 2025-08-29T16:40:36-05:00
updated: 2025-08-29T17:05:25-05:00
tags: []
aliases: []
---
# Linting Factories

FactoryBot provides the means to lint known factories:

```ruby
FactoryBot.lint
```

Once invoked, the `FactoryBot.lint` method tries each factory and raises `FactoryBot::InvalidFactoryError` on failure. Any exceptions raised during the creation process are caught. The error includes a list of factories — and the corresponding exceptions — for factories which could not be created. 

## Arguments

`Factorybot.lint` can take the following optional arguments:

- A splat of factory names to restrict the linting to only the ones listed. The default is *all*.
- `:strategy` - the [[Build Strategies|build strategy]] to use. The default is `:create`.
- `:traits` - whether to try building each trait, too. The default is `false`.
- `:verbose` - whether to show a stack trace on error. The default is `false`.

## Recommended Usage

The recommended usage of `FactoryBot.lint` is to run this in a separate task before your test suite is executed. Running it in a `before(:suite)` will negatively impact the performance of your tests when running single tests.

### Example Rake Task

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

### Clearing out the Database

After calling `FactoryBot.lint`, you'll likely want to clear out the database, as records will most likely be created. The provided example above uses an SQL transaction and rollback to leave the database clean.

## Lint Configuration
### Selective Linting

You can lint factories selectively by passing only factories you want linted:

```ruby
factories_to_lint = FactoryBot.factories.reject do |factory|
  factory.name =~ /^old_/
end

FactoryBot.lint factories_to_lint
```

This would lint all factories that aren't prefixed with `old_`.

### Enable Linting of Traits

Traits can also be linted. This option verifies that each and every trait of a factory generates a valid object on its own. This is turned on by passing `traits: true` to the `lint` method:

```ruby
FactoryBot.lint traits: true
```

### Combine Configuration Options

The `traits` config option can be combined with other arguments:

```ruby
FactoryBot.lint factories_to_lint, traits: true
```

### Lint a Specific Strategy

You can also specify the strategy used for linting:

```ruby
FactoryBot.lint strategy: :build
```

### Verbose Linting

Verbose linting will include full backtraces for each error, which can be helpful for debugging:

```ruby
FactoryBot.lint verbose: true
```

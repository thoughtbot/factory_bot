# Linting Factories

factory\_bot allows for linting known factories:

```ruby
FactoryBot.lint
```

`FactoryBot.lint` creates each factory and catches any exceptions raised during
the creation process. `FactoryBot::InvalidFactoryError` is raised with a list
of factories (and corresponding exceptions) for factories which could not be
created.

Recommended usage of `FactoryBot.lint` is to run this in a separate task before
your test suite is executed. Running it in a `before(:suite)` will negatively
impact the performance of your tests when running single tests.

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

After calling `FactoryBot.lint`, you'll likely want to clear out the database,
as records will most likely be created. The provided example above uses an SQL
transaction and rollback to leave the database clean.

You can lint factories selectively by passing only factories you want linted:

```ruby
factories_to_lint = FactoryBot.factories.reject do |factory|
  factory.name =~ /^old_/
end

FactoryBot.lint factories_to_lint
```

This would lint all factories that aren't prefixed with `old_`.

Traits can also be linted. This option verifies that each and every trait of a
factory generates a valid object on its own. This is turned on by passing
`traits: true` to the `lint` method:

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

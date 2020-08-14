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

## Replace All Constant References

A global find-and-replace of `FactoryGirl` to `FactoryBot` across the codebase
to replace all references with the new constant should do the trick.
For macOS you can do:

```sh
grep -e FactoryGirl **/*.rake **/*.rb -s -l | xargs sed -i "" "s|FactoryGirl|FactoryBot|g"
```

For Linux:

```sh
grep -r -e FactoryGirl -i --include *.rake --include *.rb -l | xargs sed -i 's/FactoryGirl/FactoryBot/g'
```

If these examples don't work for you, various other approaches
have been suggested in pull requests [#1070](https://github.com/thoughtbot/factory_bot/pull/1070), [#1075](https://github.com/thoughtbot/factory_bot/pull/1075), [#1084](https://github.com/thoughtbot/factory_bot/pull/1084), [#1095](https://github.com/thoughtbot/factory_bot/pull/1095), and [#1102](https://github.com/thoughtbot/factory_bot/pull/1102).

## Replace All Path References

If you're requiring files from factory\_girl or factory\_girl\_rails directly,
you'll have to update the paths.

```sh
grep -e factory_girl **/*.rake **/*.rb -s -l | xargs sed -i "" "s|factory_girl|factory_bot|g"
```

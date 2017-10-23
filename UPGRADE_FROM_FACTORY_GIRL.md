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
to replace all references with the new constant should do the trick. For
example, on OS X:

```sh
grep -e FactoryGirl **/*.rake **/*.rb -l | xargs sed -i "" "s|FactoryGirl|FactoryBot|"
```

## Replace All Path References

If you're requiring files from factory\_girl or factory\_girl\_rails directly,
you'll have to update the paths.

```sh
grep -e factory_girl **/*.rake **/*.rb -l | xargs sed -i "" "s|factory_girl|factory_bot|"
```
